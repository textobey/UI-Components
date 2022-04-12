//
//  AlertActionCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/08.
//

import UIKit

class AlertActionCell: UICollectionViewCell {
    static let identifier = String(describing: AlertActionCell.self)
    
    lazy var button = UIButton().then {
        $0.setTitle("Button", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
