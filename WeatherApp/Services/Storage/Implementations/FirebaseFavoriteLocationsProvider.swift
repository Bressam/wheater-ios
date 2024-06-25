//
//  FirebaseFavoriteLocationsProvider.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 25/06/24.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

class FirebaseFavoriteLocationsProvider: FavoriteLocationsProvider {
    // MARK: - Properties
    private let db = Firestore.firestore()
    private lazy var locationsRef = db.collection("locations")
    private var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        return encoder
    }
    
    func addItem(_ favoriteLocationData: LocationCoordinate) {
        let coordinateFirestormData = LocationCoordinateFireStorm(from: favoriteLocationData)
        guard let data = try? encoder.encode(coordinateFirestormData),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String : Any]
        else {
            print("Failed to encode coordinate data. Cancelling add item to firestorm task.")
            return
        }
        locationsRef.document(favoriteLocationData.cityName).setData(json)
    }

    func removeItem(_ favoriteLocation: FavoriteLocation) async {
        do {
            try await locationsRef.document(favoriteLocation.cityName).delete()
            print("Document successfully removed!")
        } catch {
            print("Error removing document: \(error)")
        }
    }
    
    func getFavoriteLocations() async -> [FavoriteLocation] {
        do {
            let querySnapshot = try await db.collection("locations").getDocuments()
            var firebaseCoordinateResult: [LocationCoordinateFireStorm] = []
            for document in querySnapshot.documents {
//                print("\(document.documentID) => \(document.data())")
                if let firebaseCoordinateItem = try? document.data(as: LocationCoordinateFireStorm.self) {
                    firebaseCoordinateResult.append(firebaseCoordinateItem)
                }
                
            }
            return firebaseCoordinateResult.map({ .init(from: $0) })
        } catch {
            print("Error getting documents: \(error)")
            return []
        }
    }
}
