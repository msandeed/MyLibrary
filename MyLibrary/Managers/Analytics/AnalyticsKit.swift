//
//  AnalyticsKit.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 27/08/2024.
//

import Foundation

public class AnalyticsKit: AnalyticsKitProtocol {
    /// Guards `_main`, which can be swapped by `mock(with:)` while `track()` reads it from any thread.
    private static let mainLock = NSLock()
    nonisolated(unsafe) private static var _main: AnalyticsKitProtocol = AnalyticsKit()

    public static var main: AnalyticsKitProtocol {
        mainLock.withLock { _main }
    }

    private var providers: [AnalyticsProvider] = []
    
    public func configure(providers: [AnalyticsProvider]) {
        self.providers = providers
    }
}

extension AnalyticsKit {
    public static func mock(with mockedKit: AnalyticsKitProtocol) {
        guard NSClassFromString("XCTest") != nil else { return }
        mainLock.withLock { _main = mockedKit }
    }
}

// MARK: - Methods
extension AnalyticsKit {
    public func identifyUser(id: String?) {
        providers.forEach { $0.identifyUser(id: id) }
    }
    
    public func logEvent(_ event: AnalyticEvent) throws {
        try providers(for: event).forEach { try $0.logEvent(event) }
    }

    public func setCustomUserProperties(_ properties: AnalyticsKit.Properties) throws {
        try providers.forEach { try $0.setCustomUserProperties(properties) }
    }
    
    public func appendCustomUserProperties(_ properties: AnalyticsKit.Properties) throws {
        try providers.forEach { try $0.appendCustomUserProperties(properties) }
    }
    
    public func flush() {
        providers.forEach { $0.flush() }
    }
    
    public func reset() {
        providers.forEach { $0.reset() }
    }
}

// MARK: Helpers
private extension AnalyticsKit {
    func providers(for event: AnalyticEvent) -> [AnalyticsProvider] {
        providers
            .filter { provider in
                event.providers.contains { $0 == type(of: provider) }
            }
    }
}

// MARK: - Types
public extension AnalyticsKit {
    typealias Properties = [String: String]
}

extension AnalyticsKit {
    /// Guards `_allProviders`, which is set at app launch and read by events from any thread.
    private static let allProvidersLock = NSLock()
    nonisolated(unsafe) private static var _allProviders: [AnalyticsProvider.Type] = []

    public static var allProviders: [AnalyticsProvider.Type] {
        get { allProvidersLock.withLock { _allProviders } }
        set { allProvidersLock.withLock { _allProviders = newValue } }
    }
}
