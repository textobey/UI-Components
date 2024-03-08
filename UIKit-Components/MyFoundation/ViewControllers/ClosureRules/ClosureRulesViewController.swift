//
//  ClosureRulesViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 3/8/24.
//

import UIKit

class ClosureRulesViewController: UIBaseViewController {
    
    let myClass = MyClass()
    
    deinit {
        Log.d("⚠️ Deinit: ClosureRulesViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "RxCocoaTraits_Tests")
        myClass.doEverything1()
    }
}

class MyClass {
    
    var didSomething: Bool = false
    var didSomethingElse: Bool = false
    
    deinit {
        Log.d("⚠️ Deinit: MyClass")
    }
    
    // Point1. 중첩된 클로저에서 외부의 Weak self를 내부에서 재사용 할 수 있음
    func doEverything1() {
        self.doSomething { [weak self] in
            self?.didSomething = true
            print("did somthing")
            
            self?.doSomethingElse {
                self?.didSomethingElse = true
                print("did somthing Else")
            }
        }
    }
    
    // Point2. 내부 클로저에서 guard let self에 강한 참조가 생기며 순환 참조가 되는것을 조심해야함
    func doEverything2() {
        self.doSomething { [weak self] in
            guard let self = self else { return }
            self.didSomething = true
            print("did somthing")
            
            self.doSomethingElse {
                self.didSomethingElse = true // <- 내부 클로저의 약한 참조가 필요함
                print("did somthing Else")
            }
        }
    }
    
    // Point3. Point2에서 문제가 되었던 점을 우회?할 수 있음, 하지만 코드 가독성은 떨어짐
    func doEverything3() {
        self.doSomething { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.didSomething = true
            print("did somthing")
            
            strongSelf.doSomethingElse {
                self?.didSomethingElse = true // <- 내부 클로저의 약한 참조가 필요함
                print("did somthing Else")
            }
        }
    }
    
    func doSomething(_ completion: (() -> Void)?) {
        completion?()
    }
    
    func doSomethingElse(_ completion: (() -> Void)?) {
        completion?()
    }
}
