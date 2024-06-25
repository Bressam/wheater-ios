//
//  FavoriteLocationsViewModel.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 09/06/24.
//

import Foundation

class FavoriteLocationsViewModel: ObservableObject {
    let favoriteLocationsProvider: FavoriteLocationsProvider
    let weatherService: WeatherService
    @Published var favoriteLocations: [FavoriteLocation] = []
    
    init(weatherService: WeatherService,
         customLocation: FavoriteLocation? = nil,
         favoriteLocationsProvider: FavoriteLocationsProvider) {
        self.weatherService = weatherService
        self.favoriteLocationsProvider = favoriteLocationsProvider
    }
    
    func getWeatherViewModel(for customLocation: FavoriteLocation) -> WeatherViewModel {
        return .init(weatherService: weatherService, customLocation: customLocation)
    }
    
    func getCurrentLocationData() async throws -> LocationCoordinate {
        return try await weatherService.getCurrentLocation()
    }
    
    // Data Provider Management
    func fetchFavoriteLocations() async {
        let favoriteLocationsList = await favoriteLocationsProvider.getFavoriteLocations()
        await MainActor.run {
            favoriteLocations = favoriteLocationsList
        }
    }
    
    func addItem() async {
        guard let locationCoordinateData = try? await getCurrentLocationData() else {
            print("Failed to get currentLocationData. Cancelling create location task")
            return
        }
        await favoriteLocationsProvider.addItem(locationCoordinateData)
    }
    
    func delete(atIndex: IndexSet) async {
        let item: FavoriteLocation = favoriteLocations[atIndex.first!]
        await favoriteLocationsProvider.removeItem(item)
    }
}
