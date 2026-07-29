//
//  AsyncPublisherExample.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 05/02/2024.
//

import SwiftUI
// @preconcurrency: Combine predates Swift Concurrency and isn't Sendable-audited (e.g. Published<Value>.Publisher).
// Its subject/storage already does its own internal locking, and the only payload crossing the actor
// boundary below is [Int] (Sendable), so trusting it here is safe — but it silences Sendable checking
// for ALL Combine APIs used in this file, not just $data.
@preconcurrency import Combine

actor AsyncPublisherDataProvider {
    // @Published works inside an actor just like a class; the actor isolates writes to `data`,
    // and $data.values below bridges the Combine publisher into an AsyncSequence.
    @Published var data: [Int] = []

    // Simulates a slow data source, appending one value every 2 seconds.
    func startPublishing() async {
        data.append(0)
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append(1)
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append(2)
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append(3)
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append(4)
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append(5)
    }
}

@MainActor
class AsyncPublisherViewModel: ObservableObject {
    @Published private(set) var dataArray: [Int] = []
    private var dataProvider = AsyncPublisherDataProvider()
    private let cancellables = Set<AnyCancellable>()
    
    init() {
        self.subscribeToInputs()
    }
    
    func subscribeToInputs() {
        Task {
            // await is needed to reach $data since the provider is an actor; the for-await loop
            // then suspends here until the actor publishes a new value, without blocking the thread.
            for await values in await dataProvider.$data.values {
                dataArray = values
            }
        }
    }
    
    func start() async {
        await dataProvider.startPublishing()
    }
}

struct AsyncPublisherExample: View {
    @StateObject private var viewModel = AsyncPublisherViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text("\($0)").bold()
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

#Preview {
    AsyncPublisherExample()
}
