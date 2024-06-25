//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 06/06/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct WeatherAppApp: App {
    // MARK: - AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

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
                }
                .tint(.yellow)
            } else {
                SignUpView(viewModel: .init()) {
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
