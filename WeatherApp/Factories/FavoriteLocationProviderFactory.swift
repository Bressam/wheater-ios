//
//  FavoriteLocationProviderFactory.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 25/06/24.
//

import Foundation

enum FavoriteLocationProviderType {
    case mocked, local, remote
}

class FavoriteLocationProviderFactory {
    static var shared: FavoriteLocationProviderFactory = {
        return FavoriteLocationProviderFactory()
    }()
    
    private init() {}
    
    @MainActor
    func createProvider(type: FavoriteLocationProviderType) -> FavoriteLocationsProvider {
        let dataProvider: FavoriteLocationsProvider!
        switch type {
        case .mocked:
            dataProvider = MockedFavoriteLocationProvider()
        case .local:
            dataProvider = CoreDataFavoriteLocationsProvider()
        case .remote:
            dataProvider = FirebaseFavoriteLocationsProvider()
        }

        return dataProvider
    }
}
