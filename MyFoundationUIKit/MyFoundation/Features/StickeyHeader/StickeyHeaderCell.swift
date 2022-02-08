//
//  StickeyHeaderCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/02/07.
//

import UIKit

class StickeyHeaderCell: UITableViewCell {
    static let identifier = String(describing: StickeyHeaderCell.self)
    
    lazy var cityImage = UIImageView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.backgroundColor = .black.withAlphaComponent(0.1)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var cityName = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(cityImage)
        cityImage.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        addSubview(cityName)
        cityName.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
