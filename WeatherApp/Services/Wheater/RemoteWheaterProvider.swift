//
//  RemoteWeatherProvider.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import Foundation

public enum WheaterError: Error, LocalizedError {
    case somethingWentWrong
}

class RemoteWeatherProvider: WeatherProvider {
    let baseURL: String = "https://api.open-meteo.com/v1"
    
    func getWeather(latitude: LocationWeather.LocationDegrees, longitude: LocationWeather.LocationDegrees) async throws -> LocationWeather {
        let endpoint = "/forecast"
        let locationParams = "?latitude=\(latitude)&longitude=\(longitude)"
        let defaultParams = "&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m"
        let endpointURL = URL(string: baseURL + endpoint + locationParams + defaultParams)
        
        let wheaterData = try await performRequest(from: URLRequest(url: endpointURL!), for: LocationWeather.self)
        return wheaterData
    }
    
    private func performRequest<T: Decodable>(from url: URLRequest, for type: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw WheaterError.somethingWentWrong
        }
        let responseObject = try JSONDecoder().decode(type.self, from: data)
        return responseObject
    }
}
