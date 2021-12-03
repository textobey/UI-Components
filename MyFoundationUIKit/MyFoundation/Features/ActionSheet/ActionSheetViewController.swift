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
    
    lazy var button = UIButton().then {
        $0.setTitle("show actionsheet", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindRx()
    }
    
    deinit {
        print("ActionSheetViewController Deinit,")
    }
    
    private func setupLayout() {
        addSubview(button)
        button.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bindRx() {
        button.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                ActionSheet()
                    .addView(view: TestActionSheetView())
                    .show(view: owner.view)
            }).disposed(by: disposeBag)
    }
}

class TestActionSheetView: ActionSheetView {
    lazy var title = UILabel().then {
        $0.text = "Hello. ActionSheetView."
        $0.textColor = .black
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupLayout() {
        addSubview(title)
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
