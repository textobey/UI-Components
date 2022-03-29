//
//  PopoverViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/03/29.
//

import UIKit
import RxSwift
import RxCocoa

class PopoverViewController: UIBaseViewController {
    let disposeBag = DisposeBag()
    
    lazy var popoverView = PopoverView()
    
    lazy var button = UIButton().then {
        $0.setTitle("Show Popover", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .notoSans(size: 18, style: .bold)
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "PopoverView")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //private func bindRx() {
    //    button.rx.tap.withUnretained(self)
    //        .subscribe(onNext: { owner, _ in
    //            PopoverPresenter.present(owner.popoverView, from: owner.view, in: owner.topLevelView, direction: .bottom)
    //        }).disposed(by: disposeBag)
    //}
    
    private var topLevelView: UIView {
        return UIApplication.shared.topViewController!.view
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        popoverView.frame.size = CGSize(width: 100, height: 50)
        popoverView.frame.origin = CGPoint(x: button.frame.origin.x, y: button.frame.origin.y)
        PopoverPresenter.present(popoverView, from: sender, in: topLevelView, direction: .bottom)
    }
}

class PopoverView: UIView, PopoverContentView {
    lazy var label = UILabel().then {
        $0.text = "PopoverView"
        $0.textColor = UIColor.black
        $0.font = .notoSans(size: 20, style: .medium)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
