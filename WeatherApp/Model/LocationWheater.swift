//
//  LocationWeather.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import Foundation


struct LocationWeather: Codable {
    typealias LocationDegrees = Double

    let latitude: LocationDegrees
    let longitude: LocationDegrees
    let cityName: String
    let current: CurrentWeather
    let hourlyData: WeatherData
}

struct CurrentWeather: Codable {
    let time: Date
    let interval: Int
    let temperature: Float
    let windSpeed: Float
    
    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature = "temperature_2m"
        case windSpeed = "wind_speed_10m"
    }
}

struct WeatherData: Codable {
    let hourly: Hourly
    
    struct Hourly: Codable {
        let time: [Date]
        let temperature2m: [Float]
    }
}
