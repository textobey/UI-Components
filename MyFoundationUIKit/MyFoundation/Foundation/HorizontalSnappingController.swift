//
//  HorizontalSnappingController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/13.
//

import UIKit

class HorizontalSnappingController: UICollectionViewController {
    
    private let layout = SnappingLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 0
    }
    
    init() {
        super.init(collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SnappingLayout: UICollectionViewFlowLayout {
    
    // Search in StackOverFlow: "uicollectionview snap to cell when scrolling horizontally"
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if let collectionView = collectionView {
            let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            
            let itemWidth = collectionView.frame.width - 40
            let itemSpace = itemWidth + minimumLineSpacing //+ minimumInteritemSpacing
            var currentItemIdx = round(collectionView.contentOffset.x / itemSpace)
            
            // Skip to the next cell, if there is residual scrolling velocity left.
            // This helps to prevent glitches
            let velocityX = velocity.x
            print(velocityX)
            if velocityX > 0 {
                currentItemIdx += 1
            } else if velocityX < 0 {
                currentItemIdx -= 1
            }
            
            let nearestPageOffset = currentItemIdx * itemSpace
            return CGPoint(x: nearestPageOffset, y: parent.y)
        }
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
}
