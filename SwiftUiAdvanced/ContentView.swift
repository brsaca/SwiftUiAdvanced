//
//  ContentView.swift
//  SwiftUiAdvanced
//
//  Created by Brenda Saavedra  on 01/04/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var email: String = ""

    var body: some View {
        ZStack {
            Image("background-3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sign up")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    Text("Access to 120+ hours of courses, tutorias, and livestreams")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.open.fill").foregroundColor(.white)
                            .padding(.leading, 12)
                        TextField("Email", text: $email).colorScheme(.dark)
                            .foregroundColor(.white.opacity(0.7))
                            .autocapitalization(.none)
                            .textContentType(.emailAddress)
                    }
                    .frame(height: 52)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 1.0)
                            .blendMode(.overlay)
                    )
                    .background(
                        Color("secondaryBackground")
                            .cornerRadius(16.0)
                            .opacity(0.8)
                    )
                    
                }
                .padding(20)
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(VisualEffectBlur(blurStyle: .systemThinMaterialDark))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y:30)
            )
            .cornerRadius(30)
            .padding(.horizontal)
        }
    }

    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
