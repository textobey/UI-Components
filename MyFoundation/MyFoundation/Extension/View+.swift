//
//  View+.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/19.
//

import SwiftUI

/// PreferenceKey protocol을 채택, 준수하여 View의 크기를 구할수있는 변수로 사용할수있음
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
    
    /// View의 CGSize 값을 구합니다.
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            // 구하고자하는 View를 감싸는 GeometryReader를 선언
            GeometryReader { geometryProxy in
                // SwiftUI에서는 각 뷰의 크기를 구하는 것이 함수화 되어 있지 않기 때문에,
                // 투명한 배경을 만들어, 이 투명한 배경의 geometryProxy.size 값을 구한다.
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
            // Preference가 바뀌는것이 감지되면 onChange 탈출 클로저를 이용하여 return
        ).onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
