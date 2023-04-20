//
//  BottomSheetPresentationController.swift
//  MyFoundation
//
//  Created by 이서준 on 2023/04/20.
//

import UIKit
import RxSwift
import RxCocoa

class BottomSheetPresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    
    private let disposeBag = DisposeBag()
    private let action = PublishRelay<BottomSheetBaseView.OutputActionType>()

    private let blurEffectView = UIView().then { $0.backgroundColor = UIColor.black.withAlphaComponent(0.8) }

    private(set) var tapGestureRecognizer = UITapGestureRecognizer()
    private(set) var panGestureRecognizer = UIPanGestureRecognizer()

    private(set) var initialCGRect: CGRect?
    private(set) var initialTouchPoint = CGPoint(x: 0, y: 0)
    
    var isPanGestureEnabled: Bool = true {
        willSet {
            panGestureRecognizer.isEnabled = newValue
        }
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentedViewController)
        configure()
        bindRx()
    }

    deinit {
        self.removeAllGesture()
        Log.d("BottomSheetPresentationController Deinit")
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(
            origin: CGPoint(x: 0, y: UIScreen.main.bounds.size.height * 1 / 4),
            size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * 619 / 800)
        )
    }

    override func presentationTransitionWillBegin() {
        blurEffectView.backgroundColor = UIColor.black.withAlphaComponent(0)
        containerView?.addSubview(blurEffectView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        })
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.backgroundColor = UIColor.black.withAlphaComponent(0)
        }, completion: { _ in
            self.blurEffectView.removeFromSuperview()
        })
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        blurEffectView.frame = containerView!.bounds
        presentedView?.clipsToBounds = true
        presentedView?.layer.cornerRadius = 11
        presentedView?.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }

    private func configure() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDismiss))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.delegate = self
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(tapGestureRecognizer)
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
    }

    private func bindRx() {
        action.subscribe(onNext: { [weak self] event in
            switch event {
            case .updateOriginY(let value):
                if value > 0 && self?.initialCGRect?.origin.y != value {
                    self?.setPresentedViewControllerPosition(contentHeight: value)
                }
            case .dismiss:
                self?.dismissController()
            default:
                return
            }
        }).disposed(by: disposeBag)
    }

    func setupDI(relay: PublishRelay<BottomSheetBaseView.OutputActionType>) {
        relay.bind(to: action).disposed(by: disposeBag)
    }
}

extension BottomSheetPresentationController {
    @objc func dismissController() {
        if self.panGestureRecognizer.state == .began || self.panGestureRecognizer.state == .changed {
            return
        }
        self.presentedViewController.dismiss(animated: true, completion: {
            self.removeAllGesture()
        })
    }

    @objc func panGestureDismiss(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.presentedViewController.view.window)
        guard let initialCGRect = initialCGRect else { return }

        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y < initialCGRect.minY {
                returnOriginalPosition()
                return
            }
            let newRect = CGRect(
                x: 0,
                y: touchPoint.y - 136,
                width: self.presentedViewController.view.frame.width,
                height: self.presentedViewController.view.frame.height
            )
            if newRect.minY < initialCGRect.minY {
                return
            }
            self.presentedViewController.view.frame = newRect
        case .ended, .cancelled:
            touchPoint.y - initialTouchPoint.y > 150 ? dismissController() : returnOriginalPosition()
        default:
            return
        }
    }

    private func returnOriginalPosition() {
        let newRect = CGRect(
            x: 0,
            y: self.initialCGRect!.minY,
            width: self.presentedViewController.view.frame.width,
            height: self.presentedViewController.view.frame.height
        )
        guard self.presentedViewController.view.frame != newRect else { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.presentedViewController.view.frame = newRect
        })
    }

    private func removeAllGesture() {
        [presentedViewController.view, blurEffectView].forEach {
            $0?.gestureRecognizers?.removeAll()
        }
    }

    private func setPresentedViewControllerPosition(contentHeight: CGFloat) {
        let deviceHeight = UIScreen.main.bounds.size.height
        let safeAreaBottomHeight: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        var origin = (deviceHeight * 1 / 4)
        if (deviceHeight - origin) > contentHeight {
            origin = deviceHeight - contentHeight
        }
        if initialCGRect == nil {
            initialCGRect = CGRect(
                origin: CGPoint(x: 0, y: (origin - safeAreaBottomHeight)),
                size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * 619 / 800)
            )
        }
        presentedViewController.view.frame = initialCGRect!
    }
}

extension BottomSheetPresentationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let touchPoint = gestureRecognizer.location(in: self.presentedViewController.view.window)
        return panGestureShouldBegin(with: touchPoint)
    }

    private func panGestureShouldBegin(with touchPoint: CGPoint) -> Bool {
        if let viewController = presentedViewController as? BottomSheetBaseViewController {
            let scrollViewRect = viewController.contentView.convert(viewController.contentView.bounds, to: nil)
            return !scrollViewRect.contains(touchPoint)
        }
        return false
    }
}
