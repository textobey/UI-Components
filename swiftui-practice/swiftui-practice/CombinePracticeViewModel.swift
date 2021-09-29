//
//  CombinePracticeViewModel.swift
//  swiftui-practice
//
//  Created by 이서준 on 2021/09/29.
//

import Combine
import SwiftUI

/*
 class와 struct의 차이점.
 
 class: 참조타입, ARC로 메모리를 관리, 상속이 가능, 같은 클래스 인스턴스를 여러 개의 변수에 할당한 뒤 값을 변경시키면 할당한 모든 변수에 영향을 준다.
 struct: 값 타입, 구조체 변수를 새로운 변수에 할당할 때마다 새로운 구조체가 생성되기 때문에, 위처럼 여러 변수에 할당한 뒤 값을 변경해도 다른 변수에 영향을 주지 않는다.(값 자체를 복사)
 */

// ObservableObject 프로토콜을 채택함. ObservableObject는 class 타입에만 채택가능.
final class CombinePracticeViewModel: ObservableObject {
    // RxSwift의 disposeBag과 같은 역할을 담당한다. 해당 객체가 deinit될 때, 메모리 관리에 이용됨.
    private var cancellable = Set<AnyCancellable>()
    // viewModel 내부에서 index관련 이벤트를 처리하기 위한 Subject
    private var didTapIndexSubject = PassthroughSubject<Int, Never>()
    
    init() {
        bindOutputs()
    }
    
    enum Input {
        case didTap(index: Int)
    }
    
    func apply(_ input: Input) {
        switch input {
        case .didTap(let index):
            didTapIndexSubject.send(index)
        }
    }
    
    @Published var isErrorShown = false
    @Published var labelText: String?
    
    private func bindOutputs() {
        let isError = didTapIndexSubject
            .map { $0 == 4 }
            .share()
        
        isError
            .assign(to: \.isErrorShown, on: self)
            .store(in: &cancellable)
        
        didTapIndexSubject
            .map { "\($0)" }
            // RxSwift로 치면 bind(to:
            .assign(to: \.labelText, on: self)
            .store(in: &cancellable)
    }
}
