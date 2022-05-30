//
//  BannerPositionFrame.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/30.
//

import UIKit

class BannerPositionFrame {
    private(set) var startFrame: CGRect = .zero
    private(set) var endFrame: CGRect = .zero
    
    init(
        bannerWidth: CGFloat,
        bannerHeight: CGFloat,
        maxY: CGFloat,
        finishYOffset: CGFloat = 0,
        edgeInsets: UIEdgeInsets?
    ) {
        self.startFrame = startFrame(
            bannerWidth: bannerWidth,
            bannerHeight: bannerHeight,
            maxY: maxY,
            edgeInsets: edgeInsets
        )
        
        self.endFrame = endFrame(
            bannerWidth: bannerWidth,
            bannerHeight: bannerHeight,
            maxY: maxY,
            finishYOffset: finishYOffset,
            edgeInsets: edgeInsets
        )
    }
    
    private func startFrame(
        bannerWidth: CGFloat,
        bannerHeight: CGFloat,
        maxY: CGFloat,
        edgeInsets: UIEdgeInsets?
    ) -> CGRect {
        let edgeInsets = edgeInsets ?? .zero
        
        return CGRect(
            x: edgeInsets.left,
            y: -bannerHeight,
            width: bannerWidth - edgeInsets.left - edgeInsets.right,
            height: bannerHeight
        )
    }
    
    private func endFrame(
        bannerWidth: CGFloat,
        bannerHeight: CGFloat,
        maxY: CGFloat,
        finishYOffset: CGFloat = 0,
        edgeInsets: UIEdgeInsets?
    ) -> CGRect {
        let edgeInsets = edgeInsets ?? .zero
        
        return CGRect(
            x: edgeInsets.left,
            y: edgeInsets.top + finishYOffset,
            width: startFrame.width,
            height: startFrame.height
        )
    }
}
