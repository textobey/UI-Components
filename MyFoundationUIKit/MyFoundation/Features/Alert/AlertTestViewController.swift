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
    
    lazy var pushPopup = UIButton().then {
        $0.setTitle("Show PushAlert", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .notoSans(size: 12, style: .bold)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 4
    }
    
    lazy var button = UIButton().then {
        $0.setTitle("Show Alert", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .notoSans(size: 12, style: .bold)
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
        addSubview(pushPopup)
        pushPopup.snp.makeConstraints {
            $0.bottom.equalTo(superView.snp.centerY).offset(-16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(32)
        }
        addSubview(button)
        button.snp.makeConstraints {
            $0.top.equalTo(superView.snp.centerY).offset(16)
            $0.centerX.equalToSuperview()
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
            .add(action: "취소") { _ in
                print("선택- 취소")
            }
            .add(action: "확인") { _ in
                print("선택- 확인")
            }
            .show()
    }
}
