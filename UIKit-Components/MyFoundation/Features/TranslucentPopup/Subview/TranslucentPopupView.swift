//
//  TranslucentPopupView.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/27.
//

import UIKit

class TranslucentPopupView: UIView {
    
    lazy var eventBanner = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 11
        $0.clipsToBounds = true
        $0.setBackgroundImage(UIImage(named: "IMG3264"), for: .normal)
        //$0.setBackgroundImage(UIImage(named: "IMG3264"), for: .highlighted)
        //$0.setBackgroundImage(UIImage(named: "IMG3264"), for: .disabled)
    }
    
    lazy var eventBannerShadow = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 11
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowRadius = 5
        $0.layer.shadowOffset = CGSize(width: 5, height: 5)
        $0.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.layer.masksToBounds = false
    }
    
    lazy var neverLookAgainToday = UIButton().then {
        $0.setTitle("오늘은 그만 보기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.titleLabel?.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var close = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.titleLabel?.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var divider = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews([eventBannerShadow, close, neverLookAgainToday, divider])
        eventBannerShadow.addSubview(eventBanner)
        eventBannerShadow.snp.makeConstraints {
            $0.width.equalTo(325)
            $0.height.equalTo(397)
            $0.center.equalToSuperview()
        }
        
        eventBanner.snp.makeConstraints {
            $0.edges.equalTo(eventBannerShadow)
        }
        
        neverLookAgainToday.snp.makeConstraints {
            $0.top.equalTo(eventBanner.snp.bottom).offset(13)
            $0.leading.equalTo(eventBanner.snp.leading).offset(17)
            $0.trailing.equalTo(divider.snp.leading).offset(-5)
            $0.height.equalTo(14)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(eventBanner.snp.bottom).offset(13)
            $0.centerX.equalTo(eventBanner)
            $0.width.equalTo(1)
            $0.height.equalTo(13)
        }
        
        close.snp.makeConstraints {
            $0.top.equalTo(eventBanner.snp.bottom).offset(13)
            $0.leading.equalTo(divider.snp.trailing).offset(5)
            $0.trailing.equalTo(eventBanner.snp.trailing).offset(-17)
            $0.height.equalTo(14)
        }
    }
}
