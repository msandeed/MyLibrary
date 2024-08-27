//
//  SomeAnalyticsProvider.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 27/08/2024.
//

import Foundation

// A concrete Analytics Provider implementation
// This is a dummy example. Could be Amplitude, Firebase or any other provider...
class SomeAnalyticsProvider: AnalyticsProvider {
    func logEvent(_ event: AnalyticEvent) throws {
        print("📊 SomeAnalyticsProvider logging event: \(event.name)")
    }
    
    func identifyUser(id: String?) {}
    
    func setCustomUserProperties(_ properties: AnalyticsKit.Properties) throws {}
    
    func appendCustomUserProperties(_ properties: AnalyticsKit.Properties) throws {}
    
    func flush() {}
    
    func reset() {}
}
