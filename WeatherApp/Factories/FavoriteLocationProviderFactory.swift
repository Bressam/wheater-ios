//
//  FavoriteLocationProviderFactory.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 25/06/24.
//

import Foundation
import CoreData

enum FavoriteLocationProviderType {
    case mocked, local(objectContext: NSManagedObjectContext), remote
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
        case .local(let objectContext):
            dataProvider = CoreDataFavoriteLocationsProvider(objectContext: objectContext)
        case .remote:
            dataProvider = FirebaseFavoriteLocationsProvider()
        }

        return dataProvider
    }
}
