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
    @State var isSignedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isSignedIn {
                TabView {
                    WeatherView(viewModel: .init(weatherService: weatherService))
                        .tabItem { Label("Current weather", systemImage: "sun.haze.fill") }
                    FavoriteLocationsView(viewModel: .init(weatherService: weatherService))
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .tabItem { Label("Favorite locations", systemImage: "list.bullet.below.rectangle") }
                    SignUpView()
                        .tabItem { Label("Signup", systemImage: "person.circle") }
                }
                .tint(.yellow)
            } else {
                SignUpView {
                    isSignedIn.toggle()
                }
            }
        }
    }
    
    init() {
        // Services creation
        weatherService = WeatherServiceFactory.shared.createWeatherService(mocked: false)
        
        // Appearance
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }
}
