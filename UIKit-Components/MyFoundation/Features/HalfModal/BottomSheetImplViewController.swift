//
//  BottomSheetImplViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2023/04/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BottomSheetImplViewController: UIBaseViewController {
    
    private let disposeBag = DisposeBag()
    
    lazy var button = UIButton().then {
        $0.setTitle("Show BottomSheet", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "BottomSheet")
        setupLayout()
        bindRx()
    }
    
    private func setupLayout() {
        addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindRx() {
        button.rx.tap.withUnretained(self)
            .map { $0.0.presentHalfModal() }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func presentHalfModal() {
        let view = PlayerIntroduceView()
        let viewController = PlayerIntroduceViewController(title: "", contentView: view)
        present(viewController, animated: true)
    }

}
