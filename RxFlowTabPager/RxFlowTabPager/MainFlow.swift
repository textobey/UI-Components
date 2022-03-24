//
//  MainFlow.swift
//  RxFlowTabPager
//
//  Created by 이서준 on 2022/03/23.
//

import RxFlow
import RxSwift
import RxCocoa
import UIKit

class MainFlow: Flow {
    var root: Presentable {
        return rootViewController
    }
    
    private let rootViewController = TabBarController()
    
    private let homeFlow      = HomeFlow()
    private let programFlow   = ProgramFlow()
    private let classFlow     = ClassFlow()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainSteps else { return .none }
        switch step {
        case .initialization:
            return setupMainScreen()
        case .pageTapped(let index):
            print("\(index) Tapped!")
            return .none
        default:
            return .none
        }
    }
}

extension MainFlow {
    private func setupMainScreen() -> FlowContributors {
        /*let flows: [Flow] = [homeFlow, programFlow, classFlow]
        
        Flows.use(flows, when: .created) { [weak self] (roots: [UINavigationController]) in
            guard let `self` = self else { return }
            self.rootViewController.viewControllers = roots
        }
        return .multiple(flowContributors: flows.map { flow -> FlowContributor in
            FlowContributor.contribute(withNextPresentable: flow, withNextStepper: OneStepper(withSingleStep: MainSteps.initialization))
        })*/
        
        Flows.whenReady(
            flow1: homeFlow,
            flow2: programFlow,
            flow3: classFlow
        ) {(
            flow1Root: UINavigationController,
            flow2Root: UINavigationController,
            flow3Root: UINavigationController
        ) in
            self.rootViewController.viewControllers = [flow1Root, flow2Root, flow3Root]
        }
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow, withNextStepper: OneStepper(withSingleStep: MainSteps.initialization)),
            .contribute(withNextPresentable: programFlow, withNextStepper: OneStepper(withSingleStep: MainSteps.initialization)),
            .contribute(withNextPresentable: classFlow, withNextStepper: OneStepper(withSingleStep: MainSteps.initialization))
        ])

        /*
        Flows.use(homeFlow, when: .ready) { [weak self] in
            guard let `self` = self else { return }
            print($0)
            self.rootViewController.viewControllers = [$0]
        }
        return .one(flowContributor: .contribute(withNextPresentable: homeFlow, withNextStepper: OneStepper(withSingleStep: MainSteps.initialization)))
        */
    }
}
