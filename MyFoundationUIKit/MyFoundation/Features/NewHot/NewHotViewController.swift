//
//  NewHotViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/06/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NewHotViewController: UIBaseViewController {
    
    let disposeBag = DisposeBag()
    
    let monthDataSource: [String] = Array(repeating: "7월", count: 30)
    let dayDataSource: [String] = Array<Int>(0...29).map { String($0) }
    
    lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.alwaysBounceVertical = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    lazy var scrollContainerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var calendarStackView = UIStackView().then {
        $0.spacing = 0
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.addBackground(color: .white)
    }
    
    lazy var contentStackView = UIStackView().then {
        $0.spacing = 0
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillEqually
        $0.addBackground(color: .white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "New&Hot")
        setupLayout()
        bindDataSource()
        bindRx()
    }
    
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        scrollView.addSubview(scrollContainerView)
        scrollContainerView.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.size.width)
        }
        scrollContainerView.addSubview(calendarStackView)
        calendarStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(60)
        }
        scrollContainerView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(calendarStackView.snp.trailing)
            $0.trailing.equalToSuperview()
        }
    }
    
    private func bindDataSource() {
        (0 ..< 30).enumerated().forEach { index, dataSource in
            let calendarView = NewHotCalendarView().then {
                $0.tag = index + 100
                $0.monthLabel.text = monthDataSource[index]
                $0.dayLabel.text = dayDataSource[index]
            }
            let contentview = NewHotContentView().then {
                $0.tag = index + 200
            }
            calendarStackView.addArrangedSubview(calendarView)
            contentStackView.addArrangedSubview(contentview)
        }
    }
    
    private func bindRx() {
        scrollView.rx.contentOffset.withPrevious()
            .subscribe(onNext: { [weak self] before, current in
                before?.y ?? 0 < current.y ? self?.fixCalendarFrame() : self?.releaseCalendarFrame()
            }).disposed(by: disposeBag)
    }

    private func fixCalendarFrame() {
        let offsetY = scrollView.contentOffset.y
        let row = offsetY <= 200 ? 0 : (offsetY / 200)

        if let view = calendarStackView.viewWithTag(Int(row) + 100) as? NewHotCalendarView {
            view.monthLabel.snp.remakeConstraints {
                $0.top.equalTo(superView.snp.top)
                $0.leading.trailing.equalToSuperview()
            }
        }
    }
    
    private func releaseCalendarFrame() {
        let offsetY = scrollView.contentOffset.y
        let row = (offsetY / 200)
        
        if let view = calendarStackView.viewWithTag(Int(row) + 101) as? NewHotCalendarView {
            view.monthLabel.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
            }
        }
    }
}
