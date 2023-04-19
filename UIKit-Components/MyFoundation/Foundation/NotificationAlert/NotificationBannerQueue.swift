//
//  NotificationBannerQueue.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/30.
//

import UIKit

open class NotificationBannerQueue: NSObject {
    /// notification banner queue에 접근하기 위한 singleton
    public static let `default` = NotificationBannerQueue()

    /// 현재 큐에 배치 되어있는 Notification Banner 배열
    private(set) var banners: [BaseNotificationBanner] = []
    
    /// 동시에 화면에 표시할 Notification Banner 최대치
    private let maxBannersOnScreenSimultaneously: Int = 1
    
    /// 현재 대기열의 Notification Banner Count
    public var numberOfBanners: Int {
        return banners.count
    }
    
    public override init() {
        super.init()
    }
    
    /// notification banner 큐에 배너를 추가합니다.
    func addBanner(_ banner: BaseNotificationBanner) {
        banners.append(banner)
        let bannersCount =  banners.filter { $0.isDisplaying }.count
        if bannersCount < maxBannersOnScreenSimultaneously {
            banner.show(placeOnQueue: false)
        }
    }
    
    /**
        parameter로 전달된 banner를 큐에서 제거
        -parameter banner: 큐에서 제거하고자 하는 notification banner
     */
    func removeBanner(_ banner: BaseNotificationBanner) {
        if let index = banners.firstIndex(of: banner) {
            banners.remove(at: index)
        }
        banners.forEach {
            // 큐에 존재하는 모든 배너 frame 재배치
            $0.updateBannerPositionFrames()
            if $0.isDisplaying {
                $0.animateUpdatedBannerPositionFrames()
            }
        }
    }
    
    /**
        큐에 표시해야 할 다음 notificaiton banner가 있는 경우 표시
        -parameter callback: 배너가 표시된 후 또는 대기열이 비어 있을 때 실행할 클로저
    */
    func showNext(callback: ((_ isEmpty: Bool) -> Void)) {
        if let banner = firstNotDisplayedBanner() {
            banner.show(placeOnQueue: false)
            callback(false)
        }
        else {
            callback(true)
            return
        }
    }
    
    /// isDisplaying 상태값이 아닌 큐의 첫번째 배너
    func firstNotDisplayedBanner() -> BaseNotificationBanner? {
        return banners.filter { !$0.isDisplaying }.first
    }
    
    /// 모든 notification banner 큐에서 제거
    public func removeAll() {
        banners.removeAll()
    }

    /// 강제적으로 모든 notification banner 큐에서 제거하고 dismiss
    public func dismissAllForced() {
        banners.forEach { $0.dismiss(forced: true) }
        banners.removeAll()
    }
}
