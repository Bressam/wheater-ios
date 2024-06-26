//
//  FavoriteLocationsProvider.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 25/06/24.
//

import Foundation

protocol FavoriteLocationsProvider {
    func getFavoriteLocations() async -> [FavoriteLocation]
    func addItem(_ favoriteLocationData: LocationCoordinate) async
    func removeItem(_ favoriteLocation: FavoriteLocation) async
}
