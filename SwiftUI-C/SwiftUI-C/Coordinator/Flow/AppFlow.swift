//
//  AppFlow.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/05.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

class AppFlow: Flow {
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }()
    
    var root: Presentable {
        return rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .list:
            return navigateToListView()
        case .detail:
            break
        case .popVC:
            break
        case .none:
            return .none
        }
        return .none
    }
    
    private func navigateToListView() -> FlowContributors {
        let viewController = ListViewController()
        viewController.title = "Weather List"
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
}
