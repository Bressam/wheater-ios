//
//  RemoteWeatherProvider.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import Foundation

class RemoteWeatherProvider: WeatherProvider {    
    func getWeather(latitude: LocationWeather.LocationDegrees, longitude: LocationWeather.LocationDegrees) -> LocationWeather {
        return .init(latitude: -25.441105,
                     longitude: -49.276855,
                     cityName: "Test",
                     current: .init(time: Date(),
                                    interval: 900,
                                    temperature: 11.3,
                                    windSpeed: 20),
                     hourlyData: .init(hourly: .init(time: [
                        .init(),
                        .init().addingTimeInterval(30000)
                     ], temperature2m: [
                        10,
                        11
                     ])))
    }
}
