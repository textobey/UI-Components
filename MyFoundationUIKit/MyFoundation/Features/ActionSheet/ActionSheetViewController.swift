//
//  ActionSheetViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/02.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa


class ActionSheetViewController: UIBaseViewController {
    private let disposeBag = DisposeBag()
    
    lazy var showActionSheetBtn = UIButton().then {
        $0.setTitle("Show actionsheet", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindRx()
    }
    
    deinit {
        print("> ActionSheetViewController Deinit.")
    }
    
    private func setupLayout() {
        addSubview(showActionSheetBtn)
        showActionSheetBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bindRx() {
        showActionSheetBtn.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                ActionSheet()
                    .addView(view: TestActionSheetView())
                    .show(superview: owner.view)
            }).disposed(by: disposeBag)
    }
}
