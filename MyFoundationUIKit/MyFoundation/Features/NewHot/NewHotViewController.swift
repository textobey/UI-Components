//
//  NewHotViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/06/20.
//

import UIKit
import SnapKit

class NewHotViewController: UIBaseViewController {
    
    lazy var calendarTableView = UITableView(frame: .zero).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "New&Hot")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(calendarTableView)
        calendarTableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(60)
        }
    }
}

extension NewHotViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as! CalendarTableViewCell
        cell.monthLabel.text = "7월"
        cell.dayLabel.text = "15"
        return cell
    }
}

class CalendarTableViewCell: UITableViewCell {
    static let identifier = String(describing: CalendarTableViewCell.self)
    
    private lazy var wrapperView = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var monthLabel = UILabel().then {
        $0.font = .notoSans(size: 15)
        $0.textColor = UIColor.systemGray2
    }
    
    lazy var dayLabel = UILabel().then {
        $0.font = .notoSans(size: 22, style: .bold)
        $0.textColor = UIColor.black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(wrapperView)
        wrapperView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        wrapperView.addSubview(monthLabel)
        monthLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        wrapperView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

//struct NewHotDataSource {
//    static let month =
//}
