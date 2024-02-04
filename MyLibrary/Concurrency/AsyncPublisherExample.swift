//
//  AsyncPublisherExample.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 05/02/2024.
//

import SwiftUI
import Combine

class AsyncPublisherDataProvider {
    @Published var data: [Int] = []
    
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
            for await values in dataProvider.$data.values {
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
