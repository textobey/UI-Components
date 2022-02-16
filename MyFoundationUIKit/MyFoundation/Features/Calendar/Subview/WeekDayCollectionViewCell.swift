//
//  WeekDayCollectionViewCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/02/16.
//

import UIKit
import SnapKit

class WeekDayCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: WeekDayCollectionViewCell.self)
    
    lazy var dayLabel = UILabel().then {
        $0.text = "1"
        $0.textColor = .black
        $0.font = .notoSans(size: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
