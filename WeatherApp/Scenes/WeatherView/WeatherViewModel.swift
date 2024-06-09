//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import Foundation

class WeatherViewModel: ObservableObject {
    let weatherService: WeatherService
    var weatherData: LocationWeather?
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func fetchWeather() async throws {
        weatherData = try await weatherService.getWeather(latitude: -25.441105, longitude: -49.276855)
    }
}
