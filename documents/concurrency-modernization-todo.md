# Concurrency Folder — Modernization To-Do

Topics scoped out while auditing `MyLibrary/Concurrency` against Swift 6.2–6.4 / WWDC26. Each item should
get its own example file in `MyLibrary/Concurrency`, following the folder's existing style (DataProvider +
`@MainActor` ViewModel + demo View + `#Preview`) where applicable.

## New topics

- [ ] **Task cancellation** — cooperative cancellation model: `Task.isCancelled`, `Task.checkCancellation()`,
      `withTaskCancellationHandler(operation:onCancel:)`. Demonstrate wrapping a non-cooperative API (e.g. a
      `URLSessionTask`) so cancelling the Swift `Task` actually cancels the underlying work.
- [ ] **`sending` parameters/results** (SE-0430, region-based isolation) — explicit `sending` parameter that
      transfers ownership of a non-`Sendable` value across an isolation boundary, vs. requiring `Sendable`.
- [ ] **Typed throws** (SE-0413) — `func fetch() async throws(NetworkError) -> Data`. Rewrite one of the
      existing untyped-`throws` examples to compare.
- [ ] **Discarding task groups** — `withDiscardingTaskGroup` / `withThrowingDiscardingTaskGroup` for
      fire-and-forget children, contrasted with the result-collecting `withThrowingTaskGroup` already in
      `TaskGroupExample.swift`.
- [ ] **Typed `AsyncSequence` + custom conformance** (SE-0421) — `some AsyncSequence<Element, Failure>` in a
      function signature, and a hand-written `AsyncSequence`/`AsyncIteratorProtocol` conformance (everything
      today leans on pre-built `AsyncThrowingStream`/Combine `.values`).
- [ ] **Task executors** (SE-0417, `TaskExecutor`) — pinning an actor/`Task` to a custom executor instead of
      the default global concurrent pool. Advanced/niche — lower priority.
- [ ] **Isolated global/static state** (SE-0412) — `@MainActor static var shared: Foo` closing the classic
      global-mutable-singleton hole. Ties into the `Factory.swift`/`AnalyticsKit.swift` warnings found outside
      this folder.
- [ ] **New single-resume `Continuation<Success, Failure>`** (Swift 6.3) — successor to
      `withCheckedThrowingContinuation` (used in `WithContinuationExample.swift`); double-resume becomes a
      compile-time error instead of a runtime trap. Add as an explicit comparison alongside the existing file.
- [ ] **Swift 6.4 diagnostics** — warning when a `Task {}` silently drops a thrown error nobody checks; the
      lifted restriction on calling `async` functions from `defer` blocks (async cleanup).
- [ ] **`Mutex<T>` / `Synchronization` framework** (iOS 18+) — modern lock/atomics alternative to a
      `DispatchQueue`-barrier lock. Add `ThreadSafeMutex.swift` next to `ThreadSafeWrapper.swift` /
      `ThreadSafeActor.swift` as a third comparison point in `SafeThreading/`.
- [ ] **`weak let` / `~Sendable`** (Swift 6.4) — `weak let` lets a class with a weak reference qualify for real
      `Sendable` checking instead of `@unchecked`; `~Sendable` explicitly opts a type out of ever being
      `Sendable`. Improves on the `MutableUser`/`@unchecked Sendable` pattern in `ActorsAndSendable.swift`.

## Already discussed — needs a code example

- [ ] **`nonisolated(nonsending)` / `@concurrent`** (SE-0461) — discussed at length during the
      `AsyncPublisherExample.swift` warning fix; no standalone example yet.
- [ ] **Default actor isolation build setting** (`SWIFT_DEFAULT_ACTOR_ISOLATION`, SE-0466) — discussed as a
      project-level concept; no code artifact (this one may just need a note/comment rather than a file, since
      it's a build setting, not a code pattern).
- [ ] **Actor reentrancy** — flagged as a caveat when discussing actors; no example actually demonstrating
      interleaved re-entry causing a subtle bug.

## Context

- Project is on `SWIFT_VERSION = 5.0` with `SWIFT_STRICT_CONCURRENCY = complete`. Swift 6 language mode
  migration for the rest of the project (`Factory.swift`, `Coordinator.swift`, `AnalyticsKit.swift`,
  `MSDynamicForm`, `UIConstants.swift`, `ScrollViewWithOffsetTracking.swift`) is paused — see git history for
  the Concurrency-folder fixes (commit `715bd20`) for the pattern to follow when resuming.
