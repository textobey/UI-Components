//
//  ViewController.swift
//  DependencyInjection
//
//  Created by 이서준 on 2021/09/02.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    let sports: Sports = Sports(basketball: Basketball())
    let company: Model = Model(device: Device())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // common
        print(sports.football.name!)
        // dependency
        print(sports.basketball.name)
        
        // 의존성 주입
        print(company.device.name)
    }
}

// Sports 클래스안에서 Football 인스턴스를 이용하고 있기 때문에, 의존성이 생김
class Sports {
    // commmon injection
    var football: Football = Football(name: "Son")
    
    // 의존성 주입? 외부에서 인스턴스를 초기화하여 클래스 안에 할당해주는것
    // dependency injection
    var basketball: Basketball
    init(basketball: Basketball) {
        self.basketball = basketball
    }
}

class Football {
    var name: String?
    init(name: String) {
        self.name = name
    }
}

class Basketball {
    var name: String = "james"
}

// 의존성 분리 *제어의 역전IOC(Inversion of control)
// "의존성 분리"까지 완료 한것을 "의존성 주입"이라고 한다. 의존성 분리는 의존관계 역전 원칙을 이용한다.
protocol DeviceProtocol {
    var name: String { get set }
}

class Device: DeviceProtocol {
    var name: String = "iPhone"
}

class Model {
    var device: DeviceProtocol
    init(device: DeviceProtocol) {
        self.device = device
    }
}

/*
 IOC Container : 위의 제어권 (즉 프로토콜의 역할)을 담아두는 곳으로써 객체의 의존성를 관리 및 생성합니다.
                 컨테이너라는 한 곳에 모아서 사용합니다.
*/
