//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 06/06/24.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
