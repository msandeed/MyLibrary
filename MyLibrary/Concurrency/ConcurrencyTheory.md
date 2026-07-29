# Concurrency — Quick Facts

Running notes on Swift concurrency, added to as new things come up in discussion. Not a tutorial —
just facts worth not forgetting.

## Execution & isolation

- Non-isolated async functions run on the global concurrent executor by default, unless annotated
  (`@MainActor`) or isolated to an actor.
- `await` suspends the current task; it does not block the thread. The thread is freed to do other
  work while the task is suspended.
- SwiftUI views are `@MainActor` because the `View` protocol itself is annotated `@MainActor`
  (originally just the `body` requirement; the whole protocol as of Xcode 16 / Swift 6 SDK) — **not**
  because of any `@ObservedObject`/`@StateObject`/`@Observable` property. A view with zero observable
  state is still `@MainActor`-isolated.

## What is the "generic concurrent executor"?

Every actor has a serial executor — the thing that actually runs the actor's queued work, one piece
at a time, on some thread. That's what gives an actor its mutual-exclusion guarantee: as long as
everything routes through its serial executor, only one job touches its state at once. `MainActor`'s
serial executor happens to be the main thread's run loop specifically.

Code that isn't tied to any actor — a plain `nonisolated` async function, `Task.detached { }`, or
generally anything not isolated to a specific actor — has no serial executor of its own to run on.
Instead it runs on the default global concurrent executor: a shared, cooperative thread pool owned by
the Swift Concurrency runtime (conceptually similar to `DispatchQueue.global()`, but built on Swift's
own cooperative scheduler that maps many tasks onto a small, fixed number of OS threads to avoid
thread explosion). Unlike an actor's serial executor, it's allowed to run multiple unrelated tasks
truly in parallel across those threads — there's no mutual exclusion, because nothing there is
protecting shared state the way an actor does.

## Structured vs. unstructured

- Structured concurrency is achieved through `async let` or task groups (`withTaskGroup` /
  `withThrowingTaskGroup`) — child tasks are scoped to the enclosing scope and awaited/cancelled
  together.
- `Task.detached` is not "the way to run work off the main actor" — that's already the default for a
  plain `Task { }` too. What it actually does: creates a task with no parent, so it:
  - Doesn't inherit the calling task's priority
  - Doesn't inherit the calling task's actor isolation
  - Doesn't inherit the calling task's task-local values
  - Isn't cancelled when the parent is cancelled
  - Useful for background work that must be independent of/outlive the calling context.

## `nonisolated(unsafe)` vs `nonisolated(nonsending)`

Different targets, different purposes — easy to conflate because they share the `nonisolated`
keyword, but they're not variations on the same idea:

- `nonisolated(unsafe)` (SE-0412, Swift 5.10/6.0) attaches to a stored property (`var`/`let`). It
  tells the compiler "stop checking this — I'm manually guaranteeing safety some other way (a lock,
  atomics, single-writer discipline, whatever)." It's a pure escape hatch: no runtime check, no
  enforcement. If you're wrong, you get an actual data race — undefined behavior — at runtime. It's
  the property-level sibling of `@unchecked Sendable`.
- `nonisolated(nonsending)` (SE-0461, Swift 6.2) attaches to an async function/method. It doesn't
  disable any checking — it changes which executor the function runs on when called: instead of
  hopping to the generic concurrent executor, it runs wherever the caller is isolated. Fully checked,
  fully safe, zero "trust me" involved.

So: `unsafe` = "stop verifying this, I promise." `nonsending` = "run this on the caller's actor
instead of hopping off" — a scheduling choice, not a safety bypass.

## `sending` parameters/results — not a substitute for `Sendable`

- `sending` (SE-0430, Swift 6.0) attaches to a parameter or return type, not to a whole type. It
  transfers exclusive ownership of one specific value across an isolation boundary for a single
  call, instead of requiring the value's *type* to be `Sendable`. Region-based isolation checking
  proves the caller can no longer touch the value after handing it off — reusing it afterward is a
  compile-time error ("used after being passed as a sending parameter"), not a runtime trap.
- Use case: single-owner hand-off ("hot potato") — a non-`Sendable` value created in one isolation
  domain, passed into another (e.g. an actor), and never touched again by the original owner. See
  `PhotoEditSession` / `PhotoProcessor` in `SendingParameters.swift`: the class stays non-`Sendable`,
  but ownership moves cleanly into the actor and back out.
- **Not** a substitute for `Sendable` when a value needs to be held or accessed by more than one
  isolation domain *at the same time* — a stored property read from multiple places, something
  captured and reused across calls, etc. That's genuine sharing, not a one-time transfer; `sending`
  won't type-check it away. You still need real `Sendable` there (locks, an actor, immutability) —
  same as `MutableUser`'s `@unchecked Sendable` in `ActorsAndSendable.swift`.
- Rule of thumb: `Sendable` = "safe to be touched from multiple places at once." `sending` = "safe to
  hand off once, because only one place touches it at any given time."

## `SWIFT_DEFAULT_ACTOR_ISOLATION` (build setting)

`SWIFT_DEFAULT_ACTOR_ISOLATION` (SE-0466) is a real build setting, and **this changed as of Swift
6.2**: `MainActor` became a valid value for it, meaning any type/function in the module with no
explicit isolation annotation implicitly becomes `@MainActor`-isolated instead of `nonisolated`.

But that value isn't retroactively forced onto existing projects:

- New projects created in Xcode 26 (targeting Swift 6 language mode) get
  `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` set by the project template.
- Existing projects (< Swift 6.2) keep the traditional `nonisolated` default, explicitly, even
  after you upgrade tooling. Nothing silently flips it.

## Memory management

- Capturing `self` strongly in `Task { }` is only safe when the task's lifetime is naturally bounded
  (fire-and-forget, or SwiftUI's `.task { }` modifier, which is tied to the view's lifecycle). It's
  **not** a substitute for `[weak self]` when:
  - the `Task` is stored as a property on `self` — this is a real retain cycle (`self` → task property
    → closure → strong `self`) that only breaks once the task finishes.
  - it loops over a long-lived/never-ending `AsyncStream`/`AsyncSequence` — `self` stays alive for as
    long as iteration continues, potentially forever, unless cancelled externally.
