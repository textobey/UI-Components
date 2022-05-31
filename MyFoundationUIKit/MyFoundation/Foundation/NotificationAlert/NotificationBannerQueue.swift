//
//  NotificationBannerQueue.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/30.
//

import UIKit

open class NotificationBannerQueue: NSObject {
    
    /// The default instance of the NotificationBannerQueue
    public static let `default` = NotificationBannerQueue()

    /// 현재 대기열에 배치 되어있는 Notification Banner 배열
    private(set) var banners: [BaseNotificationBanner] = []
    
    /// 현재 대기열에 배치 되어있는 Notification Banner 배열
    private(set) var maxBannersOnScreenSimultaneously: Int = 1
    
    /// 현재 대기열의 Notification Banner Count
    public var numberOfBanners: Int {
        return banners.count
    }
    
    public init(maxBannersOnScreenSimultaneously: Int = 1) {
        self.maxBannersOnScreenSimultaneously = maxBannersOnScreenSimultaneously
    }
    
    /**
        Adds a banner to the queue
        -parameter banner: The notification banner to add to the queue
        -parameter queuePosition: The position to show the notification banner. If the position is .front, the
        banner will be displayed immediately
    */
    func addBanner(_ banner: BaseNotificationBanner) {
        banners.append(banner)
        let bannersCount =  banners.filter { $0.isDisplaying }.count
        if bannersCount < maxBannersOnScreenSimultaneously {
            banner.show(placeOnQueue: false)
        }
    }
    
    /**
        Removes a banner from the queue
        -parameter banner: A notification banner to remove from the queue.
     */
    func removeBanner(_ banner: BaseNotificationBanner) {
        if let index = banners.firstIndex(of: banner) {
            banners.remove(at: index)
        }
        banners.forEach {
            $0.updateBannerPositionFrames()
            if $0.isDisplaying {
                $0.animateUpdatedBannerPositionFrames()
            }
        }
    }
    
    /**
        Shows the next notificaiton banner on the queue if one exists
        -parameter callback: The closure to execute after a banner is shown or when the queue is empty
    */
    func showNext(callback: ((_ isEmpty: Bool) -> Void)) {
        if let banner = firstNotDisplayedBanner() {
            if banner.isSuspended {
                banner.resume()
            } else {
                banner.show(placeOnQueue: false)
            }
            callback(false)
        }
        else {
            callback(true)
            return
        }
    }
    
    func firstNotDisplayedBanner() -> BaseNotificationBanner? {
        return banners.filter { !$0.isDisplaying }.first
    }
    
    /**
        Removes all notification banners from the queue
    */
    public func removeAll() {
        banners.removeAll()
    }

    /**
     Forced dissmiss all notification banners from the queue
     */
    public func dismissAllForced() {
        banners.forEach { $0.dismiss(forced: true) }
        banners.removeAll()
    }
}
