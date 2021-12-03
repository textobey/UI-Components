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

enum ActionSheetResult {
    case close
    case text(String)
    case any(Any)
}

/// 액션시트에 사용될 BodyView에서 상속해야할 클래스
class ActionSheetView: UIView {
    /// 프록시되어 액션을 전달할 relay
    let action = PublishRelay<String>()
}

class ActionSheet {
    private static var current: ActionSheet?
   
    let disposeBag = DisposeBag()
    let alertController: UIAlertController
    let resultRelay = PublishRelay<ActionSheetResult>()

    /// "alertController.view.superview" 자체 패딩이 있어서 superview와 동일하게 맞추면 화면에 꽉차지 않는다! 꽉채우기 위해 아래 값을 활용한다!
    let alertControllerPadding: CGFloat = 8
    let alertControllerSafeAreaBottomHeight: CGFloat = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.bottom ?? 0

    let bodyView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9843137255, blue: 0.9921568627, alpha: 1)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30  //가이드가 40pt인데, 안맞는거 같아서 비교후에 30으로 설정했습니다.
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    lazy var bottomView = UIView().then {
        $0.backgroundColor = bodyView.backgroundColor
    }

    init() {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.backgroundColor = .clear
        alertController.pruneNegativeWidthConstraints()

        setupLayout()
        Self.current = self
    }

    deinit {
        print("ActionSheet Deinit @@")
    }

    func setupLayout() {
        alertController.view.addSubviews([bodyView, bottomView])
        
        remakeBottomViewConstraints(height: alertControllerSafeAreaBottomHeight)
        bodyView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(bottomView)
            $0.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    func addView(view: UIView) -> Self {
        bodyView.addSubview(view)
        view.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.bottom.equalToSuperview().offset(-32)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        if let view = view as? ActionSheetView {
            view.rx.didSelect.subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.createResult($0)
            }).disposed(by: disposeBag)
        }
        return self
    }
    
    // TODO: 확인 후 필요 없으면 주석 삭제
    /// 탈출클로저를 이용한 액션시트 결과 전달은 아래 completion 주석을 확인
//    func show(view: UIView/*, completion: @escaping (ActionSheetResult) -> Void*/) -> Self {
//        //self.completion = completion
//        let cancelAction = UIAlertAction(title: "", style: .cancel) { [weak self] _ in
//            guard let `self` = self else { return }
//            /// 화면 설계서 정의 : Dim화면(영역) 클릭 시, ActionSheet 닫힘. 변경사항은 저장 하지 않음.
//            self.alertController.dismiss(animated: true, completion: nil)
//            Self.current = nil
//        }
//        alertController.addAction(cancelAction)
//        alertController.view.updateConstraints()
//        if let parentVC = view.parentViewController {
//            parentVC.present(alertController, animated: true, completion: nil)
//        }
//        if let view = alertController.view.subviews.first {
//            for innerView in view.subviews {
//                for findView in innerView.subviews {
//                    findView.layer.isHidden = true
//                }
//            }
//        }
//        return self
//    }
    
    @discardableResult
    func show(view: UIView, completion: (() -> Void)? = nil) -> Self {
        let cancelAction = UIAlertAction(title: "", style: .cancel) { [weak self] _ in
            guard let `self` = self else { return }
            /// 화면 설계서 정의 : Dim화면(영역) 클릭 시, ActionSheet 닫힘. 변경사항은 저장 하지 않음.
            self.alertController.dismiss(animated: true, completion: completion)
            Self.current = nil
        }
        alertController.addAction(cancelAction)
        alertController.view.updateConstraints()
        if let parentVC = view.parentViewController {
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

    func createResult(_ object: Any) {
        var result: ActionSheetResult = .close
        if let text = object as? String {
            result = .text(text)
        } else {
            result = .any(object)
        }
        resultRelay.accept(result)
    }
    
    func bindView(relay: PublishRelay<ActionSheetResult>) {
        resultRelay.bind(to: relay).disposed(by: disposeBag)
    }
    

    static func dismiss(completion: (() -> Void)? = nil) {
        current?.alertController.dismiss(animated: true) {
            completion?()
            current = nil
        }
    }
    
    static func isShowing() -> Bool {
        return false
        //return (current?.alertController === UIApplication.shared.topViewController)
    }
}

extension ActionSheet {
    func remakeBottomViewConstraints(height: CGFloat) {
        bottomView.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(-alertControllerPadding)
            $0.trailing.equalToSuperview().offset(alertControllerPadding)
            $0.bottom.equalToSuperview().offset(alertControllerPadding + alertControllerSafeAreaBottomHeight)
            $0.height.equalTo(height)
        }
    }
    
    /// 액션시트에서 일반 화면으로 이동시, "밑에서부터 위로 열리는 모션" 처리
    func dismissWithBottomUpAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let `self` = self else { return }
            let actionSheetBottomOffset = UIScreen.main.bounds.height - self.bodyView.frame.height
            self.alertController.view.snp.updateConstraints {
                $0.top.equalToSuperview()
            }
            self.remakeBottomViewConstraints(height: actionSheetBottomOffset)
            self.alertController.view.superview?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.alertController.dismiss(animated: false) {
                completion?()
                Self.current = nil
            }
        })
    }
}

extension Reactive where Base: ActionSheetView {
    var didSelect: Observable<String> {
        return base.action.asObservable()
    }
}

//class ActionSheet: UIView {
//    private let disposeBag = DisposeBag()
//
//    lazy var containerView = UIView().then {
//        $0.backgroundColor = .purple
//    }
//
//    lazy var button = UIButton().then {
//        $0.setTitle("Button", for: .normal)
//        $0.setTitleColor(.black, for: .normal)
//    }
//
//    private var isShow: Bool = true
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupLayout()
//        bindRx()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupLayout() {
//        addSubview(containerView)
//        containerView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(300)
//        }
//        addSubview(button)
//        button.snp.makeConstraints {
//            $0.top.trailing.equalToSuperview()
//            $0.size.equalTo(54)
//        }
//    }
//
//    private func bindRx() {
//        button.rx.tap
//            .withUnretained(self)
//            .subscribe(onNext: { owner, _ in
//                owner.animate()
//                owner.isShow.toggle()
//            }).disposed(by: disposeBag)
//    }
//    private func animate() {
//        // These values depends on the positioning of your element
//        let left = CGAffineTransform(translationX: -300, y: 0)
//        let right = CGAffineTransform(translationX: 300, y: 0)
//        let top = CGAffineTransform(translationX: 0, y: -300)
//        let bottom = CGAffineTransform(translationX: 0, y: 0)
//
//        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: { [weak self] in
//              // Add the transformation in this block
//              // self.container is your view that you want to animate
//              //self.container.transform = top
//            guard let `self` = self else { return }
//            self.containerView.transform = self.isShow ? bottom : top
//        }, completion: { [weak self] status in
//            guard let `self` = self else { return }
//            if status, self.isShow {
//                self.removeFromSuperview()
//            }
//        })
//    }
//}

/*
enum ActionSheetResult {
    case close
    case text(String)
    case any(Any)
}

class ActionSheet {
    private static var current: ActionSheet?
    
    private let disposeBag = DisposeBag()
    private let alertController: UIAlertController
    private let resultRelay = PublishRelay<ActionSheetResult>()
    
    private let alertControllerPadding: CGFloat = 8
    private let alertControllerSafeAreaBottomHeight: CGFloat = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.bottom ?? 0
    
    let bodyView = UIView().then {
        $0.backgroundColor =
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30  //가이드가 40pt인데, 안맞는거 같아서 비교후에 30으로 설정했습니다.
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    lazy var bottomView = UIView().then {
        $0.backgroundColor = bodyView.backgroundColor
    }
    
    init() {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.backgroundColor = .clear
        
        setupLayout()
        Self.current = self
    }
    
    deinit {
        print("ActionSheet Deinit @@")
    }
    
    private func setupLayout() {
        alertController.view.addSubviews([bodyView, bottomView])
        
        bodyView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func addView(view: UIView) -> Self {
        bodyView.addSubview(view)
        view.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(32)
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        //if let view = view as? ActionSheetView {
            
        //}
        return self
    }
}
*/
