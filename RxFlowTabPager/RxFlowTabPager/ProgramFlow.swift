//
//  ProgramFlow.swift
//  RxFlowTabPager
//
//  Created by 이서준 on 2022/03/24.
//

import UIKit
import RxFlow
import RxSwift

class ProgramFlow: Flow {
    var root: Presentable {
        return navigationController
    }
    
    let navigationController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainSteps else { return .none }
        switch step {
        case .initialization:
            let viewController = ChildViewController(page: 2)
            navigationController.pushViewController(viewController, animated: true)
            return .one(flowContributor: .contribute(withNext: viewController))
        case .pageTapped(let index):
            print("\(index) Tapped!")
            return .none
        default:
            return .none
        }
    }
}
