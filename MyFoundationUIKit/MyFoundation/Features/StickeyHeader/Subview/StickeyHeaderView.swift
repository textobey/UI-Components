//
//  StickeyHeaderView.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/02/07.
//

import UIKit
import SnapKit
import Kingfisher

class StickeyHeaderView: UIView {
    
    weak var scrollView: UIScrollView?
    
    lazy var imageView = UIImageView().then {
        // * 비율을 유지하면서 뷰의 사이즈에 맞게 이미지를 꽉 채우는 옵션이다. 그래서 이미지의 어떤 부분은 잘려 보일수있음
        // -> Frame 사이즈가 늘어나거나 줄면, 비율을 유지하기 위해 이미지가 커지거나 작아진다.
        $0.contentMode = .scaleAspectFill
        $0.kf.setImage(with: URL(string: "https://imgur.com/t7mO4wR.jpg"))
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "대한민국"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(imageView)
        }
    }
    
    func updatePosition() {
        guard let scrollView = scrollView else { return }

        // 헤더의 최소 높이
        let minimumSize = 0.0
        
        // 최상단(기준선)으로부터 scrollView의 위치 계산
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
