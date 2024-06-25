//
//  SignUpView.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 24/06/24.
//

import SwiftUI
import AuthenticationServices

typealias DidSignInCompletion = () -> Void
struct SignUpView: View {
    var viewModel: SignUpViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var authError = false
    @State private var signUpError = false
    @State private var storePassword: Bool = true
    @State private var isSignUpView = false
    var didSignIn: DidSignInCompletion? = nil
    
    init(viewModel: SignUpViewModel,
         email: String = "",
         password: String = "",
         showingAlert: Bool = false,
         authErrorAlert: Bool = false,
         storePassword: Bool = true,
         didSignIn: DidSignInCompletion? = nil) {
        self.viewModel = viewModel
        self.email = email
        self.password = password
        self.showingAlert = showingAlert
        self.storePassword = storePassword
        self.didSignIn = didSignIn
    }
    
    var body: some View {
        VStack(spacing: -30) {
            HeaderView(colors: [
                .init(red: 26 / 255, green: 4 / 255, blue: 58 / 255),
                .init(red: 69 / 255, green: 23 / 255, blue: 181 / 255)
            ]).frame(height: 350)
            ZStack {
                BottomSheet(signIntitle: "Login",
                            signUptitle: "Crie sua conta",
                            isSignUpView: isSignUpView) {
                    VStack(alignment: .leading,
                           spacing: SpacingConstants.large.constant) {
                        PrimaryTextField(fieldTitle: "E-mail",
                                         inputText: $email)
                        PrimaryTextField(fieldTitle: "Senha",
                                         inputText: $password,
                                         isSecured: true,
                                         style: .password) {
                            showingAlert = true
                        }
                        buttonsStack
                        Spacer()
                    }
                }
            }
        }.ignoresSafeArea()
        .alert(isPresented: $showingAlert) {
            createAlert()
        }
    }
    
    private func createAlert() -> Alert {
        let view: Alert

        if authError {
            view = Alert(title: Text("Oups!"),
                         message: Text("Failed to authenticate! Please make sure you provided right email and password"),
                         dismissButton: .cancel())
        } else if signUpError {
            view = Alert(title: Text("Oups!"),
                         message: Text("Failed to create account! Please make sure you provided valid email and password at least 6 characters long."),
                         dismissButton: .cancel())
        } else {
            view = Alert(title: Text("Oups!"),
                         message: Text("Not implemented yet :("),
                         dismissButton: .cancel())
        }

        return view
    }
    
    private var siginInTipView: some View {
        HStack(alignment: .center) {
            Spacer()
            Text(isSignUpView ? "Já possui uma conta?" : "Não possui uma conta?")
                .foregroundStyle(.gray)
                .fontWeight(.medium)
                .opacity(0.6)
            Button(isSignUpView ? "Entre" : "Criar", action: {
                isSignUpView.toggle()
            })
            Spacer()
        }
    }
    
    private func topButton(title: String) -> some View {
        return PrimaryButton(buttonTitle: title,
                      buttonAction: {
            Task {
                let success: Bool
                if isSignUpView {
                    success = await viewModel.createAccount(email: email, password: password)
                    
                } else {
                    success = await viewModel.login(email: email, password: password)
                }
                guard success else {
                    if isSignUpView {
                        signUpError = true
                    } else {
                        authError = true
                    }
                    showingAlert = true
                    return
                }
                didSignIn?()
            }
        })
    }
    
    private var buttonsStack: some View {
        VStackLayout(spacing: SpacingConstants.medium.constant) {
            if isSignUpView {
                topButton(title: "Criar conta").frame(height: ButtonSizeConstants.large.constant)
            } else {
                topButton(title: "Entrar").frame(height: ButtonSizeConstants.large.constant)
            }
            
            SignInWithAppleButton(
                onRequest: { request in
                    showingAlert = true
                },
                onCompletion: { result in
                    //
                }
            ).frame(height: ButtonSizeConstants.appleSignIn.constant)
                .opacity(isSignUpView ? 1 : 0)
            siginInTipView
        }
    }
}

#Preview {
    SignUpView(viewModel: .init())
}
