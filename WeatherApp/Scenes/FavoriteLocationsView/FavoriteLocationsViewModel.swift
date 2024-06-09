//
//  FavoriteLocationsViewModel.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 09/06/24.
//

import Foundation

class FavoriteLocationsViewModel: ObservableObject {
    let weatherService: WeatherService
    
    init(weatherService: WeatherService, customLocation: FavoriteLocation? = nil) {
        self.weatherService = weatherService
    }
    
    func getWeatherViewModel(for customLocation: FavoriteLocation) -> WeatherViewModel {
        return .init(weatherService: weatherService, customLocation: customLocation)
    }
    
    func getCurrentLocationData() async throws -> LocationCoordinate {
        return try await weatherService.getCurrentLocation()
    }
}
