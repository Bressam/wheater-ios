//
//  PrimaryTextField.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 24/06/24.
//

import SwiftUI

enum TextFieldStyle {
    case regular, password
    
    var hasSecurityToggle: Bool {
        switch self {
        case .regular: false
        case .password: true
        }
    }
    
    var hasStorePasswordSwitch: Bool {
        switch self {
        case .regular: false
        case .password: true
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .regular: ""
        case .password: "Recuperar senha"
        }
    }
}

struct PrimaryTextField: View {
    @State var fieldTitle: String
    @Binding var inputText: String
    @State var isSecured: Bool = false
    @State var style: TextFieldStyle = .regular
    var buttonAction: (() -> Void)? = nil
    @State private var storePassword: Bool = true
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: SpacingConstants.xsmall.constant) {
            HStack {
                Text(fieldTitle)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                if let buttonAction {
                    Spacer()
                    Button(action: buttonAction, label: {
                        Text(style.buttonTitle)
                    })
                }
            }
            
            HStack {
                inputField
                    .padding(.leading, SpacingConstants.small.constant)
                    .frame(height: 48)
                Spacer()
                if style.hasSecurityToggle {
                    Button(action: {
                        isSecured.toggle()
                    }, label: {
                        if isSecured {
                            Image(systemName: "eye")
                                .foregroundStyle(.gray.opacity(0.8))
                        } else {
                            Image(systemName: "eye.slash")
                                .foregroundStyle(.gray.opacity(0.8))
                        }
                    }).padding(.trailing, SpacingConstants.small.constant)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: RadiusConstants.small.constant)
                    .stroke(.highlight, lineWidth: 2.5)
            }
            
            if style.hasStorePasswordSwitch {
                storePasswordSwitch
                    .padding(.top, SpacingConstants.xsmall.constant)
            }
        }
    }
    
    @ViewBuilder
    private var inputField: some View {
        if isSecured {
            SecureField("", text: $inputText)
                .foregroundStyle(.gray)
                .font(.caption2)
                .fontWeight(.ultraLight)
        } else {
            TextField("", text: $inputText)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .font(.callout)
                .foregroundStyle(.gray)
        }
    }
    
    private var storePasswordSwitch: some View {
        HStack {
            Toggle(isOn: $storePassword, label: {
                Text("Lembrar minha senha")
                    .font(.caption)
            })
        }
    }
}
//
//#Preview(traits: .sizeThatFitsLayout) {
//    PrimaryTextField(fieldTitle: "Field title", inputText: $"")
//        .padding(24)
//}
//
//#Preview(traits: .sizeThatFitsLayout) {
//    PrimaryTextField(fieldTitle: "Field title", inputText: $"",
//                     isSecured: true,
//                     style: .password)
//    .padding(24)
//}
