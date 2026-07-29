//
//  AsyncStreamExample.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 04/02/2024.
//

import SwiftUI
class AsyncStreamDataProvider {
    // Bridges a legacy, multi-callback API (getNumber's newValue/onFinish) into a single
    // AsyncThrowingStream that callers can consume with `for try await`.
    func getAsyncStream() -> AsyncThrowingStream<Int, Error> {
        AsyncThrowingStream { [weak self] continuation in
            self?.getNumber(newValue: { value in
                print("Async Stream value: \(value)")
                continuation.yield(value)      // Each callback invocation becomes one emitted element.
            }, onFinish: { error in
                print("Async Stream: \(error?.localizedDescription ?? "FINISHED WITH NO ERROR")")
                continuation.finish(throwing: error)   // nil error finishes normally; non-nil throws to the consumer.
            })
        }
    }

    // Stand-in for an old-style completion-handler API: fires `newValue` repeatedly on a delay,
    // then calls `onFinish` once after the last item.
    func getNumber(newValue: @escaping @Sendable (Int) -> Void,
                   onFinish: @escaping @Sendable (Error?) -> Void) {
        let items = [1,2,3,4,5,6,7,8,9,10]

        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item), execute: {
                print("Legacy completion pushes new value: \(item)")
                newValue(item)

                if item == items.last {
                    print("Legacy completion will finish")
                    onFinish(nil)
                }
            })
        }
    }
}

@MainActor
class AsyncStreamViewModel: ObservableObject {
    @Published private(set) var currentNumber: Int = 0
    private var dataProvider = AsyncStreamDataProvider()
    
    func onViewAppeared() {
        Task {
            do {
                for try await value in dataProvider.getAsyncStream() {
                    currentNumber = value
                    print("VM received value: \(value)")
                }
            } catch {
                print("\(error)")
            }
        }
    }
}

struct AsyncStreamExample: View {
    @StateObject private var viewModel = AsyncStreamViewModel()
    var body: some View {
        Text("\(viewModel.currentNumber)")
            .onAppear {
                viewModel.onViewAppeared()
            }
    }
}

#Preview {
    AsyncStreamExample()
}
