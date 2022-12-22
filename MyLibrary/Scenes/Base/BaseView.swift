//
//  BaseView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 22/12/2022.
//

import SwiftUI

protocol BaseView: View {
    associatedtype ViewModel: ViewModelType
    
    var viewModel: ViewModel { get set }
    init(viewModel: ViewModel)
}
