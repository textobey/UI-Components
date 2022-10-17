//
//  InfinitePagingCollectionViewCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/17.
//

import UIKit

class InfinitePagingCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: InfinitePagingCollectionViewCell.self)
    
    lazy var banner = UIImageView().then {
        $0.backgroundColor = .systemGray2
    }
    
    lazy var number = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .notoSans(size: 22, style: .bold)
        $0.textColor = .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(banner)
        banner.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        addSubview(number)
        number.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
