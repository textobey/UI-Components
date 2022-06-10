//
//  TodayViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/06/07.
//

import UIKit

class TodayViewController: UIBaseViewController {
    
    var selectedCell: TodayTableViewCell?
    
    var statusBarShouldBeHidden = false
    //we need to set `View controller-based status bar appearance = YES` in info.plist.
    //so we can be able to hide statusBar.
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    lazy var headerView: TodayTableHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: kScreenW, height: 96)
        let view = TodayTableHeaderView(frame: frame)
        //view.iconButtonClosure = { [weak self] in
        //    guard let StrongSelf = self else { return }
        //    StrongSelf.presentUserTableViewController()
        //}
        return view
    }()
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(TodayTableViewCell.self, forCellReuseIdentifier: TodayTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = GlobalConstants.toDayCardRowH
        $0.tableHeaderView = headerView
    }

//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nil, bundle: nil)
//        modalPresentationStyle = .custom
//        transitioningDelegate = self
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "AppStoreClone(Today)")
        setupLayout()
    }

    private func setupLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateStatusBarAndTabbarFrame(visible: Bool) {
        statusBarShouldBeHidden = !visible
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayTableViewCell.identifier, for: indexPath) as! TodayTableViewCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.bgImageView.image = #imageLiteral(resourceName: "cover_4")
        } else {
            cell.bgImageView.image = #imageLiteral(resourceName: "cover_5")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let row = tableView.cellForRow(at: indexPath) as? TodayTableViewCell else { return }
        UIView.animate(withDuration: 0.1) {
            row.bgBackView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let row = tableView.cellForRow(at: indexPath) as? TodayTableViewCell else { return }
        UIView.animate(withDuration: 0.3) {
            row.bgBackView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) as? TodayTableViewCell else { return }
        selectedCell = cell
        
        let detailVC = CardDetailViewController(cell: cell)
        
        detailVC.dismissClosure = { [weak self] in
            guard let StrongSelf = self else { return }
            StrongSelf.updateStatusBarAndTabbarFrame(visible: true)
        }
        
        updateStatusBarAndTabbarFrame(visible: false)
        
        //let viewController = UIViewController()
        //viewController.view.backgroundColor = .purple
        //viewController.modalPresentationStyle = .custom
        //let transition = TodayTransition()
        //viewController.transitioningDelegate = transition
        
        present(detailVC, animated: true, completion: nil)
        
    }
}
