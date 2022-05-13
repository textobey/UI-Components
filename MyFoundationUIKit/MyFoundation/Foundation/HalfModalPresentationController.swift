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
    
    private(set) lazy var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0) { //self.containerView!.frame.height * 181 / 800) {
        didSet {
            //Log.d("y value is: \(initialTouchPoint.y)")
        }
    }
    
    private var initialCGRect: CGRect {
        get {
            return CGRect(
                origin: CGPoint(x: 0, y: self.containerView!.frame.height * 181 / 800),
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
    }
    
    deinit {
        self.removeAllGesture()
        Log.d("!")
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return self.initialCGRect
        //return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 181 / 800),
                      //size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * 619 / 800))
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
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y < initialCGRect.minY {
                returnOriginalPosition()
                return
            }
            //print(self.initialCGRect.minY)
            //print(touchPoint.y - initialTouchPoint.y > 0)
            //if touchPoint.y - initialTouchPoint.y > 0 {
                //print("touchPoint", touchPoint.y)
                //print("initialTouchPoint", initialTouchPoint.y)
                //let distanceY = initialTouchPoint.y > touchPoint.y ? initialTouchPoint.y
            
            //let distance = initialCGRect.maxY - touchPoint.y
            //var ratio = 1.0
            //if distance >= 300 {
            //    ratio = 0.7
            //} else if distance >= 200 {
            //    ratio = 0.8
            //} else if distance >= 100 {
            //    ratio = 0.9
            //}
                let newRect = CGRect(
                    x: 0,
                    y: touchPoint.y * 0.8 /*initialTouchPoint.y*/,
                    width: self.presentedViewController.view.frame.width,
                    height: self.presentedViewController.view.frame.height
                )
                //print(newRect.minY * 0.8)
                if newRect.minY < initialCGRect.minY {
                    return
                }
                self.presentedViewController.view.frame = newRect
            //}
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
            //print("return original : \(self.initialCGRect.minY)")
            self.presentedViewController.view.frame = newRect
        })
    }
    
    private func removeAllGesture() {
        [presentedViewController.view, presentingViewController.view, blurEffectView].forEach {
            $0?.gestureRecognizers?.removeAll()
        }
    }
}
