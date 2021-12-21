//
//  HeaderStackViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/20.
//

import UIKit

struct HeaderStackModel {
    static let dummyData: [HeaderStackStandard] = [
        HeaderStackStandard(section: "Season", component: ["Spring", "Summer", "Fall", "Winter"]),
        HeaderStackStandard(section: "Game", component: ["LOL", "PUBG", "BattleField", "LostArk"]),
        HeaderStackStandard(section: "Programming", component: ["Swift", "Java", "Kotlin", "C"]),
        HeaderStackStandard(section: "Count", component: ["1", "2", "3", "4"]),
        HeaderStackStandard(section: "Food", component: ["Pasta", "Pizza", "Kimchi"]),
    ]
    
    struct HeaderStackStandard {
        let section: String
        let component: [String]
    }
}

class HeaderStackViewController: UIBaseViewController {
    
    lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.alwaysBounceVertical = true
        $0.showsHorizontalScrollIndicator = false
    }
    lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    lazy var headerStackView = HeaderStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "HeaderStack")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.size.width)
        }
        containerView.addSubview(headerStackView)
        headerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
