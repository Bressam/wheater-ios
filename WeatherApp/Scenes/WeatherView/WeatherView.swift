//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 08/06/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        contentView
            .onAppear(perform: handleOnAppear)
    }
    
    private var contentView: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
}

#Preview {
    let mockedProvider = WeatherServiceFactory.shared.createWeatherService(mocked: true)
    return WeatherView(viewModel: .init(weatherService: mockedProvider))
}
