//
//  StickeyHeaderViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/02/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class StickeyHeaderViewController: UIBaseViewController {
    private let disposeBag = DisposeBag()
    
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
    
    var headerView = StickeyHeaderView()
    
    var sectionView = StickeySectionView()
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.register(StickeyHeaderCell.self, forCellReuseIdentifier: StickeyHeaderCell.identifier)
        headerView.scrollView = $0
        headerView.frame = CGRect(x: 0, y: $0.safeAreaInsets.top, width: view.frame.width, height: 250)
        $0.backgroundView = UIView()
        $0.backgroundView?.addSubview(headerView)
        $0.contentInset = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
        $0.contentOffset = CGPoint(x: 0, y: -250)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "StickeyHeader")
        setupLayout()
        bindRx()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        tableView.contentInset = UIEdgeInsets(top: 250 + tableView.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
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
        
        addSubview(sectionView)
        sectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
        }
    }
    
    private func bindRx() {
        tableView.rx.didScroll
            .skip(1)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let frame = owner.sectionView.frame.minY
                let offset = owner.tableView.contentOffset.y
                owner.setStickeySection(set: offset >= frame)
            }).disposed(by: disposeBag)
    }
    
    private func setStickeySection(set: Bool) {
        if set {
            sectionView.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
            }
            sectionView.layer.zPosition = 1
        } else {
            sectionView.snp.remakeConstraints {
                $0.top.equalTo(headerView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
            sectionView.layer.zPosition = 0
        }
        
    }
}

extension StickeyHeaderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 240 : 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StickeyHeaderCell.identifier, for: indexPath) as? StickeyHeaderCell else { return UITableViewCell() }
        cell.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            options: [.allowUserInteraction, .curveEaseInOut],
            animations: {
            cell.alpha = 1
        })
        cell.needCellExpanding = indexPath.row == 0
        cell.bindView(cityName: contents[indexPath.row], imageUrl: contentImages[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.updatePosition()
    }
}
