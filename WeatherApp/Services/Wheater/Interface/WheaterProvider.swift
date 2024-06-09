//
//  WeatherProvider.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import Foundation

protocol WeatherProvider: AnyObject {
    func getWeather(latitude: LocationWeather.LocationDegrees,
                    longitude: LocationWeather.LocationDegrees) -> LocationWeather
}
