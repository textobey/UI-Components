//
//  PopoverPresenter.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/03/29.
//

import UIKit

class PopoverPresenter {
    /// view를 popoverContainerView에 addSubview하여, inView에 표시합니다.(addSubview)
    ///
    /// - Parameters:
    ///   - view: popover로 띄우고자 하는 View
    ///   - from: popover를 띄울 대상 View
    ///   - in: popover를 붙일 부모 View
    static func present(
        _ view: UIView,
        from fromView: UIView,
        in inView: UIView,
        direction: PopoverPresenter.Direction,
        dismissBlock: ((UIView?) -> Void)? = nil,
        highlightBlock: ((UIView?) -> Void)? = nil,
        releaseBlock: ((UIView?) -> Void)? = nil,
        isBackgroundColorDim: Bool = false
    ) {
        // inView에서의 fromView 좌표(CGPoint)
        let convertedPoint = fromView.convert(inView.bounds.origin, to: inView)
        // convertedPoint의 x,y 값과 size로 만들어진 직사각형(CGRect)
        let fromRect = CGRect(origin: convertedPoint, size: fromView.frame.size)
        let viewRect = view.frame
        let x: CGFloat = fromRect.minX
        switch direction {
        case .top:
            view.frame = CGRect(
                x: x,
                y: fromRect.minY + 1 - viewRect.height,
                width: viewRect.width,
                height: viewRect.height
            )
        case .left:
            view.frame = CGRect(
                x: x - viewRect.width,
                y: fromRect.midY - (viewRect.height / 2),
                width: viewRect.width,
                height: viewRect.height
            )
        case .bottom:
            view.frame = CGRect(
                x: x,
                y: fromRect.maxY - 1,
                width: viewRect.width,
                height: viewRect.height
            )
        }
        
        let container = PopoverContainer()
        container.dismissBlock = dismissBlock
        container.pressBlock = highlightBlock
        container.releaseBlock = releaseBlock
        
        if let scrollView = inView as? UIScrollView {
            let offset = scrollView.contentOffset
            view.frame.origin = CGPoint(x: view.frame.minX, y: view.frame.minY - offset.y)
            container.frame = CGRect(origin: .zero, size: scrollView.contentSize)
        } else {
            container.frame = inView.bounds
        }
        
        container.addSubview(view)
        inView.addSubview(container)
        
        view.alpha = 0
        UIView.animate(withDuration: 0.2) {
            view.alpha = 1.0
        }
    }
}

fileprivate class PopoverContainer: UIControl {
    /// PopoverContainerView
    var containerView: UIView?
    /// PopoverView Dismiss 클로저입니다.
    var dismissBlock: ((UIView?) -> Void)?
    /// PopoverView가 눌려진 상태에 대한 클로저입니다.
    var pressBlock: ((UIView?) -> Void)?
    /// PopoverView에 대한 액션이 종료 되었을때에 대한 클로저입니다.
    var releaseBlock: ((UIView?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(handlePress(_:)), for: .touchDown)
        addTarget(self, action: #selector(handleRelease(_:)), for: [.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        if containerView == subview {
            removeFromSuperview()
        }
    }
    
    @objc func handlePress(_ sender: UIControl) {
        pressBlock?(containerView)
    }
    
    @objc func handleRelease(_ sender: UIControl) {
        releaseBlock?(containerView)
    }
    
    @objc func handleTap(_ sender: UIControl) {
        dismissBlock?(containerView)
        dismissBlock = nil
        if let popoverContainerView = containerView as? PopoverContentView {
            popoverContainerView.remove()
        } else {
            removeFromSuperview()
        }
    }
}

extension PopoverPresenter {
    enum Direction {
        case top
        case left
        case bottom
    }
}

protocol PopoverContentView {
    func remove()
}

extension PopoverContentView where Self: UIView {
    /// self의 superview가 popoverContainer인 경우 self를 popoverContainer에서 제거합니다.
    func remove() {
        if let container = superview as? PopoverContainer {
            container.dismissBlock?(self)
            container.dismissBlock = nil
        }
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let `self` = self else { return }
            self.alpha = 0.0
        }, completion: { [weak self] isFinished in
            guard let `self` = self else { return }
            self.alpha = 1.0
            if self.superview != nil {
                self.removeFromSuperview()
            }
        })
    }
}
