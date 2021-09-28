//
//  ContentView.swift
//  swiftui-practice
//
//  Created by 이서준 on 2021/09/28.
//

// 코드가 너무 아래로 길긴한데..되게 직관적이다. 관련 지식이 있다면 주석이 필요 없을정도wow
import SwiftUI

struct ContentView: View {
    /*
     명확하지 않은 어떤 타입이 프로토콜에 정의 되어있으면, 컴파일 과정에서 명확하지 않은 타입이기 때문에 오류가 발생하는데,
     만약 함수나 연산 프로퍼티를 만들어서 이 프로토콜(명확하지 않은 어떤 타입)을 반환 타입으로 가지고 싶을 때, 그 오류를 없애기 위해서 타입을 명확하게 만들어 주어야 하는데,
     그 역할을 해주는것이 some 키워드이다. 이것을 쓰면 컴파일러에게 이 함수 또는 연산 프로퍼티는 동일한 명확한 타입을 가진 값만을 반환한다는 것을 알려준다.
     
     지금 body에는 Text, H/V/ZStack 등 View 프로토콜을 만족하는 다양한 구조체가 존재하는데, 얼마나 많은 구조체들이 선언될지 알수없으니 some을 쓰고 다양한 구조체들을 생성/삭제 한다.
    */
    var body: some View {
        ZStack {
            // safeArea영역에 색을 모두 채워버리는 작업
            Color.blue.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("SwiftUI")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                Spacer()
                MyButton(title: "Click Me", iconName: "paperplane.circle").padding()
            }
        }
        
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
