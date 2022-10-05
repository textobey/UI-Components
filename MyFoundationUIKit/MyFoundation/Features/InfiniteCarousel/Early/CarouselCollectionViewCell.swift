//
//  CarouselCollectionViewCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/09/28.
//

import UIKit
import SnapKit

class CarouselCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CarouselCollectionViewCell.self)
    
    lazy var wrapperView = UIView().then {
        $0.backgroundColor = .systemGray2
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .notoSans(size: 18, style: .bold)
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
            $0.directionalEdges.equalToSuperview()
            //$0.top.bottom.equalToSuperview()
            //$0.leading.trailing.equalToSuperview().inset(36)
        }
        wrapperView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
