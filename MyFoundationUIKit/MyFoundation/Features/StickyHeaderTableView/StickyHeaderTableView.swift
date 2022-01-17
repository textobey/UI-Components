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
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension StickyHeaderTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StickyHeaderTableViewCell.identifier, for: indexPath) as? StickyHeaderTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = "cell\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: .zero)
        } else {
            let headerView = UIView()
            headerView.backgroundColor = .red
            headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
            
            let titleLabel = UILabel()
            titleLabel.textColor = .white
            titleLabel.text = "Section1 헤더 뷰"
            titleLabel.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
            headerView.addSubview(titleLabel)
            
            return headerView
        }
    }
}

extension StickyHeaderTableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset: CGFloat = 200 - 44
        
        if scrollView.contentOffset.y > offset {
            scrollView.contentInset = UIEdgeInsets(top: (navigationController?.navigationBar.frame.height)!, left: 0, bottom: 0, right: 0)
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    /*func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if headerView.frame.height > 150 {
            headerView.snp.updateConstraints {
                $0.height.equalTo(150)
            }
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if headerView.frame.height > 150 {
            headerView.snp.updateConstraints {
                $0.height.equalTo(150)
            }
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }*/
}
