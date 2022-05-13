//
//  HalfModalPresentationController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/12.
//

import UIKit

class HalfModalPresentationController: UIPresentationController {
    private let blurEffectView: UIVisualEffectView
    private(set) var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    private(set) var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    private(set) lazy var initialTouchPoint: CGPoint = CGPoint(x: 0, y: containerView!.frame.height * 181 / 800)
    
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
    }
    
    deinit {
        self.removeAllGesture()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 181 / 800),
                      size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * 619 / 800))
    }
    
    override func presentationTransitionWillBegin() {
        blurEffectView.alpha = 0
        containerView?.addSubview(blurEffectView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in self.blurEffectView.alpha = 0.7 })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in self.blurEffectView.alpha = 0.7 })
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
        
        if sender.state == .began {
            initialTouchPoint = touchPoint
        } else if sender.state == .changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                let newRect = CGRect(
                    x: 0,
                    y: touchPoint.y - initialTouchPoint.y,
                    width: self.presentedViewController.view.frame.width,
                    height: self.presentedViewController.view.frame.height
                )
                self.presentedViewController.view.frame = newRect
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            if touchPoint.y - initialTouchPoint.y > 200 {
                dismissController()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    let newRect = CGRect(
                        x: 0,
                        y: 0,
                        width: self.presentedViewController.view.frame.width,
                        height: self.presentedViewController.view.frame.height
                    )
                    self.presentedViewController.view.frame = newRect
                })
            }
        }
    }
    
    private func removeAllGesture() {
        [presentedViewController.view, presentingViewController.view, blurEffectView].forEach {
            $0?.gestureRecognizers?.removeAll()
        }
    }
}
