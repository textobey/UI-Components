//
//  TextView.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/23.
//

import SwiftUI

struct TextView: View {
    @Binding var maxLength: Int
    @Binding var placeHolder: String
    @Binding var currentText: String
    
    var body: some View {
        VStack {
            ZStack {
                UIKitTextView(text: $currentText, maxLength: $maxLength, placeHolder: $placeHolder)
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 16)
                
                Text("\(currentText.count)/\(maxLength)")
                    .background(Color.clear)
                    .foregroundColor(.black)
                    .padding([.trailing, .bottom], 16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.gray, lineWidth: 2)
            )
            .padding([.leading, .trailing], 16)
            .frame(width: UIScreen.main.bounds.size.width, height: 400, alignment: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct UIKitTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var maxLength: Int
    @Binding var placeHolder: String
    
    func makeCoordinator() -> Coordinator {
        //Coordinator($text, $maxLength)
        return Coordinator(parent1: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: UIKitTextView
        
        init(parent1: UIKitTextView) {
            parent = parent1
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async { [weak self] in
                // 제한된 글자수보다 더 입력을 시도할때, DispatchQueue를 이용하여 mainThread에서
                // textView.text.removeLast()의 동작 수행을 Serial하게 지정한다.
                if textView.text.count > self?.parent.maxLength ?? 0 {
                    textView.text.removeLast()
                }
                self?.parent.text = textView.text
            }
            if textView.markedTextRange == nil {
                parent.text = textView.text ?? String()
            }
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeHolder
                textView.textColor = UIColor.lightGray
            }
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // textView의 text가 바뀐 range를 계산해서
            guard let rangeOfTextToReplace = Range(range, in: textView.text) else { return false }
            // 바뀐 text 내용을 가져옴
            let substringToReplace = textView.text[rangeOfTextToReplace]
            // 현재길이 = textView.text.count - 바뀐 text 내용.count + 입력된 text
            let currentLength = textView.text.count - substringToReplace.count + text.count
            if currentLength > (parent.maxLength + 1) {
                // (maxLength + 1)을 초과하여 입력하지 못함
                return false
            }
            return true
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextView {
        let textView = UITextView()
        textView.contentInset = .zero
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        // set delegate
        textView.delegate = context.coordinator
        // set placeHolder
        textView.text = placeHolder
        textView.textColor = UIColor.lightGray
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<Self>) {
        
    }
}
