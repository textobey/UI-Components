//
//  MultipleTopTabBar.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa

class MultipleTopTabBar: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let backButton = UIButton().then {
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var navigationBar = UINavigationBar().then {
        let item = UINavigationItem()
        $0.setBackgroundImage(UIImage(), for: .default)
        $0.shadowImage = UIImage()
        $0.isTranslucent = true
        $0.backgroundColor = .white
        $0.tintColor = .clear
        item.leftBarButtonItems = [UIBarButtonItem(customView: backButton)]
        item.title = "MultipleTopTabBar"
        $0.items = [item]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindRx()
    }
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    private func bindRx() {
        backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}
