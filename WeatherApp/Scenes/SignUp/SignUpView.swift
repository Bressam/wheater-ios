//
//  SignUpView.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 24/06/24.
//

import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    private var email: String = ""
    private var password: String = ""
    @State private var showingAlert = false
    @State private var storePassword: Bool = true
    
    var body: some View {
        VStack(spacing: -30) {
            HeaderView(colors: [
                .init(red: 26 / 255, green: 4 / 255, blue: 58 / 255),
                .init(red: 69 / 255, green: 23 / 255, blue: 181 / 255)
            ]).frame(height: 350)
            ZStack {
                BottomSheet(title: "Crie sua conta" ) {
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
        
    }
    
    private var siginInTipView: some View {
        HStack(alignment: .center) {
            Spacer()
            Text("Já possui uma conta?")
                .foregroundStyle(.gray)
                .fontWeight(.medium)
                .opacity(0.6)
            Button("Entre", action: { showingAlert = true })
            Spacer()
        }
    }
    
    private var buttonsStack: some View {
        VStackLayout(spacing: SpacingConstants.medium.constant) {
            PrimaryButton(buttonTitle: "Criar conta",
                          buttonAction: { showingAlert = true })
            .frame(height: ButtonSizeConstants.large.constant)
            
            SignInWithAppleButton(
                onRequest: { request in
                    showingAlert = true
                },
                onCompletion: { result in
                    //
                }
            ).frame(height: ButtonSizeConstants.appleSignIn.constant)
            siginInTipView
        }
    }
}

#Preview {
    SignUpView()
}
