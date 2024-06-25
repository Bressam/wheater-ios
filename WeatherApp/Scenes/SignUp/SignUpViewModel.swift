//
//  SignUpViewModel.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 24/06/24.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class SignUpViewModel {
    
    func createAccount(email: String, password: String) async -> Bool {
        print("\(email) & \(password)")
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            print("Sucesso!")
            print(authDataResult)
            return true
        } catch {
            print("Erro! \n \(error)")
            return false
        }
    }
    
    func login(email: String, password: String) async -> Bool {
        print("\(email) & \(password)")
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            print("Sucesso!")
            print(authDataResult)
            return true
        } catch {
            print("Erro! \n \(error)")
            return false
        }
    }
    
    // MARK: - Firebase test code
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
