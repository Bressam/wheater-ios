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
    @State private var weatherCategory: WeatherCategory = .sunny

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
                    LinearGradient(gradient: Gradient(colors: weatherCategory.backgroundGradientColors),
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
        if viewModel.weatherData != nil {
            locationWeatherDetailsView
        } else {
            loadingView
        }
    }
    
    enum WeatherCategory {
        case sunny, rainy
        
        var titleColor: Color {
            switch self {
            case .sunny: return .yellow
            case .rainy: return .white
            }
        }
        
        var backgroundGradientColors: [Color] {
            switch self {
            case .sunny:
                return [
                    .init(red: 0 / 255, green: 212 / 255, blue: 255 / 255),
                    .init(red: 9 / 255, green: 9 / 255, blue: 121 / 255),
                ]
            case .rainy: 
                return [
                    .init(red: 0 / 255, green: 212 / 255, blue: 255 / 255),
                    .init(red: 9 / 255, green: 9 / 255, blue: 121 / 255),
                ]
            }
        }
        
        var weatherIconName: String {
            switch self {
            case .sunny: return "sun.max.fill"
            case .rainy: return "cloud.rain.fill"
            }
        }
    }
    
    private var locationWeatherDetailsView: some View {
        VStack(alignment: .leading) {
            headerView
            temperatureView
            Spacer()
            Text("Hello \(viewModel.getCityName())!\nWeather: \(viewModel.getWeatherTemperature())\n\(viewModel.getWeatherWindSpeed())")
            Spacer()
        }.safeAreaPadding(.top, 80)
    }
    
    private var temperatureView: some View {
        HStack {
            Spacer()
            VStack {
                Text(viewModel.getWeatherTemperature())
                    .font(.system(size: 60))
                    .fontWeight(.light)
                HStack {
                    Text(viewModel.getMinTemperature())
                    Text("&")
                    Text(viewModel.getMaxTemperature())
                }
            }.foregroundStyle(.white.opacity(80))
            Spacer()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("\(viewModel.getCityName())")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .foregroundStyle(weatherCategory.titleColor)
            Image(systemName: weatherCategory.weatherIconName)
                .resizable(resizingMode: .stretch)
                .aspectRatio(contentMode: .fit)
                .frame(width: 26)
                .foregroundStyle(weatherCategory.titleColor)
            Spacer()
        }.padding()
    }
    
    private var loadingView: some View {
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

#Preview {
    let mockedProvider = WeatherServiceFactory.shared.createWeatherService(mocked: true)
    return WeatherView(viewModel: .init(weatherService: mockedProvider))
}
