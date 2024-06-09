//
//  WeatherServiceFactory.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import Foundation

class WeatherServiceFactory {
    static var shared: WeatherServiceFactory = {
        return WeatherServiceFactory()
    }()
    
    private init() {}
    
    @MainActor
    func createWeatherService(mocked useMockedProvider: Bool) -> WeatherService {
        let dataProvider: WeatherProvider!
        if useMockedProvider {
            dataProvider = WeatherProviderMock()
        } else {
            dataProvider = RemoteWeatherProvider()
        }
        
        return .init(dataProvider: dataProvider)
    }
}
