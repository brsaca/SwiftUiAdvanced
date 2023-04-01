//
//  GradientButton.swift
//  SwiftUiAdvanced
//
//  Created by Brenda Saavedra  on 01/04/23.
//

import SwiftUI

struct GradientButton: View {
    
    var gradient1: [Color] = [
        Color.init(red: 101/255, green: 134/255, blue: 1),
        Color.init(red: 1, green: 64/255, blue: 80/255),
        Color.init(red: 109/255, green: 1, blue: 185/255),
        Color.init(red: 39/255, green: 232/255, blue: 1)
    ]
    
    var body: some View {
        Button(action: {
            print("Sign up")
        }, label: {
            GeometryReader() { geometry in
                ZStack {
                    AngularGradient(colors: gradient1, center: .center, angle: .degrees(0))
                        .blendMode(.overlay)
                        .blur(radius: 8.0)
                        .mask(
                            RoundedRectangle(cornerRadius: 16.0)
                                .frame(height: 50)
                                .frame(maxWidth: geometry.size.width - 16)
                                .blur(radius: 8.0)
                        )
                    GradientText(text: "Sign Up")
                        .font(.headline)
                        .frame(maxWidth: geometry.size.width - 16)
                        .frame(height: 50)
                        .background(
                            Color("tertiaryBackground").opacity(0.9)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white, lineWidth: 1.9)
                                .blendMode(.normal)
                                .opacity(0.7)
                        )
                        .cornerRadius(16)
                }
            }
            .frame(height: 50)
        })
    }
}
