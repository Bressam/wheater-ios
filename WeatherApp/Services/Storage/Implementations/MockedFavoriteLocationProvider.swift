//
//  MockedFavoriteLocationProvider.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 25/06/24.
//

import Foundation

class MockedFavoriteLocationProvider: FavoriteLocationsProvider {
    func getFavoriteLocations() async -> [FavoriteLocation] {
        return [
            .init(cityName: "Test City",
                  creationDate: .init(),
                  latitude: -24.60,
                  longitude: -49.20)
        ]
    }
}
