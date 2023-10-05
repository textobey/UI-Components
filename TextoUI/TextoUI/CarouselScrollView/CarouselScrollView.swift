//
//  CarouselScrollView.swift
//  TextoUI
//
//  Created by 이서준 on 2023/10/05.
//

import UIKit

public final class CarouselScrollView: UIScrollView {
    
    public let needCarousel: Bool
    
    public var didChangePage: ((Int) -> Void)?
    
    public var dataSource: [UIImage] = [] {
        didSet {
            layoutIfNeeded()
            removeAllSubviews()
            configureImageViewsFromDataSource()
        }
    }
    
    public init(needCarousel: Bool = true) {
        self.needCarousel = needCarousel
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        delegate = self
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    private func configureImageViewsFromDataSource() {
        dataSource.enumerated().forEach { index, image in
            let imageView = UIImageView(
                frame: CGRect(
                    x: frame.size.width * CGFloat(index),
                    y: 0,
                    width: frame.size.width,
                    height: frame.size.height
                )
            )

            imageView.image = image
            addSubview(imageView)
        }
        
        contentSize = CGSize(
            width: (frame.size.width * CGFloat(dataSource.count)),
            height: frame.size.height
        )
    }
    
    private func removeAllSubviews() {
        guard !subviews.isEmpty else {
            return
        }
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension CarouselScrollView: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let page = Int(targetContentOffset.pointee.x / frame.width)
        didChangePage?(page)
    }
}
