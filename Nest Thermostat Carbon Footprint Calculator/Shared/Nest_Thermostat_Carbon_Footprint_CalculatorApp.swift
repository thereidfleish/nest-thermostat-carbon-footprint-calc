//
//  Nest_Thermostat_Carbon_Footprint_CalculatorApp.swift
//  Shared
//
//  Created by Reid Fleishman on 3/25/22.
//

import SwiftUI

@main
struct Nest_Thermostat_Carbon_Footprint_CalculatorApp: App {
    @StateObject private var networkController = NetworkController()
    
    var body: some Scene {
        WindowGroup {
            if (!networkController.userData.loggedIn && !networkController.newUser) {
                LogInView()
                    .environmentObject(networkController)
            }
//            else if (networkController.newUser) {
//                ProfileSettingsView(isNewUser: true)
//                    .environmentObject(networkController)
//            }
            else {
                ContentView()
                    .environmentObject(networkController)
            }
        }
    }
}
