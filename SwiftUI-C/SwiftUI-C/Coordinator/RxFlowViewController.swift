//
//  RxFlowViewController.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/05.
//

import UIKit
import RxFlow
import RxCocoa

class RxFlowViewController: UIViewController, Stepper {
    let steps = PublishRelay<Step>()
    var contentViewController = UIViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
