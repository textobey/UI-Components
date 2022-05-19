//
//  HalfModalPresentationController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/12.
//

import UIKit
import RxSwift
import RxCocoa

class HalfModalPresentationController: UIPresentationController {
    private let disposeBag = DisposeBag()
    
    private let blurEffectView: UIVisualEffectView
    private(set) var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    private(set) var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    lazy var initOriginYRelay = BehaviorRelay<CGFloat>(value: UIScreen.main.bounds.size.height * 1 / 4)//self.containerView!.frame.height * 181 / 800)
    private(set) lazy var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var initialCGRect: CGRect {
        get {
            return CGRect(
                origin: CGPoint(x: 0, y: initOriginYRelay.value),
                size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * 619 / 800)
            )
        }
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentedViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDismiss))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(tapGestureRecognizer)
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
        
        initOriginYRelay.filter { $0 > 0 }.withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.presentedViewController.view.frame.origin.y = value
            
                //print("presentedViewController.originY: ", presentedViewController.view.frame.origin.y, "newOriginY: ", value)
            //owner.frameOfPresentedViewInContainerView = owner.initialCGRect
        }).disposed(by: disposeBag)
    }
    
    deinit {
        Log.d(String.empty)
        self.removeAllGesture()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return self.initialCGRect
    }
    
    override func presentationTransitionWillBegin() {
        blurEffectView.alpha = 0
        containerView?.addSubview(blurEffectView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0.7
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0
        }, completion: { _ in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        blurEffectView.frame = containerView!.bounds
        presentedView?.clipsToBounds = true
        presentedView?.layer.cornerRadius = 15
        presentedView?.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
}

extension HalfModalPresentationController {
    @objc func dismissController() {
        self.presentedViewController.dismiss(animated: true, completion: {
            self.removeAllGesture()
        })
    }
    
    @objc func panGestureDismiss(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.presentedViewController.view.window)
        
        //print("x: ", touchPoint.x, "y: ", touchPoint.y)
        
        //let velocity = sender.velocity(in: self.presentedViewController.view.window)
        //if abs(velocity.x) > abs(velocity.y) { // ignore left/right
            //velocity.x < 0 ? print("left") :  print("right")
        //    return
        //}
        //else if abs(velocity.y) > abs(velocity.x) {
        //    velocity.y < 0 ? print("up") :  print("down")
        //}
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if abs(touchPoint.x - initialTouchPoint.x) > abs(touchPoint.y - initialTouchPoint.y) {
                return
            }
            //if abs(velocity.x) > abs(velocity.y) { // ignore left/right
            //    return
            //}
                
            if touchPoint.y < initialCGRect.minY {
                returnOriginalPosition()
                return
            }
            //439.49
            //print(initialCGRect.maxY - touchPoint.y)
            let newRect = CGRect(
                x: 0,
                y: touchPoint.y * 0.8,
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
            y: self.initialCGRect.minY,//self.containerView!.frame.height * 181 / 800,
            width: self.presentedViewController.view.frame.width,
            height: self.presentedViewController.view.frame.height
        )
        guard self.presentedViewController.view.frame != newRect else { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.presentedViewController.view.frame = newRect
        })
    }
    
    private func removeAllGesture() {
        [presentedViewController.view, presentingViewController.view, blurEffectView].forEach {
            $0?.gestureRecognizers?.removeAll()
        }
    }
}
