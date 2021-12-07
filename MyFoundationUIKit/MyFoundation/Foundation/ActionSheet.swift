//
//  ActionSheet.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/02.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

enum ActionSheetEvent {
    case dismiss
}

/// 액션시트에 사용될 BodyView에서 상속해야할 클래스
class ActionSheetView: UIView {
    let action = PublishRelay<ActionSheetEvent>()
}

class ActionSheet {
    private static var current: ActionSheet?
        
    let disposeBag = DisposeBag()
    let alertController: UIAlertController
    
    /// alertController.view.superview의 자체 padding으로 인해 생긴 간격을 없애주기 위한 로직에 이용될 CGFloat.
    private let alertControllerPadding: CGFloat = 8
    /// 물리적 홈버튼이 없는 단말에 존재하는, bottom safeArea의 높이
    private let alertControllerSafeAreaBottomHeight: CGFloat = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.bottom ?? 0

    /// addView(:_) 메서드를 통해 전달된 UIView를 담을 ContainerView.
    let bodyView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9843137255, blue: 0.9921568627, alpha: 1)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    /// safeAreaBottom 영역에 추가될 padding view.
    lazy var bottomView = UIView().then {
        $0.backgroundColor = bodyView.backgroundColor
    }

    init() {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.backgroundColor = .clear
        alertController.pruneNegativeWidthConstraints()

        setupLayout()
        defer { Self.current = self }
    }

    deinit {
        print("ActionSheet Deinit @@")
    }

    private func setupLayout() {
        alertController.view.addSubviews([bottomView, bodyView])

        bottomView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-alertControllerPadding)
            $0.trailing.equalToSuperview().offset(alertControllerPadding)
            $0.bottom.equalToSuperview().offset(alertControllerPadding + alertControllerSafeAreaBottomHeight)
            $0.height.equalTo(alertControllerSafeAreaBottomHeight)
        }
        
        bodyView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(bottomView)
            $0.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    /// acionSheet bodyView 영역에 view를 추가합니다.
    func addView(view: UIView) -> Self {
        bodyView.addSubview(view)
        view.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.bottom.equalToSuperview().offset(-32)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        if let view = view as? ActionSheetView {
            view.action.withUnretained(self)
                .subscribe(onNext: { owner, event in
                    owner.createResult(event)
                }).disposed(by: disposeBag)
        }
        return self
    }
    
    @discardableResult // 전달된 Self가 사용 되지 않아도, warning error 출력하지 않음.
    func show(superview: UIView, completion: (() -> Void)? = nil) -> Self {
        let cancelAction = UIAlertAction(title: "", style: .cancel) { [weak self] _ in
            guard let `self` = self else { return }
            /// alpha화면(영역) 클릭 시, ActionSheet 닫힘.
            self.alertController.dismiss(animated: true, completion: completion)
            Self.current = nil
        }
        alertController.addAction(cancelAction)
        alertController.view.updateConstraints()
        if let parentVC = superview.parentViewController {
            parentVC.present(alertController, animated: true, completion: nil)
        }
        if let view = alertController.view.subviews.first {
            for innerView in view.subviews {
                for findView in innerView.subviews {
                    findView.layer.isHidden = true
                }
            }
        }
        return self
    }
    
    func createResult(_ event: ActionSheetEvent) {
        switch event {
        case .dismiss:
            Self.dismiss()
        }
    }

    static func dismiss(completion: (() -> Void)? = nil) {
        current?.alertController.dismiss(animated: true) {
            completion?()
            current = nil
        }
    }
    
    static func isShowing() -> Bool {
        return (current?.alertController === UIApplication.shared.topViewController)
    }
}
