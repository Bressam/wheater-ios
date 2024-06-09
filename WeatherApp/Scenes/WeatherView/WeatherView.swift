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
        
        var widgetBackground: Color {
            switch self {
            case .sunny: return Color.white.opacity(0.2)
            case .rainy: return Color(red: 9 / 255, green: 9 / 255, blue: 121 / 255).opacity(0.2)
            }
        }
    }
    
    private var locationWeatherDetailsView: some View {
        VStack(alignment: .leading) {
            headerView
            temperatureView
            hourlyTempView
                .padding(.top, 40)
            windDataView
        }.safeAreaPadding([.top, .bottom], 80)
    }
    
    private var windDataView: some View {
        VStack(alignment: .leading) {
            Text("Wind & Humidty")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(weatherCategory.widgetBackground)
                HStack(spacing: 32) {
                    HStack {
                        Image(systemName: "wind")
                            .resizable(resizingMode: .stretch)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 52)
                            .foregroundStyle(weatherCategory.titleColor)
                            .padding(.leading, 10)
                        VStack(alignment: .leading) {
                            Text(viewModel.getWindSpeed())
                                .font(.system(size: 22))
                            Text("Current")
                                .font(.caption)
                        }.foregroundStyle(.white)
                    }
                    HStack {
                        Image(systemName: "humidity.fill")
                            .resizable(resizingMode: .stretch)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 52)
                            .foregroundStyle(weatherCategory.titleColor)
                        VStack(alignment: .leading) {
                            Text(viewModel.getMaxHumidity())
                                .font(.system(size: 28))
                            Text("Max")                                .font(.caption)
                        }.foregroundStyle(.white)
                    }
                }
            }
        }.padding()
    }
    
    private var hourlyTempView: some View {
        VStack(alignment: .leading) {
            Text("Forecast")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.getHourlyDetails(), id: \.date) { hourlyTemp in
                        ZStack {
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(weatherCategory.widgetBackground)
                            VStack(spacing: 10) {
                                Text(hourlyTemp.temp)
                                    .font(.system(size: 18))
                                Image(systemName: "thermometer.sun")
                                Text("at \(hourlyTemp.date)")
                                    .font(.callout)
                            }.foregroundStyle(.white.opacity(80))
                        }.frame(width: 110, height: 110)
                    }
                }
            }
        }.padding()
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
                .font(.title2)
                .fontWeight(.medium)
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
