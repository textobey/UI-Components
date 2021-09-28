//
//  ButtonView.swift
//  swiftui-practice
//
//  Created by 이서준 on 2021/09/28.
//

import SwiftUI

struct ButtonPracticeView: View {
    var body: some View {
        ZStack {
            // safeArea영역에 색을 모두 채워버리는 작업
            Color.gray.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("SwiftUI")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                Spacer()
                MyButton(title: "Click Me", iconName: "paperplane.circle").padding()
            }
        }
    }
}

struct MyButton: View {
    var title: String
    var iconName: String

    var body: some View {
        Button(action: {
            print("tapped!")
        }) {
            HStack {
                Image(systemName: iconName)
                    .font(.title)
                Text(title)
                    .fontWeight(.semibold)
                    .font(.title)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(40)
        }
    }
}
