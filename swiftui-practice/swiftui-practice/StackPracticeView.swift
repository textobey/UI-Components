//
//  StackPracticeView.swift
//  swiftui-practice
//
//  Created by 이서준 on 2021/09/28.
//

import SwiftUI

struct StackPracticeView: View {
    var body: some View {
        // SubView들의 크기만큼 늘어나게 되며, 기본적으로 정중앙에 위치하게 됨
        HStack {
            Text("Hello world!")
            Text("Hello world!")
            Text("Hello world!")
        }.background(Color.purple)
        
        // SubView들이 아래로 내려가게 되며, 기본적으로 중앙 정렬
        VStack(alignment: .leading, spacing: 20) {
            Text("Hello world!")
            Text("Hello!")
            Text("Hi!")
        }.background(Color.purple)
        
        VStack {
            Text("Top")
            Spacer()
            Spacer().frame(height: 5)
            Text("Mid")
            Spacer()
            Text("Bot")
        }.background(Color.purple)
        
        // ZStack은 뷰를 겹쳐서 표현할때 사용하게 된다.
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .center, startRadius: 310, endRadius: 100)
            AngularGradient(gradient: Gradient(colors: [.red, .yellow, .blue, .purple]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Color.red.frame(width: 300, height: 300)
            Color(red: 0.1, green: 0.2, blue: 0.3).frame(width: 100, height: 200)
            Color.yellow.frame(width: 200, height: 200)
        }
        
        // Test.. 시계를 만들어보자~
        ZStack {
            AngularGradient(gradient: Gradient(colors: [.red, .yellow, .blue, .purple]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            HStack {
                VStack {
                    Text("11시")
                    Spacer()
                    Text("9시")
                    Spacer()
                    Text("7시")
                }
                Spacer()
                VStack {
                    Text("12시")
                    Spacer()
                    Text("ㅇ")
                    Spacer()
                    Text("6시")
                }
                Spacer()
                VStack {
                    Text("1시")
                    Spacer()
                    Text("3시")
                    Spacer()
                    Text("5시")
                }
            }
        }
    }
}
