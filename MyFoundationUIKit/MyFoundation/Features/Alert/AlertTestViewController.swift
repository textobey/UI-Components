//
//  AlertTestViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/08.
//

import UIKit
import RxSwift
import RxCocoa

class AlertTestViewController: UIBaseViewController {
    private let disposeBag = DisposeBag()
    
    lazy var button = UIButton().then {
        $0.setTitle("Show Alert", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Alert")
        setupLayout()
        bindRx()
    }
    
    private func setupLayout() {
        addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(32)
        }
    }
    
    private func bindRx() {
        button.rx.tap
            .withUnretained(self)
            .map { $0.0.showAlertPopup() }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func showAlertPopup() {
        Alert<TextAlertView>(title: "TestAlertPopup")
            .configure { _, textView in
                textView.textLabel.text = "Configure"
            }
            .add(action: "Confirm") { _ in
                print("Selected Confirm")
            }
            .add(action: "Cancel") { _ in
                print("Selected Cancel")
            }
            .show()
    }
}
