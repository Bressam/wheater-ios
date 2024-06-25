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
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteLocationCoreData.creationDate, ascending: true)],
        animation: .default)
    private var items: FetchedResults<FavoriteLocationCoreData>
    
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
                        Text(item.cityName ?? "Unknown Location")
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
        withAnimation {
        Task {
            let newItem = FavoriteLocationCoreData(context: viewContext)
            newItem.creationDate = Date()
            let currentLocationData = try await viewModel.getCurrentLocationData()
            newItem.cityName = currentLocationData.cityName
            newItem.latitude = currentLocationData.latitude
            newItem.longitude = currentLocationData.longitude
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
                    }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
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
