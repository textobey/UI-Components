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
        NavigationView {
            List() {
                NavigationLink(
                    destination: ButtonPracticeView(),
                    label: {
                        Text("Navigate To buttonView")
                    }).padding(16)
                
                NavigationLink(
                    destination: StackPracticeView(),
                    label: {
                        Text("Navigate To stackPracticeView")
                    }).padding(16)
                
                NavigationLink(
                    destination: BindingPracticeView(),
                    label: {
                        Text("Navigate To bindingPracticeView")
                    }).padding(16)
                
                NavigationLink(
                    destination: ListPracticeView(),
                    label: {
                        Text("Navigate To listPracticeView")
                    }).padding(16)
                
                NavigationLink(
                    destination: CombinePracticeView(viewModel: .init()),
                    label: {
                        Text("Navigate To combinePracticeView")
                    }).padding(16)
            }
            .navigationTitle("Main")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
