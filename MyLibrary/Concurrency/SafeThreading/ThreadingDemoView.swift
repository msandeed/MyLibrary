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
                viewModel.readAndWrite()
//                Task {
//                    await viewModel.readAndWriteUsingActor()
//                }
            }
    }
}

class ThreadingDemoViewModel: ObservableObject {
    let property = ThreadSafeWrapper(value: "Initial")  // Old approach
    let property2 = ThreadSafeActor(value: "Initial")   // New approach
    @Published var propertyValue: String = ""
    
    func readAndWrite() {
        let writeQueue = DispatchQueue(label: "writeQueue")
        let readQueue = DispatchQueue(label: "readQueue")
        
        writeQueue.async {
            for index in 0 ..< 5 {
                self.property.write(newValue: String(index))
            }
        }
        
        readQueue.async {
            for _ in 0 ..< 5 {
                let value = self.property.read()
                DispatchQueue.main.async {
                    self.propertyValue = value
                }
            }
        }
    }
    
    func readAndWriteUsingActor() async {
        async let writeDone = asyncWrite()
        async let readDone = asyncRead()
        
        let (_, _) = await (writeDone, readDone)
    }
    
    func asyncWrite() async -> Bool {
        for index in 0 ..< 5 {
            await property2.write(newValue: String(index))
        }
        
        return true
    }
    
    func asyncRead() async -> Bool {
        for _ in 0 ..< 5 {
            let newValue = await property2.read()
            await MainActor.run {
                propertyValue = newValue
            }
        }
        
        return true
    }
}
