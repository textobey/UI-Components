//
//  AppDelegate.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/05.
//

import UIKit
import SwiftUI
import RxFlow
import RxSwift
import RxCocoa

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let disposeBag = DisposeBag()
    private let coordinator: FlowCoordinator = FlowCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        
        coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) with step=\(step)")
        }).disposed(by: disposeBag)
        
        let appFlow = AppFlow()
        coordinator.coordinate(flow: appFlow, with: AppStepper())
        
        Flows.use(appFlow, when: .created) { root in
            window.rootViewController = root
            window.makeKeyAndVisible()
        }
        
        return true
    }
}

