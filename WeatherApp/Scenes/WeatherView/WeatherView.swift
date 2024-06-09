//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import SwiftUI

struct WeatherView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: WeatherViewModel
    private let backgroundColors: [Color] = [
        .init(red: 0 / 255, green: 212 / 255, blue: 255 / 255),
        .init(red: 9 / 255, green: 9 / 255, blue: 121 / 255),
    ]

    // MARK: - Setup & Lifecycle
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }
    
    private func handleOnAppear() {
        Task{
            do{
                try await viewModel.fetchWeather()
            } catch{
                print(error)
            }
        }
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(gradient: Gradient(colors: backgroundColors),
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
            contentView
        }
        .ignoresSafeArea()
        .onAppear(perform: handleOnAppear)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if let weatherData = viewModel.weatherData {
            VStack {
                Text("Hello \(weatherData.cityName!)!\nWeather: \(viewModel.getWeatherTemperature())\n\(viewModel.getWeatherWindSpeed())")
            }
        } else {
            VStack {
                Text("Loading weather :)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.yellow)
                ProgressView()
                    .controlSize(.extraLarge)
                    .tint(Color.yellow)
            }
        }

    }
}

#Preview {
    let mockedProvider = WeatherServiceFactory.shared.createWeatherService(mocked: true)
    return WeatherView(viewModel: .init(weatherService: mockedProvider))
}
