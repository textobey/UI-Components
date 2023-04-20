//
//  PriceUpdatedBannerView.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/31.
//

import UIKit
import SnapKit

class PriceUpdatedBannerView: BaseNotificationBanner {
    let wrapperView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let coinIcon = UIImageView().then {
        $0.tintColor = .yellow
        $0.layer.borderWidth = 1
        $0.image = UIImage(systemName: "centsign.square.fill")
    }
    
    let titleLabel = UILabel().then {
        $0.text = "가격 변동 알림"
        $0.numberOfLines = 0
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.textAlignment = .left
        $0.font = UIFont.notoSans(size: 14, style: .bold)
    }
    
    let descriptionLabel = UILabel().then {
        $0.text = "내가 찜한 상품의 가격이 변동 되었어요.\n변동된 가격을 확인해보세요."
        $0.numberOfLines = 0
        $0.textColor = #colorLiteral(red: 0.4352941176, green: 0.4352941176, blue: 0.4352941176, alpha: 1)
        $0.textAlignment = .left
        $0.font = UIFont.notoSans(size: 14, style: .medium)
    }
    
    override init() {
        super.init()
        spacerView.backgroundColor = .blue
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(wrapperView)
        wrapperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        wrapperView.addSubview(coinIcon)
        coinIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(28)
            $0.height.equalTo(32)
        }
        wrapperView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(coinIcon.snp.trailing).offset(12)
            $0.bottom.equalTo(coinIcon.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        wrapperView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(coinIcon.snp.centerY)
            $0.leading.equalTo(coinIcon.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
        }
    }
}
