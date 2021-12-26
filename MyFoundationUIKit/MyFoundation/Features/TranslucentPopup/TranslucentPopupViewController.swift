//
//  TranslucentPopupViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/26.
//

import UIKit
import RxSwift
import RxCocoa

class TranslucentPopupViewController: UIBaseViewController {
    
    private let disposeBag = DisposeBag()
    
    lazy var showEvent = UIButton().then {
        $0.setTitle("Show TranslucentPopup", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.white, for: .focused)
        $0.setTitleColor(.white, for: .selected)
        $0.backgroundColor = UIColor.systemGray5
        $0.layer.cornerRadius = 9
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "TranslucentPopup")
        setupLayout()
        bindRx()
    }
    
    private func setupLayout() {
        addSubview(showEvent)
        showEvent.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindRx() {
        showEvent.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                
            }).disposed(by: disposeBag)
    }
}
