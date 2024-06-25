//
//  GradientHeaderView.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 24/06/24.
//

import SwiftUI

struct HeaderView: View {
    @State var colors: [Color]
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
                )
            Image(systemName: "sun.haze.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 160)
                .padding(.top, 50)
                .foregroundStyle(Color.yellow)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    HeaderView(colors: [
        .init(red: 26 / 255, green: 4 / 255, blue: 58 / 255),
        .init(red: 69 / 255, green: 23 / 255, blue: 181 / 255)
    ]).frame(height: 360)
}
