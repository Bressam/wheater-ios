//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import Foundation

class WeatherViewModel: ObservableObject {
    let weatherService: WeatherService
    let customLocation: FavoriteLocation?
    @Published var weatherData: LocationWeather?
    
    init(weatherService: WeatherService, customLocation: FavoriteLocation? = nil) {
        self.weatherService = weatherService
        self.customLocation = customLocation
    }
    
    func fetchWeather() async throws {
        let fetchedWeather: LocationWeather
        if let customLocation {
            fetchedWeather = try await weatherService.getWeather(latitude: customLocation.latitude, longitude: customLocation.longitude)
        } else {
            fetchedWeather = try await weatherService.getWeather(latitude: -25.441105, longitude: -49.276855)
        }
        await MainActor.run {
            weatherData = fetchedWeather
        }
    }
}
