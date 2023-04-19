//
//  AlertTestViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/08.
//

import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift

class AlertTestViewController: UIBaseViewController {
    private let disposeBag = DisposeBag()
    
    private(set) var isPresented: Bool = false
    
    var dampingArray: [Double] = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
    var velocityArray: [Int] = []
    
    lazy var pushPopup = UIButton().then {
        $0.setTitle("Show PushAlert", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .notoSans(size: 12, style: .bold)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 4
    }
    
    //lazy var floatsView = FloatsView()
    private lazy var popupView: ShadowView = {
        let model = ShadowView.ShadowComponent(color: #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1), alpha: 0.12, x: 0, y: 3, blur: 14, spread: 2)
        let shadowView = ShadowView(model: model)
        shadowView.backgroundColor = #colorLiteral(red: 0.6509803922, green: 0.937254902, blue: 1, alpha: 1)
        shadowView.layer.cornerRadius = 20
        shadowView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        return shadowView
    }()
    
    lazy var button = UIButton().then {
        $0.setTitle("Show Alert", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .notoSans(size: 12, style: .bold)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 4
    }
    
    lazy var notificationAlert = UIButton().then {
        $0.setTitle("Show notificationAlert", for: .normal)
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
        addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }
        addSubview(notificationAlert)
        notificationAlert.snp.makeConstraints {
            $0.bottom.equalTo(pushPopup.snp.top).offset(-32)
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
        
        notificationAlert.rx.tap
            .withUnretained(self)
            .map { $0.0.showNotificationAlertPopup() }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func showNotificationAlertPopup() {
        //let notiAlert = BaseNotificationBanner()
        let notiAlert = PriceUpdatedBannerView()
        
        notiAlert.onTap = {
            Toast.show("Notification Banner Tapped!")
        }
        
        notiAlert.onSwipeUp = {
            Toast.show("Notification Banner Swiped Up!")
        }
        
        notiAlert.show()
    }
    
    private func showFloatsPopup() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveLinear,
            animations: {
                
                self.popupView.snp.remakeConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-50)
                    if self.isPresented {
                        $0.height.equalTo(0)
                        //$0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-50)
                    } else {
                        $0.height.equalTo(108)
                        //$0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-50)
                    }
                    $0.leading.trailing.equalToSuperview()
                    //$0.height.equalTo(108)
                    
                }
                
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.isPresented.toggle()
                //self.dampingArray.removeFirst()
            }
        )
        /*if !IQKeyboardManager.shared.keyboardShowing {
            if AlertPresenter.shared.alreadyPresenting {
               AlertPresenter.shared.presentingViewController!.view.addSubview(self.popupView)
            } else {
                appearAnimation()
            }
        } else {
            UIApplication.shared.windows.last?.addSubview(self.view)

            // 키보드가 사라질 때, keyWindow에 다시 Toast 추가
            NotificationCenter.default.addObserver(
                forName: UIWindow.keyboardDidHideNotification,
                object: nil,
                queue: nil,
                using: { [weak self] _ in
                    guard let `self` = self else { return }
                    UIWindow.key?.addSubview(self.view)
                }
            )
        }*/
    }
    
    private func appearAnimation() {
        //translate: .init(duration: 0.65, spring: .init(damping: 0.8, initialVelocity: 0))
        UIWindow.key?.layoutIfNeeded()
        UIView.animate(
            withDuration: 0.65,
            delay: 0,
            usingSpringWithDamping: 10,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                UIWindow.key?.addSubview(self.popupView)
                self.popupView.snp.remakeConstraints {
                    $0.leading.trailing.top.equalToSuperview()
                    $0.height.equalTo(108)
                }
                UIWindow.key?.layoutIfNeeded()
            }, completion: { _ in
                //snapshot.removeFromSuperview()
                //transitionContext.containerView.addSubview(toViewController.view)
                //transitionContext.completeTransition(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.disappearAnimation()
                })
            }
        )
    }
    
    private func disappearAnimation() {
        UIWindow.key?.layoutIfNeeded()
        UIView.animate(
            withDuration: 0.65,
            delay: 0,
            usingSpringWithDamping: 10,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.popupView.snp.remakeConstraints {
                    $0.top.leading.trailing.equalToSuperview()
                    $0.height.equalTo(0)
                }
                UIWindow.key?.layoutIfNeeded()
            }, completion: { _ in
                self.popupView.removeFromSuperview()
                self.popupView.snp.removeConstraints()
            }
        )
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
