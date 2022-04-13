//
//  AlertTransition.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/13.
//

import UIKit

class AlertTransition: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertPresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertDismissAnimator()
    }
}

fileprivate class AlertPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: .to)!
        guard let snapshot = toViewController.view.snapshotView(afterScreenUpdates: true) else {
            transitionContext.containerView.addSubview(toViewController.view)
            transitionContext.completeTransition(true)
            return
        }
        transitionContext.containerView.addSubview(snapshot)
        
        let duration = transitionDuration(using: transitionContext)
        snapshot.transform = snapshot.transform.scaledBy(x: 0.01, y: 0.01)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.8,
            options: .curveEaseInOut,
            animations: {
                snapshot.transform = .identity
            }, completion: { _ in
                snapshot.removeFromSuperview()
                transitionContext.containerView.addSubview(toViewController.view)
                transitionContext.completeTransition(true)
            }
        )
    }
}

fileprivate class AlertDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let view = transitionContext.view(forKey: .from)!
        guard let snapshot = view.snapshotView(afterScreenUpdates: true) else {
            view.removeFromSuperview()
            transitionContext.completeTransition(true)
            return
        }
        view.removeFromSuperview()
        transitionContext.containerView.addSubview(snapshot)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                snapshot.transform = snapshot.transform.scaledBy(x: 0.01, y: 0.01)
                snapshot.alpha = 0.0
            }, completion: { _ in
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        )
    }
}
