//
//  CarouselCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/04.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    static let identifier = String(describing: CarouselCell.self)
    
    lazy var customView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupLayout()
        //customView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    private func setupLayout() {
        addSubview(customView)
        customView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
