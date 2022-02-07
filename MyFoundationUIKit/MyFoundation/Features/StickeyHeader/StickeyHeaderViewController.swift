//
//  StickeyHeaderViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/02/07.
//

import UIKit
import SnapKit
import Kingfisher

class StickeyHeaderViewController: UIBaseViewController {
    private let contents = [
        "Seoul",
        "Daejeon",
        "Daegu",
        "Busan"
    ]
    private let contentImages = [
        "https://imgur.com/Q6Za0ZO.jpg",
        "https://imgur.com/Eqbzusk.jpg",
        "https://imgur.com/SeU2Abo.jpg",
        "https://imgur.com/TBbqYg8.jpg"
    ]
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.rowHeight = 200
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.alwaysBounceVertical = true
        $0.register(StickeyHeaderCell.self, forCellReuseIdentifier: StickeyHeaderCell.identifier)
    }
    
    lazy var headerView = StickeyHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "StickeyHeader")
        setupLayout()
        configureHeaderView()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        tableView.contentInset = UIEdgeInsets(top: 250 + tableView.safeAreaInsets.top,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        headerView.updatePosition()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        headerView.updatePosition()
    }
    
    private func setupLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureHeaderView() {
        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView.scrollView = tableView
        headerView.frame = CGRect(
            x: 0,
            y: tableView.safeAreaInsets.top,
            width: view.frame.width,
            height: 250)

        tableView.backgroundView = UIView()
        tableView.backgroundView?.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(
            top: 250,
            left: 0,
            bottom: 0,
            right: 0)
    }
}

extension StickeyHeaderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StickeyHeaderCell.identifier, for: indexPath) as? StickeyHeaderCell else { return UITableViewCell() }
        cell.cityImage.kf.setImage(with: URL(string: contentImages[indexPath.row]))
        cell.cityName.text = contents[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.updatePosition()
    }
}
