//
//  BaseNotificationBanner.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/30.
//

import UIKit
import SnapKit

@objcMembers
open class BaseNotificationBanner: UIView {
    
    //private var bannerHeight: CGFloat {
    //    get {
    //        if let customBannerHeight = customBannerHeight {
    //            return customBannerHeight
    //        } else {
    //            return shouldAdjustForNotchFeaturedIphone()
    //        }
    //    }
    //}
    
    /// If true, notification will dismissed when swiped up
    public var dismissOnSwipeUp: Bool = true

    /// Closure that will be executed if the notification banner is tapped
    public var onTap: (() -> Void)?

    /// Closure that will be executed if the notification banner is swiped up
    public var onSwipeUp: (() -> Void)?
    
    /// Notification Banner의 현재 표시 여부
    public var isDisplaying: Bool = false
    
    /// Banner layout이 표시되는 뷰. 해당 뷰 제약조건/프레임 변경X
    var contentView: UIView!
    
    /// Spring Animation의 도움을 줄 뷰
    var spacerView: UIView!
    
    /// Notification Banner 안에 위치할 커스텀뷰
    var customView: UIView?
    
    /// spacerView의 top 또는 bottom의 기본 offset
    var spacerViewDefaultOffset: CGFloat = 10.0
    
    /// NotificationBanner을 표시할 ViewController
    weak var superViewController: UIViewController?
    
    /// 이 값이 0(또는 nil)이 아닌 경우 자동 계산된 높이 대신 이 높이가 사용됩니다.
    var customBannerHeight: CGFloat?
    
    /// 배너 대기열에서 알림 배너가 대기열 앞에 배치되었는지 여부를 확인하는데 사용됩니다.
    var isSuspended: Bool = false
    
    /// NotificationBanner가 표시되는 UIWindow
    private let appWindow: UIWindow? = {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .first { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
                .map { $0 as? UIWindowScene }
                .flatMap { $0?.windows.first } ?? UIApplication.shared.delegate?.window ?? nil
        }
        return UIApplication.shared.delegate?.window ?? nil
    }()
    
    /// 제공된 배너 위치를 기준으로 알림 배너의 시작 및 끝 프레임을 저장하는 객체
    var bannerPositionFrame: BannerPositionFrame!
    
    init() {
        super.init(frame: .zero)
        
        spacerView = UIView()
        spacerView.backgroundColor = .purple
        addSubview(spacerView)
        
        lazy var shadowView: ShadowView = {
            let model = ShadowView.ShadowComponent(color: #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1), alpha: 0.12, x: 0, y: 3, blur: 14, spread: 2)
            let shadowView = ShadowView(model: model)
            shadowView.backgroundColor = #colorLiteral(red: 0.6509803922, green: 0.937254902, blue: 1, alpha: 1)
            shadowView.layer.cornerRadius = 20
            shadowView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
            return shadowView
        }()
        
        contentView = shadowView
        addSubview(contentView)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(on viewController: UIViewController? = nil) {
        superViewController = viewController
        show()
    }
    
    private func show() {
        guard !isDisplaying else {
            return
        }
        
        createBannerConstraints()
        updateBannerPositionFrames()
        
        guard bannerPositionFrame != nil else {
            //remove()
            return
        }
        
        self.frame = bannerPositionFrame.startFrame
        
        if let superViewController = superViewController {
            superViewController.view.addSubview(self)
        } else {
            appWindow?.addSubview(self)
            appWindow?.windowLevel = UIWindow.Level.statusBar + 1
        }
        
        self.isDisplaying = true
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: [.curveLinear, .allowUserInteraction],
            animations: {
                //BannerHapticGenerator.generate(self.haptic)
                self.frame = self.bannerPositionFrame.endFrame
        }) { (completed) in

//            NotificationCenter.default.post(
//                name: BaseNotificationBanner.BannerDidAppear,
//                object: self,
//                userInfo: self.notificationUserInfo
//            )
//
//            self.delegate?.notificationBannerDidAppear(self)
//
//            /* We don't want to add the selector if another banner was queued in front of it
//               before it finished animating or if it is meant to be shown infinitely
//            */
//            if !self.isSuspended && self.autoDismiss {
//                self.perform(
//                    #selector(self.dismiss),
//                    with: nil,
//                    afterDelay: self.duration
//                )
//            }
            
            self.perform(
                #selector(self.dismiss),
                with: nil,
                afterDelay: 2.0
            )
        }
    }
    
    private func createBannerConstraints() {
        spacerView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(-spacerViewDefaultOffset)
            $0.leading.trailing.equalToSuperview()
            updateSpacerViewHeight(make: $0)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(spacerView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func updateSpacerViewHeight(make: ConstraintMaker? = nil) {
        let finalHeight = spacerViewHeight()
        if let make = make {
            make.height.equalTo(finalHeight)
        } else {
            spacerView.snp.updateConstraints {
                $0.height.equalTo(finalHeight)
            }
        }
    }
    
    func spacerViewHeight() -> CGFloat {
        return UIApplication.isNotchFeaturedIPhone()
            && (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation.isPortrait ?? false)
            && (superViewController?.navigationController?.isNavigationBarHidden ?? true) ? 50.0 : 10.0
    }
    
    func updateBannerPositionFrames() {
        guard let window = appWindow else { return }
        bannerPositionFrame = BannerPositionFrame(
            bannerWidth: window.frame.width,
            bannerHeight: 108,
            maxY: maximumYPosition(),
            edgeInsets: .zero
        )
    }
    
    @objc func dismiss(forced: Bool = false) {
        //remove()
        
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(dismiss),
            object: nil
        )
        
        isDisplaying = false
        
        UIView.animate(
            withDuration: forced ? 0.5 / 2 : 0.5,
            animations: {
                self.frame = self.bannerPositionFrame.startFrame
        }) { (completed) in
            self.removeFromSuperview()
            self.appWindow?.windowLevel = UIWindow.Level.normal
        }
    }
    
    private func maximumYPosition() -> CGFloat {
        if let parentViewController = superViewController {
            return parentViewController.view.frame.height
        } else {
            return appWindow?.frame.height ?? 0
        }
    }
    
    internal func shouldAdjustForNotchFeaturedIphone() -> Bool {
        return UIApplication.isNotchFeaturedIPhone()
            && (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation.isPortrait ?? false)
            && (self.superViewController?.navigationController?.isNavigationBarHidden ?? true)
    }
}
