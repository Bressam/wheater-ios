//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import Foundation
import CoreLocation

struct CurrentLocationCoordinate {
    let latidude: LocationWeather.LocationDegrees
    let longitude: LocationWeather.LocationDegrees
}

class WeatherService: WeatherProvider {
    // MARK: - Properties
    let dataProvider: any WeatherProvider
    let locationManager: LocationManager
    
    @Published var currentCoordinate: CurrentLocationCoordinate?

    // MARK: - Setup
    init(dataProvider: any WeatherProvider, locationManager: LocationManager) {
        self.dataProvider = dataProvider
        self.locationManager = locationManager
        self.locationManager.delegate = self
    }

    // MARK: - Data provider Methods
    func getCurrentWeather() async throws -> LocationWeather {
        locationManager.getCurrentLocation()
//        $currentCoordinate.first().
//        var currentLocation: CurrentLocationCoordinate
//        for await location in currentValues {
//            currentLocation = location
//            return try await getWeather(latitude: currentLocation.latidude, longitude: currentLocation.longitude)
//        }
        Task {
            for await value in self.$currentCoordinate.values {
                return try await getWeather(latitude: value!.latidude, longitude: value!.longitude)
            }
        }
    }

    func getWeather(latitude: LocationWeather.LocationDegrees, longitude: LocationWeather.LocationDegrees) async throws -> LocationWeather {
        let cityName = await getCityName(latitude: latitude, longitude: longitude)
        var locationWeather = try await dataProvider.getWeather(latitude: latitude, longitude: longitude)
        locationWeather.cityName = cityName
        return locationWeather
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
        return cityName
    }
}

extension WeatherService: LocationManagerDelegate {
    func didReceiveCurrentLocation(latitude: Double, longitude: Double) {
        self.currentCoordinate = .init(latidude: latitude, longitude: longitude)
    }
}
