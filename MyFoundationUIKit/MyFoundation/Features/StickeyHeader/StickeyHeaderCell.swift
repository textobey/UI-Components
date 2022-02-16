//
//  StickeyHeaderCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/02/07.
//

import UIKit

class StickeyHeaderCell: UITableViewCell {
    static let identifier = String(describing: StickeyHeaderCell.self)
    
    var needCellExpanding: Bool = false {
        didSet {
            setupLayout()
        }
    }
    
    lazy var cityImage = UIImageView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var cityName = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .montserrat(size: 16, style: .bold)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(cityImage)
        cityImage.snp.makeConstraints {
            if needCellExpanding {
                $0.top.equalToSuperview().offset(60)
                $0.bottom.equalToSuperview().offset(-20)
            } else {
                $0.top.bottom.equalToSuperview().inset(20)
            }
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        addSubview(cityName)
        cityName.snp.makeConstraints {
            $0.center.equalTo(cityImage)
        }
    }
    
    func bindView(cityName: String, imageUrl: String) {
        self.cityName.text = cityName
        cityImage.kf.setImage(with: URL(string: imageUrl))
    }
}
