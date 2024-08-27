//
//  AnalyticEvent.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 27/08/2024.
//

import Foundation

public protocol AnalyticEvent {
    var providers: [AnalyticsProvider.Type] { get }
    var name: String { get }
    var id: String? { get }
    var properties: AnalyticsKit.Properties? { get }
}

extension AnalyticEvent {
    /// Calling this method logs the event in AnalyticsKit and prints the event details in case of success logging and the error message in case of failure.
    public func track() {
        do {
            try AnalyticsKit.main.logEvent(self)
            NSLog("[Logged event]: \(self.name)\n\(properties ?? [:])")
        } catch let error {
            NSLog("[Logging event error]: \(error)")
        }
    }
}
