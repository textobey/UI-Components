//
//  StickeyHeaderView.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/02/07.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class StickeyHeaderView: UIView {
    private var cachedMinimumSize: CGSize?
    
    /// 헤더 제약 조건에 맞는 최소 크기를 계산하고 캐시합니다. 높은 프레임률을 유지하는것을 원하기 때문에, 많은 비용이 들수있음.
    private var minimumHeight: CGFloat {
        get {
            guard let scrollView = scrollView else { return 0 }
            if let cachedSize = cachedMinimumSize {
                if cachedSize.width == scrollView.frame.width {
                    return cachedSize.height
                }
            }
            // systemLayoutSizeFitting을 이용하여, 헤더의 최소 높이가 얼마여야하는지 계산.
            let minimumSize = systemLayoutSizeFitting(CGSize(width: scrollView.frame.width, height: 0),
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .defaultLow)
            cachedMinimumSize = minimumSize
            return minimumSize.height
        }
    }
    
    weak var scrollView: UIScrollView?
    
    lazy var imageView = UIImageView().then {
        $0.kf.setImage(with: URL(string: "https://imgur.com/t7mO4wR.jpg"))
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "대한민국"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func updatePosition() {
        guard let scrollView = scrollView else { return }

        // 헤더의 제약 조겐아 맞는 최소 크기 계산
        let minimumSize = minimumHeight
        
        // safeAreaInsets.top으로부터 scrollView의 위치 계산
        let referenceOffset = scrollView.safeAreaInsets.top
        let referenceHeight = scrollView.contentInset.top - referenceOffset
        
        // 새 프레임 크기 및 위치 계산
        let offset = referenceHeight + scrollView.contentOffset.y
        let targetHeight = referenceHeight - offset - referenceOffset
        var targetOffset = referenceOffset
        if targetHeight < minimumSize {
            targetOffset += targetHeight - minimumSize
        }
        
        // 헤더의 높이 및 수직 위치 업데이트.
        var headerFrame = frame
        headerFrame.size.height = max(minimumSize, targetHeight)
        headerFrame.origin.y = targetOffset
        
        frame = headerFrame
    }
}
