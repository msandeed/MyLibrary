//
//  Coordinator.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/02/2024.
//

import Foundation
import SwiftUI
import Combine

protocol Coordinator: AnyObject {
    var path: NavigationPath { get set }
    var sheet: Sheet? { get set }
    var fullScreenCover: FullScreenCover? { get set }
    var objectWillChange: ObservableObjectPublisher { get }
    
    func push(_ page: Page)
    func present(_ sheet: Sheet)
    func present(_ fullscreenCover: FullScreenCover)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenCover()
    
    func build(page: Page) -> AnyView
    func build(sheet: Sheet) -> AnyView
    func build(fullScreenCover: FullScreenCover) -> AnyView
}

extension Coordinator {
    func push(_ page: Page) {
        path.append(page)
        objectWillChange.send()
    }
    
    func present(_ sheet: Sheet) {
        self.sheet = sheet
        objectWillChange.send()
    }
    
    func present(_ fullscreenCover: FullScreenCover) {
        self.fullScreenCover = fullscreenCover
        objectWillChange.send()
    }
    
    func pop() {
        path.removeLast()
        objectWillChange.send()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
        objectWillChange.send()
    }
    
    func dismissSheet() {
        sheet = nil
        objectWillChange.send()
    }
    
    func dismissFullScreenCover() {
        fullScreenCover = nil
        objectWillChange.send()
    }
}

extension View {
    /// Wraps any given view in a type-erased container `AnyView`.
    var asAnyView: AnyView {
        .init(self)
    }
}
