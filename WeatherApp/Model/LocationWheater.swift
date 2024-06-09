//
//  LocationWeather.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import Foundation


struct LocationWeather: Codable {
    typealias LocationDegrees = Double

    let latitude: LocationDegrees?
    let longitude: LocationDegrees?
    var cityName: String? = nil
    let current: CurrentWeather
    let hourlyData: HourlyWeatherData
    
    enum CodingKeys: String, CodingKey {
        case hourlyData = "hourly"
        case latitude, longitude, cityName, current
    }
}

struct CurrentWeather: Codable {
    let time: String
    let interval: Int
    let temperature: Float
    let windSpeed: Float
    
    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature = "temperature_2m"
        case windSpeed = "wind_speed_10m"
    }
}

struct HourlyWeatherData: Codable {
    let time: [String]
    let temperature2m: [Float]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
    }
}
