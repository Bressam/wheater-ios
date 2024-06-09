//
//  WeatherProviderMock.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import Foundation

class WeatherProviderMock: WeatherProvider {
    func getWeather(latitude: LocationWeather.LocationDegrees, longitude: LocationWeather.LocationDegrees) -> LocationWeather {
        return .init(latitude: -25.441105,
                     longitude: -49.276855,
                     cityName: "Test",
                     current: .init(time: "2024-06-09T04:30",
                                    interval: 900,
                                    temperature: 11.3,
                                    windSpeed: 20),
                     currentUnits: .init(timeUnit: "iso8601",
                                         intervalUnit: "seconds",
                                         temperatureUnit: "°C",
                                         windSpeedUnit: "km/h"),
                     hourlyData: .init(time: [
                        "2024-06-09T04:30",
                        "2024-06-09T05:30"
                     ], temperature2m: [
                        10,
                        11
                     ], humidity: [
                        26,
                        28
                     ]))
    }
}
