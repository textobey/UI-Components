//
//  ShadowView.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/27.
//

import UIKit

class ShadowView: UIView {
    let model: ShadowComponent

    public struct ShadowComponent {
        var color: UIColor
        var alpha: Float
        var x: CGFloat
        var y: CGFloat
        var blur: CGFloat
        var spread: CGFloat
    }

    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    init(model: ShadowComponent) {
        self.model = model
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupShadow() {
        self.layer.applySketchShadow(
            color: model.color,
            alpha: model.alpha,
            x: model.x,
            y: model.y,
            blur: model.blur,
            spread: model.spread
        )
    }
}
