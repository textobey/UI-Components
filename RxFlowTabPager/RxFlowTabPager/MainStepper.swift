//
//  MainStepper.swift
//  RxFlowTabPager
//
//  Created by 이서준 on 2022/03/23.
//

import RxFlow
import RxSwift
import RxCocoa

class MainStepper: Stepper {
    let steps = PublishRelay<Step>()
    
    var initialStep: Step {
        return MainSteps.initialization
    }
    
    init() {
        defer { }
    }
}
