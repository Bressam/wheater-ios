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
    let locationManager: LocationManager

    // MARK: - Setup
    init(dataProvider: any WeatherProvider, locationManager: LocationManager) {
        self.dataProvider = dataProvider
        self.locationManager = locationManager
    }

    // MARK: - Data provider Methods
    func getCurrentWeather() async throws -> LocationWeather {
        guard let currentCoordinate = try await locationManager.getCurrentLocation()
        else {
            throw WheaterError.somethingWentWrong
        }
        return try await getWeather(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
    }

    func getWeather(latitude: LocationWeather.LocationDegrees, longitude: LocationWeather.LocationDegrees) async throws -> LocationWeather {
        let cityName = await getCityName(latitude: latitude, longitude: longitude)
        var locationWeather = try await dataProvider.getWeather(latitude: latitude, longitude: longitude)
        locationWeather.cityName = cityName
        return locationWeather
    }

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
        return cityName
    }
}
