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

class TestActionSheetView: ActionSheetView {
    private let disposeBag = DisposeBag()
    
    lazy var title = UILabel().then {
        $0.text = "Hello. ActionSheetView."
        $0.textColor = .black
    }
    
    lazy var dismissEventBtn = UIButton().then {
        let origImage = UIImage(systemName: "xmark")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        $0.setImage(tintedImage, for: .normal)
        $0.tintColor = .black
    }
    
    lazy var increaseHeightBtn = UIButton().then {
        $0.setTitle("Increase actionsheet height", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderWidth = 2
        $0.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bindRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("> TestActionSheetView Deinit.")
    }
    
    private func setupLayout() {
        addSubview(title)
        title.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        addSubview(dismissEventBtn)
        dismissEventBtn.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(16)
        }
        addSubview(increaseHeightBtn)
        increaseHeightBtn.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-32)
        }
    }
    
    private func bindRx() {
        dismissEventBtn.rx.tap
            .map { .dismiss }
            .bind(to: action)
            .disposed(by: disposeBag)
        
        increaseHeightBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.increaseHeightBtn.snp.remakeConstraints {
                    $0.top.equalTo(self.dismissEventBtn.snp.bottom).offset(16)
                    $0.centerX.equalToSuperview()
                    $0.height.equalTo(self.increaseHeightBtn.frame.height + 20)
                    $0.bottom.equalToSuperview().offset(-32)
                }
            }).disposed(by: disposeBag)
    }
}
