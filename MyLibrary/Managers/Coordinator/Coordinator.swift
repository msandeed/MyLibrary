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
}

protocol Navigator: Coordinator {
    func build(page: Page) -> AnyView
    func build(flow: Flow) -> AnyView
    func build(sheet: Sheet) -> AnyView
    func build(fullScreenCover: FullScreenCover) -> AnyView
}

// MARK: - Managing flow elements
extension Navigator {
    func push(_ page: Page) {
        print("🧭 Appending page: \(page) to stack")
        path.append(page)
        objectWillChange.send()
    }
    
    func present(_ sheet: Sheet) {
        print("🧭 Presenting Sheet \(sheet)")
        self.sheet = sheet
        objectWillChange.send()
    }
    
    func present(_ fullscreenCover: FullScreenCover) {
        print("🧭 Presenting FullScreenCover \(fullscreenCover)")
        self.fullScreenCover = fullscreenCover
        objectWillChange.send()
    }
    
    func present(_ flow: Flow) {
        print("🧭 Presenting flow: \(flow)")
        self.flow = flow
        objectWillChange.send()
    }
    
    func pop() {
        print("🧭 Popping")
        path.removeLast()
        objectWillChange.send()
    }
    
    func popToRoot() {
        print("🧭 Popping To Root")
        path.removeLast(path.count)
        objectWillChange.send()
    }
    
    func dismissSheet() {
        print("🧭 Dismissing Sheet")
        sheet = nil
        objectWillChange.send()
    }
    
    func dismissFlow() {
        print("🧭 Dismissing Flow")
        flow = nil
        objectWillChange.send()
    }
    
    func dismissFullScreenCover() {
        print("🧭 Dismissing FullScreenCover")
        fullScreenCover = nil
        objectWillChange.send()
    }
}

// MARK: - Shared chrome for nested flows
extension Navigator {
    /// Wraps a nested flow's root view with a floating dismiss affordance.
    /// Every concrete coordinator's `build(flow:)` that presents another flow can reuse this
    /// instead of re-implementing the overlay; it's presentation chrome, not routing logic.
    func wrapFlow(_ content: AnyView) -> AnyView {
        ZStack(alignment: .bottom) {
            content
            HStack {
                Spacer()
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.ultraThickMaterial)
                    .onTapGesture {
                        self.dismissFlow()
                    }
            }
            .padding()
        }
        .asAnyView
    }
}

extension View {
    /// Wraps any given view in a type-erased container `AnyView`.
    var asAnyView: AnyView {
        .init(self)
    }
}
