//
//  AppStep.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/05.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

enum AppStep: Step {
    case none
    case list
    case detail(ListModel)
    case popVC
}
