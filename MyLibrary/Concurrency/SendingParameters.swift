//
//  SendingParametersExample.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 29/07/2026.
//

import SwiftUI

// A plain mutable class, deliberately NOT Sendable. Before SE-0430, handing this to an actor
// meant either making it truly Sendable (locks, or an @unchecked lie) or eating a strict-
// concurrency error, even though only one owner ever touches it at a time.
final class PhotoEditSession {
    private(set) var appliedFilters: [String] = []
    let originalPixelCount: Int

    init(originalPixelCount: Int) {
        self.originalPixelCount = originalPixelCount
    }

    func apply(_ filter: String) {
        appliedFilters.append(filter)
    }
}

actor PhotoProcessor {
    // `sending` on the parameter means the caller transfers exclusive ownership of `session`,
    // not just a Sendable-safe reference. The region-based isolation checker proves the caller
    // can no longer touch `session` after this call, so it's safe to mutate here on the actor
    // even though PhotoEditSession itself isn't Sendable. `sending` on the return type does the
    // same in reverse, handing ownership back to whichever isolation domain awaits the call.
    func apply(_ filters: [String], to session: sending PhotoEditSession) async -> sending PhotoEditSession {
        for filter in filters {
            session.apply(filter)
            try? await Task.sleep(for: .milliseconds(300))
        }
        return session
    }
}

struct SendingParametersExampleDataProvider {
    private let processor = PhotoProcessor()

    func runTransfer() async -> [String] {
        let session = PhotoEditSession(originalPixelCount: 4_000_000)

        // Ownership of `session` transfers into the actor here. Uncommenting the line below
        // would fail to compile ("sending value ... used after being passed as a sending
        // parameter") — the compiler proves nobody on this side can race the actor for it.
        let processed = await processor.apply(["sepia", "sharpen", "vignette"], to: session)
//         session.apply("oops") // ← would not compile: `session` was sent away above.

        return processed.appliedFilters
    }
}

@MainActor
class SendingParametersExampleViewModel: ObservableObject {
    @Published private(set) var status = "Not started"
    @Published private(set) var appliedFilters: [String] = []
    @Published private(set) var isRunning = false

    private let dataProvider = SendingParametersExampleDataProvider()

    func start() {
        isRunning = true
        status = "Transferring session into PhotoProcessor…"
        appliedFilters = []
        Task {
            let filters = await dataProvider.runTransfer()
            appliedFilters = filters
            status = "Done — ownership transferred back out"
            isRunning = false
        }
    }
}

struct SendingParametersExample: View {
    @StateObject private var viewModel = SendingParametersExampleViewModel()

    var body: some View {
        Form {
            Section("sending parameter/result transfer") {
                Text(viewModel.status)
                if !viewModel.appliedFilters.isEmpty {
                    ForEach(viewModel.appliedFilters, id: \.self) { filter in
                        Label(filter, systemImage: "checkmark.circle")
                    }
                }
                Button("Start") { viewModel.start() }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.isRunning)
            }
        }
        .navigationTitle("Sending Parameters")
    }
}

#Preview {
    SendingParametersExample()
}
