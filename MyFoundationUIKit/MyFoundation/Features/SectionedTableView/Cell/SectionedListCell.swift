//
//  SectionedListCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/01.
//

import UIKit
import Then
import SnapKit

class SectionedListCell: UITableViewCell {
    static let identifier = String(describing: SectionedListCell.self)
    
    lazy var title = UILabel().then {
        $0.textAlignment = .center
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(title)
        title.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
