//
//  StandaloneNavigationBarViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StandaloneNavigationBarViewController: UIBaseViewController {
    private let disposeBag = DisposeBag()
    
    lazy var backButton = UIButton().then {
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    }
    
    lazy var standaloneNavigationBar = UINavigationBar().then {
        $0.isTranslucent = false
        $0.backgroundColor = .white
    }
    
    lazy var standaloneNavigationBarItem = UINavigationItem()
    
    lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.alwaysBounceVertical = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    lazy var containerView = UIView().then {
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "StandaloneNavigationBar")
        setupLayout()
        setupStandaloneNavigationBar()
        bindRx()
    }
    
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.size.width)
            $0.height.equalTo(UIScreen.main.bounds.size.height * 2)
        }
    }
    
    private func setupStandaloneNavigationBar() {
        // Configure
        standaloneNavigationBar.setBackgroundImage(UIImage(), for: .default)
        standaloneNavigationBar.shadowImage = UIImage()
        standaloneNavigationBar.isTranslucent = true
        standaloneNavigationBar.tintColor = .clear
        // Constraints
        backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        // Add Item
        standaloneNavigationBarItem.title = "Title"
        standaloneNavigationBarItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        standaloneNavigationBar.items = [standaloneNavigationBarItem]
        
        view.addSubview(standaloneNavigationBar)
        standaloneNavigationBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-44)
        }
    }
    
    private func bindRx() {
        scrollView.rx.didScroll
            //.skip(2) // 1.들어갈 데이터가 있는지 확인 할 때 2.데이터를 넣어줄 때는 skip
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let offsetY = owner.scrollView.contentOffset.y
                //  viewLifeCycel 중 layoutUpdate 시점에 맞춰야, rectForRow로 CGRect를 얻을 수 있음.
                //  nameCell RectY에서 navheight의 여백을 고려하여 계산
                let height = owner.navigationController?.navigationBar.frame.height ?? 0
                owner.navigationBarAnimate(hide: offsetY >= (UIScreen.main.bounds.size.height / 2) - height)
            })
            .disposed(by: disposeBag)
    }

    /// change the originY value to make animation Effect.
    private func navigationBarAnimate(hide: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            guard let naviFrame = self.navigationController?.navigationBar.frame else { return }

            let updateY = naviFrame.origin.y != naviFrame.height ? naviFrame.origin.y : naviFrame.height
            let isNotchDevice: Bool = naviFrame.origin.y != naviFrame.height

            if hide {
                self.standaloneNavigationBar.frame.origin = CGPoint(x: 0, y: isNotchDevice ? updateY - 4 : updateY)
            } else {
                self.standaloneNavigationBar.frame.origin = CGPoint(x: 0, y: isNotchDevice ? -(updateY + 4) : -updateY)
            }
        })
    }
}
