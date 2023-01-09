//
//  ViewController.swift
//  DynamicMemberLookup_Practice
//
//  Created by 이서준 on 2023/01/09.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    struct Person {
        var age: Int
        var name: String
    }

    var personObservable: Observable<Person> {
        Observable.create { observer in
            observer.onNext(.init(age: 12, name: "Lee"))
            observer.onCompleted()
            return Disposables.create()
        }
    }

    let disposeBag = DisposeBag()
    
    // KeyPath : 특정 속성에 대한 path정보를 가지고 있는 key값 (KeyPath 인스턴스를 통해 해당 값에 접근이 가능)
    
    // KeyPath 문법: '\' 키워드 + 유형 + 프로퍼티 이름
    let nameKeyPath: KeyPath<Person, String> = \Person.name
    let person = Person(age: 12, name: "Lee")
    
    // writableKeyPath
    let nameWritableKeyPath = \Person.name
    var writablePerson = Person(age: 12, name: "Lee")

    override func viewDidLoad() {
        super.viewDidLoad()
        print(person[keyPath: nameKeyPath])

        // KeyPath 활용 - RxSwift Observable 구독할때 특정 property를 가져오기 위해 map에서 사용(간결성 향상)
        personObservable
            .map(\.age)
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        // MARK: - WritableKeyPath
        writablePerson[keyPath: nameWritableKeyPath] = "abc"
        print(writablePerson)
    }
}

class ViewController2: UIViewController {
    // 명백한 member(프로퍼티) 표현이 아닐 때, 컴파일러가 subscript(:) 메서드를 보고 해당 멤버임을 받아들이게 하는 방법
    @dynamicMemberLookup
    struct SomeDictionary {
        let value = [
            "age": "12",
            "name": "Lee"
        ]
        subscript(dynamicMember member: String) -> String? {
            return value[member]
        }
    }
    
    let someDictionary = SomeDictionary()
    
    // KeyPath를 이용하면 Wrapper 타입처럼 사용 가능
    @dynamicMemberLookup
    struct MyContainer<T> {
        private let root: T
        
        init(_ root: T) {
            self.root = root
        }
        
        subscript<Value>(dynamicMember keyPath: WritableKeyPath<T, Value>) -> Value {
            return root[keyPath: keyPath]
        }
    }
    
    struct MyStruct {
        var name: String
        var age: Int
    }
    
    let myContainer = MyContainer(MyStruct(name: "Lee", age: 12))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // someDictionary.name으로 접근 가능, someDictionary.value.name도 아니고 name으로 곧바로 접근
        print(someDictionary.name ?? "")
        print(someDictionary.abc ?? "")
        print(someDictionary.age ?? "")
        
        // 똑같이 name으로 일반 프로퍼티처럼 곧바로 접근
        print(myContainer.name)
    }
}

