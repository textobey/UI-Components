//
//  TextField.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/23.
//

import SwiftUI

struct TextField: View {
    @Binding var maxLength: Int
    @Binding var placeHolder: String
    @Binding var currentText: String
    
    var body: some View {
        VStack {
            ZStack {
                UIKitTextField(text: $currentText, maxLength: $maxLength, placeHolder: $placeHolder)
                    .padding([.leading, .trailing], 10)
                
                Group {
                    Text("\(currentText.count)/")
                        .foregroundColor(.black)
                        .font(Font.montserrat(size: 10, style: .regular)) +
                    Text("\(maxLength)자")
                        .foregroundColor(.gray)
                        .font(Font.montserrat(size: 10, style: .regular))
                }
                .padding(.trailing, 10)
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 2)
        )
        .padding([.leading, .trailing], 16)
        .frame(width: UIScreen.main.bounds.size.width, height: 40, alignment: .center)
    }
}


struct UIKitTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var maxLength: Int
    @Binding var placeHolder: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent1: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: UIKitTextField
        
        init(parent1: UIKitTextField) {
            parent = parent1
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let rangeOfTextToReplace = Range(range, in: textField.text ?? "") else { return false }
            let substringToReplace = textField.text![rangeOfTextToReplace]
            let currentLength = (textField.text?.count ?? 0) - substringToReplace.count + string.count
            if currentLength > (parent.maxLength + 1) {
                return false
            }
            return true
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            guard let string = textField.text else { return }
            DispatchQueue.main.async { [weak self] in
                if string.count > self?.parent.maxLength ?? 0 {
                    textField.text?.removeLast()
                }
                self?.parent.text = textField.text!
            }
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextField {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = context.coordinator
        textField.placeholder = placeHolder
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<Self>) {
        
    }
}
