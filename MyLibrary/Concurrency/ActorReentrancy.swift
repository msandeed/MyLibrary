//
//  ActorReentrancyExample.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/08/2026.
//

import SwiftUI

// An actor only guarantees exclusive access to its state *between* suspension points. Any
// `await` inside an actor-isolated method is a point where the actor is free to run another
// queued call to completion before this one resumes — that's reentrancy. It's not a bug in
// actors; it's what stops one slow call from blocking the actor for everyone else. The bug shows
// up when code assumes nothing changed across that `await`.
actor TicketBooth {
    private(set) var remainingTickets: Int

    init(remainingTickets: Int) {
        self.remainingTickets = remainingTickets
    }

    // Stands in for a real external dependency — a payment gateway, a database write — that has
    // to be awaited before we know whether to commit. It doesn't touch the booth's state, so
    // it's nonisolated: no need to occupy the actor's executor just to wait on someone else.
    nonisolated private func confirmPayment() async -> Bool {
        try? await Task.sleep(for: .milliseconds(50))
        return true
    }

    // BUGGY: checks the invariant, awaits, then mutates on the assumption the check still holds.
    // Two concurrent callers can both pass `remainingTickets > 0` while the first is suspended
    // in `confirmPayment()`, then both decrement after resuming — overselling the one ticket.
    func buyTicketReentrant() async -> Bool {
        guard remainingTickets > 0 else { return false }
        guard await confirmPayment() else { return false }
        remainingTickets -= 1
        return true
    }

    // FIXED: the `await` before the mutation can't just be moved — we only know whether to
    // commit *after* payment confirms. So instead of trusting the check made before suspending,
    // re-validate the same invariant immediately after resuming, right before the mutation, with
    // no further suspension in between. That's the general-purpose fix for reentrancy: it's not
    // "never await before mutating," it's "never mutate on a fact you haven't just re-checked."
    func buyTicketFixed() async -> Bool {
        guard remainingTickets > 0 else { return false }
        guard await confirmPayment() else { return false }
        guard remainingTickets > 0 else { return false }
        remainingTickets -= 1
        return true
    }
}

struct ActorReentrancyExampleDataProvider {
    struct Outcome {
        let buyer1Succeeded: Bool
        let buyer2Succeeded: Bool
        let remainingTickets: Int
    }

    // Two buyers race the same actor for a single ticket. `async let` starts both child tasks
    // right away, so their calls land on the booth back to back, before either has had a chance
    // to suspend inside `confirmPayment()` — the setup reentrancy needs to actually manifest.
    func runReentrant() async -> Outcome {
        let booth = TicketBooth(remainingTickets: 1)
        async let buyer1 = booth.buyTicketReentrant()
        async let buyer2 = booth.buyTicketReentrant()
        let (result1, result2) = await (buyer1, buyer2)
        return Outcome(
            buyer1Succeeded: result1,
            buyer2Succeeded: result2,
            remainingTickets: await booth.remainingTickets
        )
    }

    func runFixed() async -> Outcome {
        let booth = TicketBooth(remainingTickets: 1)
        async let buyer1 = booth.buyTicketFixed()
        async let buyer2 = booth.buyTicketFixed()
        let (result1, result2) = await (buyer1, buyer2)
        return Outcome(
            buyer1Succeeded: result1,
            buyer2Succeeded: result2,
            remainingTickets: await booth.remainingTickets
        )
    }
}

@MainActor
class ActorReentrancyExampleViewModel: ObservableObject {
    @Published private(set) var reentrantOutcome: ActorReentrancyExampleDataProvider.Outcome?
    @Published private(set) var fixedOutcome: ActorReentrancyExampleDataProvider.Outcome?
    @Published private(set) var isRunning = false

    private let dataProvider = ActorReentrancyExampleDataProvider()

    func run() {
        isRunning = true
        reentrantOutcome = nil
        fixedOutcome = nil
        Task {
            reentrantOutcome = await dataProvider.runReentrant()
            fixedOutcome = await dataProvider.runFixed()
            isRunning = false
        }
    }
}

struct ActorReentrancyExample: View {
    @StateObject private var viewModel = ActorReentrancyExampleViewModel()

    var body: some View {
        Form {
            outcomeSection(
                title: "Reentrant — no re-check after resuming",
                outcome: viewModel.reentrantOutcome,
                expectation: "Expected: both buyers succeed, 1 ticket oversold (-1 remaining)."
            )
            outcomeSection(
                title: "Fixed — invariant re-checked after resuming",
                outcome: viewModel.fixedOutcome,
                expectation: "Expected: one buyer succeeds, one is turned away, 0 remaining."
            )
            Section {
                Button("Run both") { viewModel.run() }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.isRunning)
            }
        }
        .navigationTitle("Actor Reentrancy")
    }

    @ViewBuilder
    private func outcomeSection(
        title: String,
        outcome: ActorReentrancyExampleDataProvider.Outcome?,
        expectation: String
    ) -> some View {
        Section(title) {
            if let outcome {
                resultRow("Buyer 1", succeeded: outcome.buyer1Succeeded)
                resultRow("Buyer 2", succeeded: outcome.buyer2Succeeded)
                HStack {
                    Text("Remaining tickets")
                    Spacer()
                    Text("\(outcome.remainingTickets)")
                        .foregroundStyle(outcome.remainingTickets < 0 ? .red : .primary)
                }
            } else {
                Text("Not run yet")
                    .foregroundStyle(.secondary)
            }
            Text(expectation)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func resultRow(_ label: String, succeeded: Bool) -> some View {
        HStack {
            Text(label)
            Spacer()
            Image(systemName: succeeded ? "checkmark.circle.fill" : "xmark.circle")
                .foregroundStyle(succeeded ? .green : .red)
        }
    }
}

#Preview {
    ActorReentrancyExample()
}
