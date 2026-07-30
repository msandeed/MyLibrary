//
//  ExecutorIsolationExample.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/07/2026.
//

import SwiftUI

// Three functions whose bodies are identical — only the annotation differs. Every call site
// below is on @MainActor, so `isMainThreadNow()` on return is entirely a function of the
// callee's own annotation, not of who's calling it. That's the point of SE-0461: the hop (or
// lack of one) is a property of the function being called.
enum ExecutorIsolationProbe {
    // Thread.isMainThread is `NS_SWIFT_UNAVAILABLE_FROM_ASYNC` — the SDK won't let async code
    // read it directly, since async code isn't supposed to reason about which OS thread it's on.
    // Routing through a plain synchronous function sidesteps that restriction without changing
    // where the check actually runs: it still executes wherever the calling async function does.
    private static func isMainThreadNow() -> Bool {
        Thread.isMainThread
    }

    // Plain `nonisolated async`, no annotation. Written out explicitly like this it always means
    // "hop to the generic concurrent executor before running", regardless of the caller's
    // isolation — this has been async functions' behavior since Swift Concurrency shipped.
    static func implicitHop() async -> Bool {
        isMainThreadNow()
    }

    // nonisolated(nonsending) (SE-0461, Swift 6.2): explicitly stays on whatever executor the
    // caller was already running on instead of hopping off. Called from @MainActor code below,
    // this runs on the main thread — no hop, and no `await` needed inside its body to touch
    // main-actor state, since it never left the main actor to begin with.
    nonisolated(nonsending) static func staysWithCaller() async -> Bool {
        isMainThreadNow()
    }

    // @concurrent (SE-0461, Swift 6.2): explicitly forces the hop to the generic concurrent
    // executor. Under the traditional default this reads as redundant — plain `nonisolated async`
    // already does this. It earns its keep once a module's default isolation for `nonisolated
    // async` flips to "stay with caller" (which is what Swift 6.2 language mode does): at that
    // point `@concurrent` becomes the only way to opt a specific function back into "always run
    // off-actor", e.g. for real CPU-bound work that must not tie up the caller's actor.
    @concurrent static func forcedOffActor() async -> Bool {
        isMainThreadNow()
    }
}

@MainActor
class ExecutorIsolationExampleViewModel: ObservableObject {
    struct Row: Identifiable {
        let id = UUID()
        let label: String
        let ranOnMainThread: Bool
    }

    @Published private(set) var rows: [Row] = []
    @Published private(set) var isRunning = false

    func run() {
        isRunning = true
        rows = []
        Task {
            let implicit = await ExecutorIsolationProbe.implicitHop()
            let nonsending = await ExecutorIsolationProbe.staysWithCaller()
            let concurrent = await ExecutorIsolationProbe.forcedOffActor()

            rows = [
                Row(label: "implicit nonisolated async", ranOnMainThread: implicit),
                Row(label: "nonisolated(nonsending)", ranOnMainThread: nonsending),
                Row(label: "@concurrent", ranOnMainThread: concurrent)
            ]
            isRunning = false
        }
    }
}

struct ExecutorIsolationExample: View {
    @StateObject private var viewModel = ExecutorIsolationExampleViewModel()

    var body: some View {
        Form {
            Section("Ran on the main thread?") {
                ForEach(viewModel.rows) { row in
                    HStack {
                        Text(row.label)
                        Spacer()
                        Image(systemName: row.ranOnMainThread ? "checkmark.circle.fill" : "xmark.circle")
                            .foregroundStyle(row.ranOnMainThread ? .green : .red)
                    }
                }
                Button("Run") { viewModel.run() }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.isRunning)
            }
        }
        .navigationTitle("SE-0461 Executors")
    }
}

#Preview {
    ExecutorIsolationExample()
}
