//
//  GradientTextfield.swift
//  SwiftUiAdvanced
//
//  Created by Brenda Saavedra  on 07/04/23.
//

import SwiftUI

struct GradientTextfield: View {
    
    @Binding var editingTextfield: Bool
    @Binding var textfieldString: String
    @Binding var iconBounce: Bool
    var textfieldPlaceholder: String
    var textfieldIconString: String
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        HStack(spacing: 12) {
            TextFieldIcon(iconName: textfieldIconString,  currentlyEditing: $editingTextfield)
                .scaleEffect(iconBounce ? 1.2 : 1.0)
            TextField(textfieldPlaceholder, text: $textfieldString) { isEditing in
                generator.selectionChanged()
                editingTextfield = isEditing
                if isEditing {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                        iconBounce.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                            iconBounce.toggle()
                        }
                    }
                }
            }
            .colorScheme(.dark)
            .foregroundColor(.white.opacity(0.7))
            .autocapitalization(.none)
            .textContentType(.emailAddress)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .stroke(.white, lineWidth: 1)
                .blendMode(.overlay)
        )
        .background(
            Color(red: 26/255, green: 20/255, blue: 51/255)
                .cornerRadius(16)
        )
    }
}

struct GradientTextfield_Previews: PreviewProvider {
    static var previews: some View {
        GradientTextfield(editingTextfield: .constant(true), textfieldString: .constant("Some string here"), iconBounce: .constant(false), textfieldPlaceholder: "Test Textfield", textfieldIconString: "textformat.alt")
    }
}
