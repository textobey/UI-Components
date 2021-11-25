//
//  ButtonStyle+.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/19.
//

import SwiftUI

// How to remove highlight on tap of Button with SwiftUI?
// Answer:
struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
