//
//  CarouselsViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/06.
//

import UIKit
import RxSwift
import RxCocoa

class CarouselsViewController: UIBaseViewController {
    private let disposeBag = DisposeBag()
    
    lazy var showInfinite = UIButton().then {
        $0.setTitle("NavigateToInfinite", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .notoSans(size: 16, style: .bold)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 12
    }
    
    lazy var showAdvanced = UIButton().then {
        $0.setTitle("NavigateToAdvanced", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .notoSans(size: 16, style: .bold)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 12
    }
    
    lazy var showPassive = UIButton().then {
        $0.setTitle("NavigateToPassive", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .notoSans(size: 16, style: .bold)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 12
    }
    
    lazy var showAppStoreClone = UIButton().then {
        $0.setTitle("NavigateAppStoreClone", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .notoSans(size: 16, style: .bold)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 12
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Carousels")
        setupLayout()
        bindRx()
    }
    
    private func setupLayout() {
        addSubview(showInfinite)
        showInfinite.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 200, height: 30))
        }
        
        addSubview(showAdvanced)
        showAdvanced.snp.makeConstraints {
            $0.bottom.equalTo(showInfinite.snp.top).offset(-30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 200, height: 30))
        }
        
        addSubview(showPassive)
        showPassive.snp.makeConstraints {
            $0.top.equalTo(showInfinite.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 200, height: 30))
        }
        
        addSubview(showAppStoreClone)
        showAppStoreClone.snp.makeConstraints {
            $0.top.equalTo(showPassive.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 200, height: 30))
        }
    }
}

extension CarouselsViewController {
    private func bindRx() {
        showInfinite.rx.tap
            .withUnretained(self)
            .map { $0.0.navigationController?.pushViewController(InfiniteCarouselViewController(), animated: true) }
            .subscribe()
            .disposed(by: disposeBag)
            
        showAdvanced.rx.tap
            .withUnretained(self)
            .map { $0.0.navigationController?.pushViewController(AdvancedCarouselViewController(), animated: true) }
            .subscribe()
            .disposed(by: disposeBag)
        
        showPassive.rx.tap
            .withUnretained(self)
            .map { $0.0.navigationController?.pushViewController(PassiveCarouselViewController(), animated: true) }
            .subscribe()
            .disposed(by: disposeBag)
        
        showAppStoreClone.rx.tap
            .withUnretained(self)
            .map { $0.0.navigationController?.pushViewController(FloViewController(), animated: true) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}
