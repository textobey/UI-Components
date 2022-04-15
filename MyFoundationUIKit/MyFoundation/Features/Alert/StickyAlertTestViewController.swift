//
//  StickyAlertTestViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/14.
//

import UIKit
import RxSwift
import RxCocoa

class StickyAlertTestViewController: UIBaseViewController {
    private let disposeBag = DisposeBag()
    
    lazy var button = UIButton().then {
        $0.setTitle("Show StickyAlert", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "StickyAlert")
        setupLayout()
        bindRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let orientation = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(orientation, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let orientation = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientation, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    private func setupLayout() {
        addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(32)
        }
    }
    
    private func bindRx() {
        button.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let viewController = StickyAlertController(header: StickeyHeaderView(), section: StickeySectionView())
                owner.navigationController?.present(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
}
