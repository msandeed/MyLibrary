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
    var flow: Flow? { get set }
    var objectWillChange: ObservableObjectPublisher { get }
    
    func push(_ page: Page)
    func present(_ sheet: Sheet)
    func present(_ fullscreenCover: FullScreenCover)
    func present(_ flow: Flow)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenCover()
    func dismissFlow()
    
    func build(page: Page) -> AnyView
    func build(flow: Flow) -> AnyView
    func build(sheet: Sheet) -> AnyView
    func build(fullScreenCover: FullScreenCover) -> AnyView
}

extension Coordinator {
    func push(_ page: Page) {
        print("Appending page: \(page) to stack")
        path.append(page)
        objectWillChange.send()
    }
    
    func present(_ sheet: Sheet) {
        print("Presenting Sheet \(sheet)")
        self.sheet = sheet
        objectWillChange.send()
    }
    
    func present(_ fullscreenCover: FullScreenCover) {
        print("Presenting FullScreenCover \(fullscreenCover)")
        self.fullScreenCover = fullscreenCover
        objectWillChange.send()
    }
    
    func present(_ flow: Flow) {
        print("Presenting flow: \(flow)")
        self.flow = flow
        objectWillChange.send()
    }
    
    func pop() {
        print("Popping")
        path.removeLast()
        objectWillChange.send()
    }
    
    func popToRoot() {
        print("Popping To Root")
        path.removeLast(path.count)
        objectWillChange.send()
    }
    
    func dismissSheet() {
        print("Dismissing Sheet")
        sheet = nil
        objectWillChange.send()
    }
    
    func dismissFlow() {
        print("Dismissing Flow")
        flow = nil
        objectWillChange.send()
    }
    
    func dismissFullScreenCover() {
        print("Dismissing FullScreenCover")
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
