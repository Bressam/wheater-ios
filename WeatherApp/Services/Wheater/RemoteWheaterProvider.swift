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


        print(wheaterData)

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
    
    private func performRequest<T: Decodable>(from url: URLRequest, for type: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WheaterError.somethingWentWrong
        }
        let responseObject = try JSONDecoder().decode(type.self, from: data)
        return responseObject
    }
}
