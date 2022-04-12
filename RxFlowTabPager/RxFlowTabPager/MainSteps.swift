//
//  MainSteps.swift
//  RxFlowTabPager
//
//  Created by 이서준 on 2022/03/23.
//

import RxFlow

enum MainSteps: Step {
    case none
    case initialization
    case pageTapped(Int)
    case detailPageInteraction
}
