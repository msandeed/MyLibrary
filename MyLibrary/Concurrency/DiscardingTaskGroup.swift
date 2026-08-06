//
//  DiscardingTaskGroupExample.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/08/2026.
//

import SwiftUI

// withTaskGroup / withThrowingTaskGroup (see TaskGroupExample.swift) buffer each child's result
// until something iterates the group with `for await` / `for try await` — that's how you collect
// values back out. If a child only performs a side effect and returns Void, there's nothing worth
// collecting, but the group still has to hold each finished child's (empty) result until iterated.
// withDiscardingTaskGroup / withThrowingDiscardingTaskGroup drop that requirement entirely: a
// child's result is discarded the instant it completes, there's no AsyncSequence to iterate, and
// memory use stays flat no matter how many children run — the reason to reach for a discarding
// group over a plain one isn't "I don't want the values," it's "I have too many children for a
// plain group to hold their bookkeeping efficiently."

// withDiscardingTaskGroup / withThrowingDiscardingTaskGroup are iOS 17+ (their non-discarding
// counterparts go back to iOS 13/15), so every type below that touches them needs the annotation —
// the deployment target for this project is 15.2/16.0.

// Child tasks are Void, so progress has to be observed from outside the group via an actor rather
// than by collecting return values.
@available(iOS 17.0, *)
private actor ProgressTracker {
    private(set) var completedCount = 0

    func recordCompletion() {
        completedCount += 1
    }
}

@available(iOS 17.0, *)
struct DiscardingTaskGroupExampleDataProvider {
    struct JobFailure: Error {
        let jobID: Int
    }

    // withDiscardingTaskGroup: no `for await` loop, because there's no per-child result to read —
    // the closure returns once every added child has finished. Fire-and-forget by design.
    func runManyFireAndForgetJobs(count: Int) async -> Int {
        let tracker = ProgressTracker()
        // Unlike withTaskGroup, there's no `of:` child-result type to name — a discarding
        // group's children always return Void, since there's nowhere to put anything else.
        await withDiscardingTaskGroup { group in
            for _ in 0 ..< count {
                group.addTask {
                    try? await Task.sleep(for: .milliseconds(.random(in: 5 ... 30)))
                    await tracker.recordCompletion()
                }
            }
        }
        return await tracker.completedCount
    }

    // withThrowingDiscardingTaskGroup: the moment any child throws, the group automatically
    // cancels every other child and rethrows out of the call itself. Contrast with
    // withThrowingTaskGroup, where a child's error just sits there as a value to be thrown by
    // `for try await` — nothing propagates, and siblings aren't cancelled, until something
    // actually iterates the group and hits it.
    //
    // Completed count is nondeterministic across runs: it depends on how many jobs happened to
    // finish their random sleep before the failing job's sleep ended and triggered cancellation.
    func runJobsUntilFirstFailure(count: Int, failingJobID: Int) async throws -> Int {
        let tracker = ProgressTracker()
        try await withThrowingDiscardingTaskGroup { group in
            for jobID in 0 ..< count {
                group.addTask {
                    try await Task.sleep(for: .milliseconds(.random(in: 5 ... 30)))
                    if jobID == failingJobID {
                        throw JobFailure(jobID: jobID)
                    }
                    await tracker.recordCompletion()
                }
            }
        }
        return await tracker.completedCount
    }
}

@available(iOS 17.0, *)
@MainActor
class DiscardingTaskGroupExampleViewModel: ObservableObject {
    @Published private(set) var fireAndForgetStatus = "Not run yet"
    @Published private(set) var throwingStatus = "Not run yet"
    @Published private(set) var isRunningFireAndForget = false
    @Published private(set) var isRunningThrowing = false

    private let dataProvider = DiscardingTaskGroupExampleDataProvider()
    private let jobCount = 500
    private let throwingJobCount = 50
    private let failingJobID = 10

    func runFireAndForget() {
        isRunningFireAndForget = true
        fireAndForgetStatus = "Running \(jobCount) jobs…"
        Task {
            let completed = await dataProvider.runManyFireAndForgetJobs(count: jobCount)
            fireAndForgetStatus = "Completed \(completed)/\(jobCount) jobs"
            isRunningFireAndForget = false
        }
    }

    func runThrowing() {
        isRunningThrowing = true
        throwingStatus = "Running \(throwingJobCount) jobs, job #\(failingJobID) will fail…"
        Task {
            do {
                let completed = try await dataProvider.runJobsUntilFirstFailure(
                    count: throwingJobCount,
                    failingJobID: failingJobID
                )
                throwingStatus = "Completed \(completed)/\(throwingJobCount) jobs (unexpected — no failure)"
            } catch {
                throwingStatus = "Stopped early after failure: \(error)"
            }
            isRunningThrowing = false
        }
    }
}

@available(iOS 17.0, *)
struct DiscardingTaskGroupExample: View {
    @StateObject private var viewModel = DiscardingTaskGroupExampleViewModel()

    var body: some View {
        Form {
            Section("withDiscardingTaskGroup — fire-and-forget") {
                Text(viewModel.fireAndForgetStatus)
                Button("Run jobs") { viewModel.runFireAndForget() }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.isRunningFireAndForget)
            }

            Section("withThrowingDiscardingTaskGroup — cancels siblings on first error") {
                Text(viewModel.throwingStatus)
                Button("Run jobs") { viewModel.runThrowing() }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.isRunningThrowing)
            }
        }
        .navigationTitle("Discarding Task Group")
    }
}

@available(iOS 17.0, *)
#Preview {
    DiscardingTaskGroupExample()
}
