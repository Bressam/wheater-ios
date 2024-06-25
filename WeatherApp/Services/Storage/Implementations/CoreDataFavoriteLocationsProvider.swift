//
//  CoreDataFavoriteLocationsProvider.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 25/06/24.
//

import Foundation
import CoreData

class CoreDataFavoriteLocationsProvider: FavoriteLocationsProvider {
    private let objectContext: NSManagedObjectContext

    init(objectContext: NSManagedObjectContext) {
        self.objectContext = objectContext
    }
    
    func addItem(_ currentLocationData: LocationCoordinate) {
        let newItem = FavoriteLocationCoreData(context: objectContext)
        newItem.creationDate = Date()
        newItem.cityName = currentLocationData.cityName
        newItem.latitude = currentLocationData.latitude
        newItem.longitude = currentLocationData.longitude
        
        do {
            try objectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func getFavoriteLocations() async -> [FavoriteLocation] {
        let coreDataEntities = getCoreDataItems()
        let favoriteLocations: [FavoriteLocation] = coreDataEntities.map({ .init(from: $0) })
        return favoriteLocations
    }
    
    private func getCoreDataItems() -> [FavoriteLocationCoreData] {
        let request: NSFetchRequest<FavoriteLocationCoreData> = FavoriteLocationCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteLocationCoreData.creationDate, ascending: true)]
        
        do {
            let coreDataEntities = try objectContext.fetch(request)
            return coreDataEntities
        } catch {
            print("Failed to fetch favorite locations: \(error)")
            return []
        }
    }
    
    func removeItem(_ favoriteLocation: FavoriteLocation) {
        let coreDataEntities = getCoreDataItems()
        guard let requestedItem = coreDataEntities.first(where: { $0.cityName == favoriteLocation.cityName })
        else {
            print("Error: Failed to remove requested item. Could not find it on database.")
            return
        }
        
        objectContext.delete(requestedItem)
        do {
            try objectContext.save()
        } catch {
            print("Error: Failed to save db context after deletion. Rollingback.")
            objectContext.rollback()
        }
    }
    
}
