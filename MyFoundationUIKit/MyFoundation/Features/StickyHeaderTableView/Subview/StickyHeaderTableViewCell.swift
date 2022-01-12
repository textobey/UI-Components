//
//  StickyHeaderTableViewCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/12.
//

import UIKit

class StickyHeaderTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: StickyHeaderTableViewCell.self)
    
    lazy var titleLabel = UILabel().then {
        $0.text = "cell"
        $0.textColor = .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
