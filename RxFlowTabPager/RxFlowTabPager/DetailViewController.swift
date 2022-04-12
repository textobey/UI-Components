//
//  DetailViewController.swift
//  RxFlowTabPager
//
//  Created by 이서준 on 2022/03/25.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

class DetailViewController: UIViewController, Stepper {
    let disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    
    let label: UIButton = {
       let button = UIButton()
        button.setTitle("In Detail", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    deinit {
        print("> DetailViewController Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
//        label.rx.tap
//            .withUnretained(self)
//            .subscribe(onNext: { owner, _ in
//                owner.steps.accept(MainSteps.detailPageInteraction)
//            }).disposed(by: disposeBag)
    }
}
