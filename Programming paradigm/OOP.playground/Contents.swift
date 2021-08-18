import Foundation

/// Dog class
class Dog {
    // Status, Data, Properties
    var bodyColor: String!
    var eyeColor: String!
    var height: Double!
    var weight: Double!
    // Method
    func sit() {}
    func lieDown() {}
    func tailShake() {}
}
// 객체화(Objectification)
let san: Dog = Dog()
san.eyeColor = "Black"
san.sit()

let seodol: Dog = Dog()
seodol.eyeColor = "Brown"
seodol.lieDown()

// 추상화(Abstraction) = 모델링 = 설계
// 대상의 불필요한 부분을 무시하며, 복잡성을 줄이고 목적에 집중할 수 있도록 단순화 시키는 것.
// 즉, 사물들의 공통점만 취하고 차이점을 버리는 일반화를 통한 단순화


// 상속성(Inheritance)
// 하나의 클래스의 특징(부모 클래스)을 다른 클래스가 물려받아 그 속성과 기능을 동일하게 사용하는 것
// 재사용과 확장에 의미가 있다. (상속은 수직확장, Extension은 수평 확장)
class Animal {
    func walking() { print("walking..") }
}
extension Dog {
    @objc func bark() { print("R R!") }
}

// 캡슐화(Encapsulation)
// 객체 상태를 나타내는 속성 정보를 접근 권한을 설정하여 관리하는 것.
class Cat: Animal {
    private var name: String = "Navi"
    
    private func eating() {
        print("Um..it's yummy")
    }
    private func sleeping() {
        print("Zzzz")
    }
    override func walking() {
        print("Cat walking..")
    }
    func dailyWorkProgress() {
        eating()
        sleeping()
    }
    func LetMeKnowCatName() {
        print("My cat name is \(name)")
    }
}
let cat = Cat()
cat.dailyWorkProgress()
cat.walking()
cat.LetMeKnowCatName()

// 다형성(Polymorphism)
// 다양한 형태로 나타날 수 있는 형태, 동일한 요청에 대해 각각 다른 방식으로 응답할 수 있도록 만드는 것.
// 다형성의 방식으로는 오버라이딩(overriding), 오버로딩(overloading)을 지원
class Husky: Dog {
    /// extension속 메서드를 override할 경우는, 해당 부모 클래스에서 @objc를 추가
    override func bark() {
        print("wal wal!")
    }
}
let husky: Husky = Husky()
husky.bark()

func printParameter() {
    print("No param")
}

//func printParameter() -> String { *Ambiguous Error
//    print("No param")
//    return ""
//}

func printParameter(number: Int) {
    print(number)
}

func printParameter(text: String) {
    print(text)
}

printParameter()
//printParameter() *Ambiguous Error
printParameter(number: 1)
printParameter(text: "text")
