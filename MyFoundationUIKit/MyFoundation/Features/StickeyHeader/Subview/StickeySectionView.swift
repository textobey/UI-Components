//
//  StickeySectionView.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/02/11.
//

import UIKit

class StickeySectionView: UIView {
    lazy var wrapperView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "City Of Korea\n한국의 도시"
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .notoSans(size: 16, style: .bold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(wrapperView)
        wrapperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        wrapperView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
