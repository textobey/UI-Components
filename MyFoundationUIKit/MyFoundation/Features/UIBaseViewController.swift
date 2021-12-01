//
//  UIBaseViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/01.
//

import UIKit
import RxSwift
import RxCocoa

class UIBaseViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private let backButton = UIButton().then {
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var navigationBar = UINavigationBar().then {
        let item = UINavigationItem()
        $0.setBackgroundImage(UIImage(), for: .default)
        $0.shadowImage = UIImage()
        $0.isTranslucent = true
        $0.backgroundColor = .white
        $0.tintColor = .clear
        item.leftBarButtonItems = [UIBarButtonItem(customView: backButton)]
        item.title = ""
        $0.items = [item]
    }
    
    private lazy var safeView = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
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
        
        view.addSubview(safeView)
        safeView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func bindRx() {
        backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    func setNavigationTitle(title newTitle: String, needBackButton: Bool? = true) {
        navigationBar.topItem?.title = newTitle
        needBackButton == false ? navigationBar.topItem?.leftBarButtonItems = nil : nil
    }
    
    func addSubview(_ view: UIView) {
        safeView.addSubview(view)
    }
}
