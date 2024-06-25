//
//  FavoriteLocation.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 25/06/24.
//

import Foundation

struct FavoriteLocation: Identifiable {
    let id = UUID()
    
    let cityName: String
    let creationDate: Date
    let latitude: Double
    let longitude: Double
}

extension FavoriteLocation {
    init(from coreDataEntity: FavoriteLocationCoreData) {
        self.cityName = coreDataEntity.cityName ?? ""
        self.creationDate = coreDataEntity.creationDate ?? .init()
        self.latitude = coreDataEntity.latitude
        self.longitude = coreDataEntity.longitude
    }
}
