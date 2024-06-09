//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import Foundation
import CoreLocation

class WeatherService: WeatherProvider {
    // MARK: - Properties
    let dataProvider: any WeatherProvider
    
    // MARK: - Setup
    init(dataProvider: any WeatherProvider) {
        self.dataProvider = dataProvider
    }

    // MARK: - Data provider Methods
    func getWeather(latitude: LocationWeather.LocationDegrees, longitude: LocationWeather.LocationDegrees) async throws -> LocationWeather {
        await getCityName(latitude: latitude, longitude: longitude)
        return try await dataProvider.getWeather(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - Data handling
    
    // Formatter
//    let dateFormatter = DateFormatter()
//    dateFormatter.timeZone = .gmt
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//    for (i, date) in data.hourly.time.enumerated() {
//        print(dateFormatter.string(from: date))
//        print(data.hourly.temperature2m[i])
//    }


    // City name
    func getCityName(latitude: LocationWeather.LocationDegrees,
                     longitude: LocationWeather.LocationDegrees) async -> String {
        let geocoder = CLGeocoder()
        guard let possibleLocations = try? await geocoder.reverseGeocodeLocation(.init(latitude: latitude, longitude: longitude),
                                                                                 preferredLocale: .current)
        else {
            return "Unknown city"
        }
        let cityName = possibleLocations[0].locality ?? "Unknown city"
        print(cityName)
        return cityName
    }
    
}
