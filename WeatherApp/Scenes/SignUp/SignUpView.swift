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
    private var email: String = ""
    private var password: String = ""
    @State private var showingAlert = false
    @State private var storePassword: Bool = true
    @State private var isSignUpView = true
    var didSignIn: DidSignInCompletion? = nil
    
    init(viewModel: SignUpViewModel,
         email: String = "",
         password: String = "",
         showingAlert: Bool = false,
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
                BottomSheet(signIntitle: "Crie sua conta",
                            signUptitle: "Login",
                            isSignUpView: isSignUpView) {
                    VStack(alignment: .leading,
                           spacing: SpacingConstants.large.constant) {
                        PrimaryTextField(fieldTitle: "E-mail",
                                         inputText: email)
                        PrimaryTextField(fieldTitle: "Senha",
                                         inputText: password,
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
            Alert(title: Text("Oups!"),
                  message: Text("Not implemented yet :("),
                  dismissButton: .cancel())
        }
        .onAppear(perform: {
            Task {
                await viewModel.testFB()
            }
        })
        
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
            didSignIn?()
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
