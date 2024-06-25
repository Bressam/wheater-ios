//
//  LocationCoordinateFireStorm.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 25/06/24.
//

import Foundation

struct LocationCoordinateFireStorm: Codable {
    let cityName: String
    let latitude: Double
    let longitude: Double
    var creationDate = Date().timeIntervalSince1970
}

extension LocationCoordinateFireStorm {
    init(from locationCoordinate: LocationCoordinate) {
        self.cityName = locationCoordinate.cityName
        self.latitude = locationCoordinate.latitude
        self.longitude = locationCoordinate.longitude
    }
}
