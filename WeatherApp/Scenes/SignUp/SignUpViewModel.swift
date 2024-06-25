//
//  SignUpViewModel.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 24/06/24.
//

import Foundation
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
}
