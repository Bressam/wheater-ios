//
//  BottomSheetView.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 24/06/24.
//

import SwiftUI

struct BottomSheet<Content> : View where Content : View {
    @State var title: String
    var content: (() -> Content)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
            VStack(alignment: .leading, spacing: SpacingConstants.xmedium.constant) {
                Text(title)
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
        BottomSheet(title: "Sheet Title", content: {
            Text("Content data")
        })
        .padding(.top, 300)
        .ignoresSafeArea()
    }
}
