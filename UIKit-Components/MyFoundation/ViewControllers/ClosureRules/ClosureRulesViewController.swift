//
//  ClosureRulesViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 3/8/24.
//

import UIKit

class ClosureRulesViewController: UIBaseViewController {
    
    let myClass = MyClass()
    
    var presented = PresentedController()
    
    var workItem: DispatchWorkItem?
    var animationStorage: UIViewPropertyAnimator?
    
    deinit {
        Log.d("⚠️ Deinit: ClosureRulesViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "RetainCycle_Tests")
    }
    
    // PresentedController Class의 클로저 프로퍼티에 저장하게 되는 코드
    // 이는 눈에 잘 띄지 않아 파악하기 어렵지만 잘 숨겨진 메모리 누수 코드가 된다.
    func setupClosure() {
        presented.closure = printer
    }
    
    func printer() {
        print(self.view.description)
    }
    
    // GCD 호출은 나중에 실행하기 위해 프로퍼티에 저장하지 않는 한 순환 참조 위험이 없다.
    func nonLeakyDispatchQueue() {
        // asyncAfter는 escaping closoure이지만, deadline 시간이 지난후에 메모리에서 해제되기 때문에 [weak self] 사용하지 않아도됨
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.view.backgroundColor = .red
        }

        DispatchQueue.main.async {
            self.view.backgroundColor = .red
        }

        DispatchQueue.global(qos: .background).async {
            print(self.navigationItem.description)
        }
    }
    
    // 이 경우에는 프로퍼티에 저장하고 있기 때문에, 순환 참조의 위험이 있기에 [weak self]를 사용하여 방지해야함
    func leakyDispatchQueue() {
        let workItem = DispatchWorkItem { // [weak self] 필요
            self.view.backgroundColor = .red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
        self.workItem = workItem // stored in a property
    }
    
    // UIView.animate, UIViewPropertyAnimator도 GCD와 똑같이 프로퍼티에 저장하지 않는 한 순환 참조 위험이 없다.
    func animteToRed() {
        UIView.animate(withDuration: 3.0) {
            self.view.backgroundColor = .red
        }
    }
    
    // 이 경우에는 프로퍼티에 저장하고 있기 때문에, 순환 참조의 위험이 있기에 [weak self]를 사용하여 방지해야함
    func setupAnimation() {
        let anim = UIViewPropertyAnimator(duration: 2.0, curve: .linear) { // [weak self]
            self.view.backgroundColor = .red
        }
        anim.addCompletion { _ in // [weak self]
            self.view.backgroundColor = .white
        }
        self.animationStorage = anim
    }
}

class PresentedController {
    var closure: (() -> Void)?
}

class MyClass {
    
    var doSomething: (() -> Void)?
    var doSomethingElse: (() -> Void)?
    
    var didSomething: Bool = false
    var didSomethingElse: Bool = false
    
    deinit {
        Log.d("⚠️ Deinit: MyClass")
    }
    
    // Point1. 중첩된 클로저에서 외부의 weak self를 내부에서 재사용 할 수 있음
    func doEverything1() {
        self.doSomething = { [weak self] in
            self?.didSomething = true
            print("did somthing")
            
            self?.doSomethingElse = {
                self?.didSomethingElse = true
                print("did somthing Else")
            }
        }
        
        self.doSomething?()
    }
    
    // Point2.
    func doEverything2() {
        self.doSomething = { [weak self] in
            guard let self = self else { return }
            self.didSomething = true
            print("did somthing")
            
            self.doSomethingElse = {
                // 내부 클로저에서 외부 클로저의(strong & non-optional) override self를 사용할 경우 순환 참조가 발생
                self.didSomethingElse = true
                print("did somthing Else")
            }
        }
        
        self.doSomething?()
    }
    
    // Point3. Point2에서 문제가 되었던 점을 우회?할 수 있음, 하지만 코드 가독성은 떨어짐
    func doEverything3() {
        self.doSomething = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.didSomething = true
            print("did somthing")
            
            strongSelf.doSomethingElse = {
                self?.didSomethingElse = true // <- 내부 클로저에서 외부 클로저의 weak self를 재사용함
                print("did somthing Else")
            }
        }
        
        self.doSomething?()
    }
    
    // Point4.
    func doEverything4() {
        self.doSomething = {
            print("did somthing")
            let newSomthingElse = { [weak self] in // 이미 외부 클로저에서 self가 강한 참조이기 때문에 순환 참조가 발생.
                self?.didSomethingElse = true
                print("new did somthing Else")
            }
            newSomthingElse()
        }
        
        self.doSomething?()
    }
}
