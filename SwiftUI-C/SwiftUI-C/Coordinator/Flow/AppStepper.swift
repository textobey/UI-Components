//
//  AppStepper.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/05.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    var initialStep: Step {
        return AppStep.list
    }
}
