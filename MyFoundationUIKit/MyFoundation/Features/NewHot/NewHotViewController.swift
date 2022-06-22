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
        }
    }
    
    private func bindDataSource() {
        monthDataSource.enumerated().forEach { index, dataSource in
            let calendarView = NewHotCalendarView().then {
                $0.tag = index + 100
                $0.monthLabel.text = dataSource
                $0.dayLabel.text = dayDataSource[index]
            }
            calendarStackView.addArrangedSubview(calendarView)
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
        
        //print(offsetY, ":" , row * 200)
        //if offsetY >= row * 200 {
        print(row)
            if let view = calendarStackView.viewWithTag(Int(row) + 100) as? NewHotCalendarView {
                view.monthLabel.snp.remakeConstraints {
                    $0.top.equalTo(superView.snp.top)
                    $0.leading.trailing.equalToSuperview()
                }
            }
        //}
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

class NewHotCalendarView: UIView {
    
    lazy var wrapperView = UIView().then {
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(wrapperView)
        wrapperView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 60, height: 200))
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
    
    //func updateConstraints(item: ConstraintItem) {
    //    wrapperView.snp.remakeConstraints {
    //        $0.top.equalTo(item)
    //        $0.leading.bottom.equalToSuperview()
    //        $0.size.equalTo(CGSize(width: 60, height: 200))
    //    }
    //}
}

//class NewHotViewController: UIBaseViewController {
//    private let disposeBag = DisposeBag()
//
//    lazy var tableView = UITableView(frame: .zero).then {
//        $0.delegate = self
//        $0.dataSource = self
//        $0.backgroundColor = .white
//        $0.separatorStyle = .none
//        $0.rowHeight = UITableView.automaticDimension
//        $0.showsVerticalScrollIndicator = false
//        $0.showsHorizontalScrollIndicator = false
//        $0.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifier)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setNavigationTitle(title: "New&Hot")
//        setupLayout()
//        bindRx()
//    }
//
//    private func setupLayout() {
//        addSubview(tableView)
//        tableView.snp.makeConstraints {
//            $0.directionalEdges.equalToSuperview()
//        }
//    }
//
//    private func bindRx() {
//        tableView.rx.didScroll.withUnretained(self)
//            .map { $0.0.tableView.contentOffset }
//            .subscribe(onNext: { [weak self] offset in
//                guard let `self` = self else { return }
//                //print(offset.y)
//                let row = offset.y / 200 <= 0 ? 0 : offset.y / 200
//                print("int row:", Int(row), "ceil row", Int(ceil(row)))
//                if Int(row) < Int(ceil(row)) {
//                    let cell = self.tableView.cellForRow(at: IndexPath(row: Int(row), section: 0)) as! CalendarTableViewCell
//                    cell.calendarWrapperView.frame.origin.y = 0
//                }
//
//
//
//
//
//
//                //let cell = self.tableView.cellForRow(at: IndexPath(row: Int(row), section: 0)) as! CalendarTableViewCell
//                //cell.calendarWrapperView.frame = CGRect(x: 10, y: 88, width: 60, height: 200)
//            }).disposed(by: disposeBag)
//    }
//}
//
//extension NewHotViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 30
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as! CalendarTableViewCell
//        cell.monthLabel.text = "7월"
//        cell.dayLabel.text = "15"
//        return cell
//    }
//}
//
//class CalendarTableViewCell: UITableViewCell {
//    static let identifier = String(describing: CalendarTableViewCell.self)
//
//    lazy var calendarWrapperView = UIView().then {
//        $0.backgroundColor = .white
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    lazy var monthLabel = UILabel().then {
//        $0.font = .notoSans(size: 15)
//        $0.textColor = UIColor.systemGray2
//    }
//
//    lazy var dayLabel = UILabel().then {
//        $0.font = .notoSans(size: 22, style: .bold)
//        $0.textColor = UIColor.black
//    }
//
//    private lazy var contentWrapperView = UIView().then {
//        $0.backgroundColor = .purple
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupLayout()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupLayout() {
//        addSubview(calendarWrapperView)
//        calendarWrapperView.snp.makeConstraints {
//            $0.top.bottom.equalToSuperview()
//            $0.leading.equalToSuperview().offset(10)
//            $0.size.equalTo(CGSize(width: 60, height: 200))
//        }
//
//        calendarWrapperView.addSubview(monthLabel)
//        monthLabel.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.trailing.equalToSuperview()
//        }
//
//        calendarWrapperView.addSubview(dayLabel)
//        dayLabel.snp.makeConstraints {
//            $0.top.equalTo(monthLabel.snp.bottom)
//            $0.leading.trailing.equalToSuperview()
//        }
//
//        addSubview(contentWrapperView)
//        contentWrapperView.snp.makeConstraints {
//            $0.top.trailing.bottom.equalToSuperview()
//            $0.leading.equalTo(calendarWrapperView.snp.trailing)
//        }
//    }
//}
