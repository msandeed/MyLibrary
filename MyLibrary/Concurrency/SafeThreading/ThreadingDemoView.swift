//
//  ThreadingDemoView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 01/05/2024.
//

import Foundation
import SwiftUI

struct ThreadingDemoView: View {
    @StateObject var viewModel: ThreadingDemoViewModel = .init()
    
    var body: some View {
        Text(viewModel.propertyValue)
            .onAppear {
                viewModel.readAndWrite()               // DispatchQueue + barrier approach
//                Task {
//                    await viewModel.readAndWriteUsingActor()   // actor approach — swap in to compare
//                }
            }
    }
}

@MainActor
class ThreadingDemoViewModel: ObservableObject {
    let safeWrapper = ThreadSafeWrapper(value: "Initial")  // Old approach
    let safeActor = ThreadSafeActor(value: "Initial")   // New approach
    @Published var propertyValue: String = ""

    // Fires 5 concurrent writes and 5 concurrent reads from two different background queues.
    // Safety here comes entirely from ThreadSafeWrapper's internal barrier queue, not from anything
    // these two queues do themselves.
    func readAndWrite() {
        let writeQueue = DispatchQueue(label: "writeQueue")
        let readQueue = DispatchQueue(label: "readQueue")

        writeQueue.async {
            for index in 0 ..< 5 {
                self.safeWrapper.write(newValue: String(index))
            }
        }
        
        readQueue.async {
            for _ in 0 ..< 5 {
                let value = self.safeWrapper.read()
                // @Published must only be mutated on the main thread; hop back explicitly since
                // this closure is running on readQueue, not the MainActor-isolated view model.
                DispatchQueue.main.async {
                    self.propertyValue = value
                }
            }
        }
    }

    // Actor-based equivalent of readAndWrite(): async let starts both loops concurrently, and
    // awaiting the tuple below waits for them to finish.
    // No manual thread hop is needed for safeActor (internally it serializes access) NOR for propertyValue (would already be on @MainActor when setting it).
    func readAndWriteUsingActor() async {
        async let writeDone = asyncWrite()
        async let readDone = asyncRead()

        let (_, _) = await (writeDone, readDone)
    }

    func asyncWrite() async -> Bool {
        for index in 0 ..< 5 {
            await safeActor.write(newValue: String(index))
        }
        
        return true
    }
    
    func asyncRead() async -> Bool {
        for _ in 0 ..< 5 {
            let newValue = await safeActor.read()
            propertyValue = newValue
        }

        return true
    }
}
