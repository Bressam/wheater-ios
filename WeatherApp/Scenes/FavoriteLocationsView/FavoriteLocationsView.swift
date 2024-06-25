//
//  FavoriteLocationsView.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 06/06/24.
//

import SwiftUI
import CoreData

struct FavoriteLocationsView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: FavoriteLocationsViewModel
    
    // MARK: - Setup
    init(viewModel: FavoriteLocationsViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View
    var body: some View {
        NavigationView {
                contentList
                .background(Gradient(colors:[
                    .init(red: 2 / 255, green: 0 / 255, blue: 36 / 255),
                    .init(red: 9 / 255, green: 9 / 255, blue: 121 / 255)
                ]))
        }.onAppear(perform: {
            Task {
                await viewModel.fetchFavoriteLocations()
            }
        })
    }
    
    private var contentList: some View {
        List {
            if viewModel.favoriteLocations.isEmpty {
                ContentUnavailableView {
                    Label("No favorite locations yet!",
                          systemImage: "list.bullet.below.rectangle")
                } description: {
                    Text("New favorite locations you add will appear here.")
                }
                
            } else {
                ForEach(viewModel.favoriteLocations) { item in
                    NavigationLink {
                        WeatherView(viewModel: viewModel.getWeatherViewModel(for: item))
                    } label: {
                        Text(item.cityName.isEmpty ? "Unknown Location" : item.cityName )
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
        .listRowBackground(Color.clear)
        .scrollContentBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }

    private func addItem() {
        Task {
            await viewModel.addItem()
            await viewModel.fetchFavoriteLocations()
           }
    }

    private func deleteItems(index: IndexSet) {
        Task {
            await viewModel.delete(atIndex: index)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    let mockedService = WeatherServiceFactory.shared.createWeatherService(mocked: true)
    let mockedLocationProvider = FavoriteLocationProviderFactory.shared.createProvider(type: .mocked)

    return FavoriteLocationsView(viewModel: .init(weatherService: mockedService, favoriteLocationsProvider: mockedLocationProvider))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
