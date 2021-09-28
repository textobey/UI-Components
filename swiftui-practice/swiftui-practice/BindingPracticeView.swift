//
//  BindingPracticeView.swift
//  swiftui-practice
//
//  Created by 이서준 on 2021/09/28.
//

import SwiftUI

enum Mood: String {
    case happy = "😊"
    case sad = "😢"
    case lol = "🤣"
    case upset = "😡"
}

struct BindingPracticeView: View {
    @State var name: String = "Hello"
    @State var favoriteColor: Color = .red
    @State var mood: Mood = Mood.happy
    
    var body: some View {
        VStack {
            //$가 붙으면 값을 수정가능한 Binding타입 참조합니다.
            StatusController(name: $name, favoriteColor: $favoriteColor, mood: $mood)
            StatusIcon(name: name, favoriteColor: favoriteColor, mood: mood)
        }
    }
}

struct StatusController: View {
    @Binding var name: String
    @Binding var favoriteColor: Color
    @Binding var mood: Mood
    
    var body: some View {
        VStack(alignment: .center) {
            TextField("Name", text: $name)
            HStack {
                ColorPicker("Favorite Color", selection: $favoriteColor)
                Picker("Mood", selection: $mood) {
                    Text(Mood.happy.rawValue).tag(Mood.happy)
                    Text(Mood.sad.rawValue).tag(Mood.sad)
                    Text(Mood.lol.rawValue).tag(Mood.lol)
                    Text(Mood.upset.rawValue).tag(Mood.upset)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }.padding()
    }
}

struct StatusIcon: View {
    let name: String
    let favoriteColor: Color
    let mood: Mood
    
    var body: some View {
        VStack {
            VStack {
                Text(mood.rawValue)
                Text(name)
                    .foregroundColor(.white)
            }
            .font(.largeTitle)
            .padding()
            .background(favoriteColor)
            .cornerRadius(12)
        }.padding()
    }
}
