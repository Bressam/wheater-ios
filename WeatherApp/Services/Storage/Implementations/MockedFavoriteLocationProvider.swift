//
//  MockedFavoriteLocationProvider.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 25/06/24.
//

import Foundation

class MockedFavoriteLocationProvider: FavoriteLocationsProvider {
    private var localList: [FavoriteLocation] = []

    func addItem(_ favoriteLocationData: LocationCoordinate) {
        localList.append(.init(cityName: "Test City",
                               creationDate: .init(),
                               latitude: -24.60,
                               longitude: -49.20))
    }
    
    func removeItem(_ favoriteLocation: FavoriteLocation) {
        localList.removeAll(where: { $0.id == favoriteLocation.id })
    }
    
    func getFavoriteLocations() async -> [FavoriteLocation] {
        return localList
    }
}
