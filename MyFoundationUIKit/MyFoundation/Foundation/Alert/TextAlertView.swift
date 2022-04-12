//
//  TextAlertView.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/08.
//

import UIKit
import SnapKit

class TextAlertView: UIView {
    let textLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = UIFont.notoSans(size: 16, style: .regular)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-36)
            $0.height.greaterThanOrEqualTo(46)
        }
    }
}
