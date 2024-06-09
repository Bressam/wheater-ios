//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 06/06/24.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    // MARK: - Services
    let persistenceController = PersistenceController.shared
    let weatherService: WeatherService

    var body: some Scene {
        WindowGroup {
            TabView {
                WeatherView(viewModel: .init(weatherService: weatherService))
                    .tabItem { Label("Current weather", systemImage: "sun.haze.fill") }
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem { Label("Favorite locations", systemImage: "list.bullet.below.rectangle") }
            }
        }
    }
    
    init() {
        // Services creation
        weatherService = WeatherServiceFactory.shared.createWeatherService(mocked: false)
    }
}
