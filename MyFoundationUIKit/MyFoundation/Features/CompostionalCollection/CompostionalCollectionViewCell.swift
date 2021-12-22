//
//  CompostionalCollectionViewCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/22.
//

import UIKit

class CompostionalCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CompostionalCollectionViewCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
