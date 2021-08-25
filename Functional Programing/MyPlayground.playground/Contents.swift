import UIKit

// MARK: - 순수함수(Pure Function)
class Sports {
    var sportsName: String = "football"
    func getSportsName() -> String {
        return sportsName
    }
}
/// 외부 변수에 영향을 받기 때문에, 해당 변수가 변하면 다른 output이 배출됨(side-effect), 순수함수X
/// 그러나, sportsName이 let으로 불변이 되면(immutable data), 항상 같은 output을 배출하기 때문에 순수함수O
let sports: Sports = Sports()
sports.getSportsName()

class Animal {
    func getAnimalCategory(category: String) -> String {
        return category
    }
}
/// output이 intput에 의해서만 결정됨. 외부 변수를 이용하지 않음, 변경하지도 않음(no side-effect)
/// 특정 input에 대해서 항상 동일한 output을 배출함.
let animal: Animal = Animal()
animal.getAnimalCategory(category: "cat")
// - End Pure Function

// 1급객체: 프로그래밍 언어에서 함수의 파라미터로 전달되거나 리턴값으로 사용될 수 있는 객체
// 함수형 프로그래밍에서는 함수를 1급 객체로 취급한다.

// MARK: - 함수의 합성(Composition)
// 함수의 반환값이 다른 함수의 입력값으로 사용되는 것.
func f1(_ num: Int) -> Int {
    return num + 3
}
func f2(_ i: Int) -> String {
    return "\(i) - 3은 f1의 paramater"
}
let result: String = f2(f1(10))

/// pf1과 pf2(클로저)가 반환(return)된 후에 실행되도록 @escaping(탈출)클로저로 지정
func ff(_ pf1: @escaping (Int) -> Int, _ pf2: @escaping (Int) -> String) -> (Int) -> String {
    return { (s1: Int) in
        return pf2(pf1(s1))
    }
}
let f3 = ff(f1, f2)
let result2: String = f3(100)
/// ff to Generic
func comp<A, B, C>(_ pf1: @escaping (A) -> B, _ pf2: @escaping (B) -> C) -> (A) -> C {
    return { i in
        return pf2(pf1(i))
    }
}
let f4 = comp(f1, f2)
let resultComp = f4(200)
// - End Composition

// MARK: - 커링(Currying)
// 여러개의 파라미터를 받는 함수를 하나의 파라미터를 받는 여러개의 함수로 쪼개는 것
// -> 함수의 합성을 원활하게 함
// not
func multiply(_ s1: Int, s2: Int) -> Int {
    return s1 * s2
}
func curriedMultiple(_ s1: Int) -> (Int) -> Int {
    return { s2 in
        return s1 * s2
    }
}
let result3 = curriedMultiple(10)(20)

// MARK: - Practice
// 1부터 100까지 3의 배수일때 fizz, 5의 배수일때 buzz, 3과 5의 배수일 때 fizzbuzz를 출력하는 프로그램
//명령형 프로그래밍 방식
class FPPractice {
    var i = 1
    /// 명령형 프로그래밍(imperative programming)
    func getFizzBuzzWithImperative() {
        while i <= 100 {
            if i % 3 == 0, i % 5 == 0 {
                print("fizzbuzz")
            } else if i % 3 == 0 {
                 print("fizz")
            } else if i % 5 == 0 {
                print("buzz")
            } else {
                print("\(i)")
            }
            i += 1
        }
    }
    let log: (String) -> () = { print($0) }
    
    func getFizzBuzzWithFunctionalProgramming() {
        let comp = comp(fizzBuzzWithEmptyCheck(_:))
        print((1...100).map(comp).forEach(log))
    }
    private func fizzBuzz(_ num: Int) -> String {
        return fizz(num) + buzz(num)
    }
    private func fizz(_ num: Int) -> String {
        return num % 3 == 0 ? "fizz" : ""
    }
    private func buzz(_ num: Int) -> String {
        return num % 5 == 0 ? "buzz" : ""
    }
    private func fizzBuzzWithEmptyCheck(_ num: Int) -> String {
        let result = fizzBuzz(num)
        return result.isEmpty ? "\(num)" : result
    }
    private func comp(_ f1: @escaping (Int) -> String) -> (Int) -> String {
        return { num in
            return f1(num)
        }
    }
}

let fpPractice: FPPractice = FPPractice()
fpPractice.getFizzBuzzWithFunctionalProgramming()

func solution(_ rows: Int, _ columns: Int, _ queries: [[Int]]) -> [Int] {
    var count = 1
    var board: [[Int]] = []
    
    for i in 0 ..< rows {
        board.append([count])
        for _ in 0 ..< columns {
            count += 1
            board[i].append(count)
        }
        
    }
    board.forEach {
        print($0)
    }
    return []
}

func functionalSolution(_ rows: Int, _ columns: Int, _ queries: [[Int]]) -> [Int] {
    let board: [[Int]] = (0 ..< rows).map { row in
        (1 ... columns).map { (row * columns) + $0 }
    }
    let log: ([[Int]]) -> () = { print($0) }
    
    log(board)
    return []
}

functionalSolution(2, 4, [[]])

/*
Low-High 는 사용자로부터 숫자를 입력받아 랜덤(1~100)으로 생성된 값과 비교하여,
큰 값이 입력되면 High
작은 값이 입력되면 Low
같으면 Correct! 를 출력합니다.
Correct 출력 시 시도했던 횟수를 함께 출력합니다.
수행은 Correct가 될 때까지 무한반복됩니다.
숫자가 입력되지 않으면 Wrong 을 출력합니다.
*/

enum Result: String {
    case high = "High"
    case low = "Low"
    case correct = "Correct!"
    case wrong = "wrong"
}

class LowHigh {
    var randomNumber: Int = Int.random(in: 1 ... 100)
    var input: Int?
    lazy var state: Result = getLowHigh()
    
    func whileCompare() {
        while getLowHigh() != .correct {
            randomNumber = Int.random(in: 1 ... 100)
            print(getLowHigh().rawValue)
            if getLowHigh() == .wrong {
                break
            }
        }
    }
    
    func getLowHigh() -> Result {
        if input == nil {
            //print("wrong")
            return .wrong
        } else if input! > randomNumber {
            //print("randomNumber is \(randomNumber)...high")
            return .high
        } else if input! < randomNumber {
            //print("randomNumber is \(randomNumber)...low")
            return .low
        } else {
            //print("randomNumber is \(randomNumber)...correct")
            return .correct
        }
    }
}

let lowHigh: LowHigh = LowHigh()
//lowHigh.input = 9
lowHigh.whileCompare()
