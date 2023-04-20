//
//  CarouselLayout.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/04.
//

import UIKit

class CarouselLayout: UICollectionViewFlowLayout {
    public var sideItemScale: CGFloat = 0.5
    public var sideItemAlpha: CGFloat = 0.5
    public var spacing: CGFloat = 10
    
    public var isPagingEnabled: Bool = false
    
    private var isSetup: Bool = false
    
    override func prepare() {
        super.prepare()
        if !isSetup {
            setupLayout()
            isSetup = true
        }
    }
    
    private func setupLayout() {
        guard let collectionView = self.collectionView else { return }
        
        let collectionViewSize = collectionView.bounds.size
        
        let xInset = (collectionViewSize.width - self.itemSize.width) / 2
        let yInset = (collectionViewSize.height - self.itemSize.height) / 2
        
        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let itemWidth = self.itemSize.width
        
        // ?
        let scaledItemOffset = (itemWidth - (itemWidth * (self.sideItemScale + (1 - self.sideItemScale) / 2))) / 2
        self.minimumLineSpacing = spacing - scaledItemOffset
        
        self.scrollDirection = .horizontal
    }
    
    // true로 반환하여, 사용자가 스크롤 시 prepare()를 통해 레이아웃 업데이트가 가능하게 끔 합니다.
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // layoutAttributesForElements(in: )는 모든 셀과 뷰에 대한 레이아웃 속성을 UICollectionViewLayoutAttributes 배열로 반환
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        return attributes.map({ self.transformLayoutAttributes(attributes: $0) })
    }
    
    // 각 셀의 레이아웃 속성 변화를 담당할 메서드
    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else {return attributes}
        
        let collectionCenter = collectionView.frame.size.width / 2
        let contentOffset = collectionView.contentOffset.x
        let center = attributes.center.y - contentOffset
        
        // maxDistance는 아이템 중앙과 아이템 중앙 사이의 거리를 의미하는 고정 값
        let maxDistance = 2 * (self.itemSize.width + self.minimumLineSpacing)
        // distance는 maxDistance와 collectionCenter - center의 절대 값
        let distance = min(abs(collectionCenter - center), maxDistance)
        
        // 비율을 구하기 위해서 maxDistance와 distance를 사용
        // 아래 공식이 0이면 비율은 1, distance가 maxDistance이면 비율은 0, maxDistance는 고정값
        let ratio = (maxDistance - distance) / maxDistance
        
        // 위의 값들을 기반으로 하여, 거리에 따른 비율을 계산하여 그 비율을 가지고서 alpha와 scale 값을 조정하는 공식
        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        
        attributes.alpha = alpha
        
        // collectionView 중앙을 기준으로 각 아이템들의 offset이 maxDistance + 1 보다 클 경우 투명도값을 0으로 처리(1은 약간의 오차보정)
        if abs(collectionCenter - center) > maxDistance + 1 {
            attributes.alpha = 0
        }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let dist = attributes.frame.midX - visibleRect.midX
        var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        transform = CATransform3DTranslate(transform, 0, 0, -abs(dist/1000))
        attributes.transform3D = transform
        
        return attributes
    }
    
    // 페이징 기능이 없지만, 스크롤이 중지 되는 지점을 지정하는 메서드
    // proposedContentOffset: 스크롤이 자연스럽게 중지 되는 값(CGPoint는 visible content의 좌측위 모서리를 가르킴)
    // velocity: 스크롤 속도(CGPoints / sec)
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            let lastestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            return lastestOffset
        }
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2
        
        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
