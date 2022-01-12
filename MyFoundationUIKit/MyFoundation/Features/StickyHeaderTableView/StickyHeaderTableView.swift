//
//  StickyHeaderTableView.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/12.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class StickyHeaderTableViewController: UIBaseViewController {
    
    lazy var headerView = StickyHeaderView()
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.alwaysBounceVertical = true
        $0.register(StickyHeaderTableViewCell.self, forCellReuseIdentifier: StickyHeaderTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "StickyHeaderTableView")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension StickyHeaderTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StickyHeaderTableViewCell.identifier, for: indexPath) as? StickyHeaderTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = "cell\(indexPath.row)"
        return cell
    }
}
