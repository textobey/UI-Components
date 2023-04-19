//
//  UIView+Rx.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    /// UIView는 하나의 CALayer를 소유(+ Delegate)하고, 터치 핸들링 기능을 가지고 있음.
    ///
    /// Autolayout에 의해 UIView의 layoutSubviews() 메서드에서 레이아웃 제약 조건을 이용해,
    /// 하위 뷰들의 크기가 계산되고 UIView의 layer의 크기가 변경되면서 CALayer의 layoutSublayers() 메서드가 호출됨.
    ///
    var layoutSublayers: Observable<()> {
        self.methodInvoked(#selector(UIView.layoutSublayers(of:)))
            .observe(on: MainScheduler.asyncInstance)
            .map { _ in Void() }
    }
}
