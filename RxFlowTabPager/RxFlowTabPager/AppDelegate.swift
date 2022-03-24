//
//  AppDelegate.swift
//  RxFlowTabPager
//
//  Created by 이서준 on 2022/03/23.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coordinator = FlowCoordinator()
    let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        let mainFlow = MainFlow()
        coordinator.coordinate(flow: mainFlow, with: MainStepper())
        Flows.use(mainFlow, when: .created) { root in
            window.backgroundColor = UIColor.white
            window.rootViewController = root
            window.makeKeyAndVisible()
        }
        return true
    }
}

