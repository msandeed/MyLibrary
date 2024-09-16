//
//  ScreenRecorderView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 17/09/2024.
//

import SwiftUI

struct ScreenRecorderView<CoordinatorType: Navigator>: BaseViewProtocol {
    var viewModel: ScreenRecorderViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Button("Start Recording") {
                // Trigger Screen Recording
            }
        }
    }
}
