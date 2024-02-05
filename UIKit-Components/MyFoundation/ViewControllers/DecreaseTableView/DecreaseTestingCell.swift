//
//  DecreaseTestingCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2/5/24.
//

import UIKit
import SnapKit

class DecreaseTestingCell: UITableViewCell {
    static let identifier = String(describing: DecreaseTestingCell.self)
    
    let langLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.font = .notoSans(size: 16, style: .regular)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(langLabel)
        langLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}
