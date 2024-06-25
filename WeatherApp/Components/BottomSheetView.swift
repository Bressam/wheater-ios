//
//  BottomSheetView.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 24/06/24.
//

import SwiftUI

struct BottomSheet<Content> : View where Content : View {
    var signIntitle: String
    var signUptitle: String
    var isSignUpView: Bool
    var content: (() -> Content)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
            VStack(alignment: .leading, spacing: SpacingConstants.xmedium.constant) {
                Text(isSignUpView ? signUptitle : signIntitle)
                    .font(.title)
                    .fontWeight(.medium)
                content()
                Spacer()
            }
            .padding(.top, SpacingConstants.xxlarge.constant)
            .padding([.leading, .trailing], SpacingConstants.medium.constant)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ZStack {
        Color.blue
        BottomSheet(signIntitle: "Sheet Title", signUptitle: "Sheet Title 2", isSignUpView: false, content: {
            Text("Content data")
        })
        .padding(.top, 300)
        .ignoresSafeArea()
    }
}
