//
//  KingfisherTestCollectionViewCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2023/10/17.
//

import UIKit
import SnapKit

class KingfisherTestCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: KingfisherTestCollectionViewCell.self)
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}
