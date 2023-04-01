//
//  GradientText.swift
//  SwiftUiAdvanced
//
//  Created by Brenda Saavedra  on 01/04/23.
//

import SwiftUI

struct GradientText: View {
    
    var text: String = "Text here"
    
    var body: some View {
        Text(text)
            .gradientForeground(colors: [Color("pink-gradient-1"), Color("pink-gradient-2")])
    }
}

extension View {
    public func gradientForeground(colors:[Color]) -> some View {
        self.overlay(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(self)
    }
}
