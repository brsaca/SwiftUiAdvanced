//
//  SwiftUiAdvancedApp.swift
//  SwiftUiAdvanced
//
//  Created by Brenda Saavedra  on 01/04/23.
//

import SwiftUI
import Firebase
import RevenueCat

@main
struct SwiftUiAdvancedApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
        Purchases.configure(withAPIKey: "appl_bhcEZMxyphNHHSMlfuGwFEePAxD")
        Purchases.logLevel = .debug
    }

    var body: some Scene {
        WindowGroup {
            SignupView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
