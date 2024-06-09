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
            WeatherView(viewModel: .init(weatherService: weatherService))
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    init() {
        // Services creation
        weatherService = WeatherServiceFactory.shared.createWeatherService(mocked: false)
    }
}
