//
//  BaseView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 22/12/2022.
//

import SwiftUI

final class Navigator: ObservableObject {
    @Published var isActive = false
    var destnationView: AnyView?
}
protocol BaseViewProtocol: View {
    associatedtype ViewModel: ViewModelType
    
    var navigator: Navigator { get }
    var viewModel: ViewModel { get }
}

