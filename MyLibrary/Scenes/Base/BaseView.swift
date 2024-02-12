//
//  BaseView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 22/12/2022.
//

import SwiftUI

protocol BaseViewProtocol: View {
    associatedtype VM: ViewModelType
    associatedtype C: Navigator
    
    var viewModel: VM { get }
    var coordinator: C { get }
}

