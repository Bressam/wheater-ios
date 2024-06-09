//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import Foundation

class WeatherViewModel: ObservableObject {
    let weatherService: WeatherService
    let customLocation: FavoriteLocation?
    @Published var weatherData: LocationWeather?
    
    init(weatherService: WeatherService, customLocation: FavoriteLocation? = nil) {
        self.weatherService = weatherService
        self.customLocation = customLocation
    }
    
    func fetchWeather() async throws {
        let fetchedWeather: LocationWeather
        if let customLocation {
            fetchedWeather = try await weatherService.getWeather(latitude: customLocation.latitude, longitude: customLocation.longitude)
        } else {
            fetchedWeather = try await weatherService.getCurrentWeather()
        }
        await MainActor.run {
            weatherData = fetchedWeather
        }
    }

}

// MARK: - Data Formatting
extension WeatherViewModel {
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }
    
    func getCityName() -> String {
        guard let cityName = weatherData?.cityName else { return "" }
        return cityName.capitalized
    }

    func getWeatherTemperature() -> String {
        guard let weatherData else { return "" }
        let formattedTemperature = numberFormatter.string(from: weatherData.current.temperature as NSNumber)!
        return "\(formattedTemperature)\(weatherData.currentUnits.temperatureUnit)"
    }
    
    func getWeatherWindSpeed() -> String {
        guard let weatherData else { return "" }
        let formattedTemperature = numberFormatter.string(from: weatherData.current.windSpeed as NSNumber)!
        return "\(formattedTemperature)\(weatherData.currentUnits.windSpeedUnit)"
    }
    
    func getCurrentDate() -> String {
        guard let weatherData else { return "" }
        return weatherData.current.time
        //        let dateFormatter = DateFormatter()
        //            dateFormatter.timeZone = .gmt
        //            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        //        return dateFormatter.string(from: weatherData.current.time)
        //            for (i, date) in data.hourly.time.enumerated() {
        //                print(dateFormatter.string(from: date))
        //                print(data.hourly.temperature2m[i])
        //            }
    }
    
    func getMinTemperature() -> String {
        guard let weatherData = weatherData,
              let minTemp = weatherData.hourlyData.temperature2m.min() else { return "" }
        
        return "min: \(minTemp)\(weatherData.currentUnits.temperatureUnit)"
    }
    
    func getMaxTemperature() -> String {
        guard let weatherData = weatherData,
              let maxTemp = weatherData.hourlyData.temperature2m.max() else { return "" }
        
        return "max: \(maxTemp)\(weatherData.currentUnits.temperatureUnit)"
    }
    
    struct HourlyData {
        let date: String
        let temp: String
    }
    
    func getHourlyDetails() -> [HourlyData] {
        guard let weatherData else { return [] }
        
        var hourlyData: [HourlyData] = []
        for (temp, time) in zip(weatherData.hourlyData.temperature2m, weatherData.hourlyData.time) {
            let hourString = String(time.suffix(from: time.firstIndex(of: "T")!).dropFirst())
            let tempString = numberFormatter.string(from: temp as NSNumber)! + weatherData.currentUnits.temperatureUnit
            hourlyData.append(.init(date: hourString, temp: tempString))
        }
        return hourlyData
    }
    
    func getWindSpeed() -> String {
        guard let weatherData else { return "" }

        return "\(weatherData.current.windSpeed) \(weatherData.currentUnits.windSpeedUnit)"
    }
    
    func getMaxHumidity() -> String {
        guard let weatherData,
              let maxHumidity = weatherData.hourlyData.humidity.max()
        else { return "" }
        
        return "\(maxHumidity)%"
    }
}
