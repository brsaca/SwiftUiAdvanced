//
//  SettingsView.swift
//  SwiftUiAdvanced
//
//  Created by Brenda Saavedra  on 07/04/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var editingNameTextfield = false
    @State private var editingTwitterTextfield = false
    @State private var editingSiteTextfield = false
    @State private var editingBioTextfield = false
    
    @State private var nameIconBounce = false
    @State private var twitterIconBounce = false
    @State private var siteIconBounce = false
    @State private var bioIconBounce = false
    
    @State private var name = ""
    @State private var twitter = ""
    @State private var site = ""
    @State private var bio = ""
    
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 16) {
                Spacer().frame(height: 50)
                
                Text("Settings")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    .padding(.top)
                Text("Manage your Desing+Code profile and account")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.callout)
                
                // Choose Photo
                Button {
                    
                } label: {
                    HStack(spacing: 12) {
                        TextFieldIcon(iconName: "person.crop.circle", currentlyEditing: .constant(false))
                        GradientText(text: "Choose Photo")
                        Spacer()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .background(
                        Color.init(red: 26/255, green: 20/255, blue: 51/255)
                            .cornerRadius(16)
                    )
                }
                
                //Name textfield
                GradientTextfield(editingTextfield: $editingNameTextfield, textfieldString: $name, iconBounce: $nameIconBounce, textfieldPlaceholder: "Name", textfieldIconString: "textformat.alt")
                    .autocapitalization(.words)
                    .textContentType(.name)
                    .disableAutocorrection(true)
                
                //Twitter textfield
                GradientTextfield(editingTextfield: $editingTwitterTextfield, textfieldString: $twitter, iconBounce: $twitterIconBounce, textfieldPlaceholder: "Twitter", textfieldIconString: "at")
                    .autocapitalization(.none)
                    .keyboardType(.twitter)
                    .disableAutocorrection(true)
                
                //Site textfield
                GradientTextfield(editingTextfield: $editingSiteTextfield, textfieldString: $site, iconBounce: $siteIconBounce, textfieldPlaceholder: "Website", textfieldIconString: "link")
                    .autocapitalization(.none)
                    .keyboardType(.webSearch)
                    .disableAutocorrection(true)
                
                //Bio textfield
                GradientTextfield(editingTextfield: $editingBioTextfield, textfieldString: $bio, iconBounce: $bioIconBounce, textfieldPlaceholder: "Bio", textfieldIconString: "text.justifyleft")
                    .autocapitalization(.sentences)
                    .keyboardType(.default)
                
                GradientButton(buttonTitle: "Save Settings", buttonAction: {
                    generator.selectionChanged()
                })
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .background(Color("settingsBackground"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
