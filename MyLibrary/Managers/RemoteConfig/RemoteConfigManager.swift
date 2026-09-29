//
//  RemoteConfigManager.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 28/08/2024.
//

import Foundation
import FirebaseRemoteConfig

class RemoteConfigManager {
    private var remoteConfig: RemoteConfig

    init() {
        self.remoteConfig = RemoteConfig.remoteConfig()

        // Set in-app default values. For many parameters, use a defaults plist for instance.
        let defaultValues: [String: NSObject] = [
            "welcome_message": "Welcome to My Library!" as NSObject
        ]
        self.remoteConfig.setDefaults(defaultValues)
        
        // Set minimum fetch interval for dev mode. For live apps, set to default value (12 hrs)
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        self.remoteConfig.configSettings = settings
    }

    // Call this function to fetch latest configurations and apply them
    // `nonisolated(nonsending)` runs on the caller's actor, so `self` never crosses an isolation boundary.
    nonisolated(nonsending) func fetchConfig() async {
        do {
            let status = try await remoteConfig.fetch()
            guard status == .success else {
                print("📝 Config not fetched")
                return
            }
            print("📝 Config fetched!")
            _ = try await remoteConfig.activate()
        } catch {
            print("📝 Config not fetched")
            print("📝 Error: \(error.localizedDescription)")
        }
    }

    // Used for testing
    func getWelcomeMessage() -> String {
        return remoteConfig["welcome_message"].stringValue
    }
}

