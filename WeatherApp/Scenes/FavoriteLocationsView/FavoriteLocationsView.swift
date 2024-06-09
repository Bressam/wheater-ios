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
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteLocation.creationDate, ascending: true)],
        animation: .default)
    private var items: FetchedResults<FavoriteLocation>
    
    @ObservedObject var viewModel: FavoriteLocationsViewModel
    
    // MARK: - Setup
    init(viewModel: FavoriteLocationsViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View
    var body: some View {
        NavigationView {
            List {
                if items.isEmpty {
                    ContentUnavailableView {
                        Label("No favorite locations yet!",
                              systemImage: "list.bullet.below.rectangle")
                    } description: {
                        Text("New favorite locations you add will appear here.")
                    }

                } else {
                    ForEach(items) { item in
                        NavigationLink {
                            WeatherView(viewModel: viewModel.getWeatherViewModel(for: item))
                        } label: {
                            Text(item.creationDate!, formatter: itemFormatter)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
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
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = FavoriteLocation(context: viewContext)
            newItem.creationDate = Date()
            newItem.cityName = "Curitiba"
            newItem.latitude = -25.441105
            newItem.longitude = -49.276855

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
    return FavoriteLocationsView(viewModel: .init(weatherService: mockedService))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
