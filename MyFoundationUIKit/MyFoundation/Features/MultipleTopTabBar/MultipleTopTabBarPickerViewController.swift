//
//  MultipleTopTabBar.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa
import Parchment

class MultipleTopTabBarViewController: UIBaseViewController {
    lazy var tempLabel = UILabel().then {
        $0.text = "MultipleTopTabBar"
        $0.textColor = .black
    }
    
    lazy var viewControllers = [MultipleTopTabBarContentViewController(title: "TAB1"), MultipleTopTabBarContentViewController(title: "TAB2")]
    lazy var pagingViewController = PagingViewController(viewControllers: viewControllers)

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "MultipleTopTabBar")
        configPageView()
        setupLayout()
    }
    
    private func setupLayout() {
        addChild(pagingViewController)
        addSubview(pagingViewController.view)
        
        pagingViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pagingViewController.didMove(toParent: self)
    }
    
    func configPageView() {
        pagingViewController.collectionView.bounces = false
        pagingViewController.delegate = self
        pagingViewController.menuItemSize = .fixed(width: UIScreen.main.bounds.size.width / 2, height: 44)
        pagingViewController.menuItemSpacing = 0
        pagingViewController.indicatorColor = UIColor.black
        pagingViewController.indicatorOptions = .visible(height: 2, zIndex: Int.max, spacing: .zero, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        pagingViewController.borderOptions = .visible(height: 0, zIndex: Int.max, insets: .zero)
        pagingViewController.textColor = UIColor.systemGray3
        pagingViewController.selectedTextColor = UIColor.black
        pagingViewController.font = UIFont.systemFont(ofSize: 14)
        pagingViewController.selectedFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
}

extension MultipleTopTabBarViewController: PagingViewControllerDelegate {
    func pagingViewController(_ pagingViewController: PagingViewController, didSelectItem pagingItem: PagingItem) {
    }

    func pagingViewController(_ pagingViewController: PagingViewController,
                              didScrollToItem pagingItem: PagingItem,
                              startingViewController: UIViewController?,
                              destinationViewController: UIViewController,
                              transitionSuccessful: Bool) {
    }
}

class MultipleTopTabBarContentViewController: UIViewController {
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        
    }
}
