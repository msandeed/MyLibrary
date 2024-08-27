//
//  AnalyticsProtocol.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 27/08/2024.
//

import Foundation

public protocol AnalyticsProtocol {
    func identifyUser(id: String?)
    func setCustomUserProperties(_ properties: AnalyticsKit.Properties) throws
    func appendCustomUserProperties(_ properties: AnalyticsKit.Properties) throws
    
    func flush()
    func reset()
}

// Implemnented by AnalyticsKit class as a facade over all Providers
public protocol AnalyticsKitProtocol: AnalyticsProtocol {
    func configure(providers: [AnalyticsProvider])
    func logEvent(_ event: AnalyticEvent) throws
}

// Implemented individually by each Provider
public protocol AnalyticsProvider: AnalyticsProtocol {
    func logEvent(_ event: AnalyticEvent) throws
}
