//
//  DropDownSelectionCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/09.
//

import UIKit

class DropDownSelectionCell: UITableViewCell {
    static let identifier = String(describing: MainListCell.self)
    
    lazy var titleLabel = UILabel().then {
        $0.textColor = .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
            } else {
                titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
            }
        }
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
