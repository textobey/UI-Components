//
//  ListViewController.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/07.
//

import UIKit
import SwiftUI
import RxFlow
import RxSwift
import RxCocoa

class ListViewController: RxFlowViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        contentViewController = UIHostingController(rootView: ListView(steps: steps))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
