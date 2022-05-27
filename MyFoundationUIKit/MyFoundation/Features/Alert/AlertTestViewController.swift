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
        pushPopup.rx.tap
            .withUnretained(self)
            .map { $0.0.showFloatsPopup() }
            .subscribe()
            .disposed(by: disposeBag)
        
        button.rx.tap
            .withUnretained(self)
            .map { $0.0.showAlertPopup() }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func showFloatsPopup() {
        Floats<TextFloatsView>()
            .configure { _, textView in
                textView.titleLabel.text = "관심 상품 가격 변동"
                textView.subtitleLabel.text = "관심 상품의 가격이 내려갔어요."
            }
            .show()
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

class TextFloatsView: UIView {
    let thumbnail = UIImageView().then {
        $0.image = UIImage(systemName: "bookmark.fill")
        $0.tintColor = .yellow
    }
    
    let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.textAlignment = .center
        $0.font = UIFont.notoSans(size: 14, style: .bold)
    }
    
    let subtitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = #colorLiteral(red: 0.4352941176, green: 0.4352941176, blue: 0.4352941176, alpha: 1)
        $0.textAlignment = .center
        $0.font = UIFont.notoSans(size: 14, style: .medium)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(thumbnail)
        thumbnail.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(14)
            $0.height.equalTo(28)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnail.snp.trailing).offset(12)
            $0.bottom.equalTo(thumbnail.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnail.snp.centerY)
            $0.leading.equalTo(thumbnail.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
        }
    }
}
