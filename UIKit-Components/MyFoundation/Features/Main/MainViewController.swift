//
//  MainViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewModel {
    let foundationList: [Screen] = Screen.allCases
}

class MainViewController: UIBaseViewController {
    private let viewModel = MainViewModel()
    
    private let disposeBag = DisposeBag()
    
    lazy var scrollButton = UIButton().then {
        $0.tintColor = .black
        $0.setBackgroundImage(UIImage(systemName: "arrow.down"), for: .normal)
    }
        
    lazy var foundationList = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.rowHeight = 52
        $0.register(MainListCell.self, forCellReuseIdentifier: MainListCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Components", needBackButton: false)
        addNavigationItem()
        setupLayout()
        bindRx()
    }
    
    private func setupLayout() {
        addSubview(foundationList)
        foundationList.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func addNavigationItem() {
        Observable.just(scrollButton)
            .map { UIBarButtonItem(customView: $0) }
            .bind(to: navigationItem.rx.rightBarButtonItem)
            .disposed(by: disposeBag)
    }
    
    private func bindRx() {
        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.foundationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainListCell.identifier, for: indexPath) as? MainListCell else { return UITableViewCell() }
        cell.title.text = viewModel.foundationList[indexPath.row].getTitle()
        //if viewModel.foundationList[indexPath.row].getTitle() == "StickyAlert" {
        //    foundationList.scroll(to: .bottom)
        //}
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = viewModel.foundationList[indexPath.row].getInstance()
        if let vc = viewController as? UIBaseViewController, vc.presentType == .push {
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            navigationController?.present(viewController, animated: true)
        }
    }
}
