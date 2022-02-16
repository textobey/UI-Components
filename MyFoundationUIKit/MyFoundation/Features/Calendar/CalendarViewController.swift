//
//  CalendarViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/02/15.
//

import UIKit
import SnapKit

class CalendarViewController: UIBaseViewController {
    private let weekDayDataSource = ["일", "월", "화", "수", "목", "금", "토"]
    
    lazy var calendarHeaderView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .black
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "날짜 선택"
        $0.font = .notoSans(size: 22, style: .bold)
    }
    
    lazy var clearButton = UIButton().then {
        $0.setTitle("초기화", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .notoSans(size: 14)
    }
    
    lazy var weekDayFlowlayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        let cellWidth = UIScreen.main.bounds.size.width / 7
        $0.itemSize = CGSize(width: cellWidth, height: cellWidth)
    }
    
    lazy var weekDayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: weekDayFlowlayout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.backgroundColor = .white
        $0.register(WeekDayCollectionViewCell.self, forCellWithReuseIdentifier: WeekDayCollectionViewCell.identifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Calendar")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(calendarHeaderView)
        calendarHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        calendarHeaderView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(44)
        }
        
        calendarHeaderView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().offset(-26)
        }
        
        calendarHeaderView.addSubview(weekDayCollectionView)
        weekDayCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(UIScreen.main.bounds.size.width / 7)
            $0.bottom.equalToSuperview()
        }
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDayDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekDayCollectionViewCell.identifier, for: indexPath) as? WeekDayCollectionViewCell {
            cell.dayLabel.text = weekDayDataSource[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}
