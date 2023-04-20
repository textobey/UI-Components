//
//  Toast.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/20.
//

import UIKit

struct Toast {
    static func show(_ text: String, duration: TimeInterval = Delay.short) {
            ToastView.appearance().font = UIFont.systemFont(ofSize: 13)
        if #available(iOS 11, *) {
            ToastView.appearance().bottomOffsetPortrait = 30 + (UIWindow.keySafeAreaInsets.bottom)
        }
        if ToastCenter.default.currentToast?.text != text {
            Toaster(text: text, duration: duration).show()
        }
    }
}
