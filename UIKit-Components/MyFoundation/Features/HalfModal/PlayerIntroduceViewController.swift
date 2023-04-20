//
//  PlayerIntroduceViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2023/04/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class PlayerIntroduceViewController: BottomSheetBaseViewController {

    private let disposeBag = DisposeBag()
    
    private let dismissTrigger = PublishRelay<Void>()
    
    let titleWrapperView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    lazy var titleLabel = UILabel().then {
        $0.text = contentTitle
        $0.textColor = .black
        $0.backgroundColor = .white
        $0.textAlignment = .left
    }

    lazy var close = UIButton().then {
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.rx.tap.bind(to: dismissTrigger).disposed(by: disposeBag)
    }
    
    override init(title: String?, contentView: BottomSheetBaseView) {
        super.init(title: title, contentView: contentView)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
        bindRx()
    }
    
    private func setupLayout() {
        view.addSubview(titleWrapperView)
        titleWrapperView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(58)
        }
        titleWrapperView.addSubview(close)
        close.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(21)
        }
        titleWrapperView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(close)
            $0.leading.equalTo(close.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-24)
        }

        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(titleWrapperView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func bindRx() {
        contentView.outputRelay.withUnretained(self)
            .map { $0.0.sendDelegate?.sendPartialSheetViewControllerAction(action: $0.1) }
            .subscribe()
            .disposed(by: disposeBag)
        
        dismissTrigger
            .map { [weak self] _ in self?.dismiss(animated: true) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension PlayerIntroduceViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let panGesturePresentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
        panGesturePresentationController.isPanGestureEnabled = false
        panGesturePresentationController.setupDI(relay: contentView.outputRelay)
        return panGesturePresentationController
    }
}
