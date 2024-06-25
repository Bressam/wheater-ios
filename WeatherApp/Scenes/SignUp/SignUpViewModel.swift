//
//  SignUpViewModel.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 24/06/24.
//

import Foundation
import FirebaseFirestore

class SignUpViewModel {
    let db = Firestore.firestore()
    lazy var locationsRef = db.collection("locations")
    
    func testFB() async {
        print("Testing FB data")
        setupFBData()
        await readFB()
    }

    func setupFBData() {
        locationsRef.document("City Test 1").setData([
            "cityName": "City Test 1",
            "creationDate": Date().timeIntervalSince1970,
            "latitude": 0,
            "longitude": 0,
        ])
        locationsRef.document("City Test 2").setData([
            "cityName": "City Test 2",
            "creationDate": Date().timeIntervalSince1970,
            "latitude": 2,
            "longitude": 2,
        ])
        locationsRef.document("City Test 3").setData([
            "cityName": "City Test 3",
            "creationDate": Date().timeIntervalSince1970,
            "latitude": 3,
            "longitude": 3,
        ])
    }
    
    func readFB() async {
        do {
            let querySnapshot = try await db.collection("locations").getDocuments()
            for document in querySnapshot.documents {
                print("\(document.documentID) => \(document.data())")
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
}
