//
//  MultipleTopTabBar2ViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/02/14.
//

import UIKit
import Parchment

class MultipleTopTabBar2ViewController: UIBaseViewController {
    
    lazy var viewControllers = [
        MultipleTopTabBarContentViewController(title: "TAB1"),
        MultipleTopTabBarContentViewController(title: "TAB2"),
        MultipleTopTabBarContentViewController(title: "TAB3"),
        MultipleTopTabBarContentViewController(title: "TAB4"),
        MultipleTopTabBarContentViewController(title: "TAB5"),
        MultipleTopTabBarContentViewController(title: "TAB6"),
        MultipleTopTabBarContentViewController(title: "TAB7"),
        MultipleTopTabBarContentViewController(title: "TAB8"),
    ]
    
    lazy var pagingViewController = PagingViewController(
        viewControllers: viewControllers
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "MultipleTopTabBar2")
        setupLayout()
        configPageView()
    }
    
    private func setupLayout() {
        addChild(pagingViewController)
        addSubview(pagingViewController.view)
        
        pagingViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pagingViewController.didMove(toParent: self)
    }
    
    private func configPageView() {
        pagingViewController.delegate = self
        pagingViewController.collectionView.bounces = true
        //다양한 방법으로 menuItemSize를 정할수있음, 정하지 않을 경우는 Auto로 지정됨?
        //pagingViewController.menuItemSize = .sizeToFit(minWidth: 44, height: 44)
        pagingViewController.indicatorColor = UIColor.black
        
        // indicator에 대한 너비/높이 설정, inset도 설정가능
        //pagingViewController.indicatorOptions = .visible(height: 2, zIndex: Int.max, spacing: .zero, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        //pagingViewController.borderOptions = .visible(height: 0, zIndex: Int.max, insets: .zero)
        pagingViewController.textColor = UIColor.systemGray3
        pagingViewController.selectedTextColor = UIColor.black
        pagingViewController.font = UIFont.systemFont(ofSize: 14)
        pagingViewController.selectedFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
}

extension MultipleTopTabBar2ViewController: PagingViewControllerDelegate {
    func pagingViewController(_ pagingViewController: PagingViewController, didSelectItem pagingItem: PagingItem) {
    }

    func pagingViewController(_ pagingViewController: PagingViewController,
                              didScrollToItem pagingItem: PagingItem,
                              startingViewController: UIViewController?,
                              destinationViewController: UIViewController,
                              transitionSuccessful: Bool) {
    }
}
