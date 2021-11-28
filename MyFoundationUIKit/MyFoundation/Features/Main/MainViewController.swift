//
//  MainViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/25.
//

import UIKit
import Then
import SnapKit

enum Screen {
    case multipleTopTabBar
    //case textView
    //case textField
    func getTitle() -> String {
        switch self {
        case .multipleTopTabBar:
            return "MultipleTopTabBar"
        }
    }
    func getInstance() -> UIViewController {
        switch self {
        case .multipleTopTabBar:
            return MultipleTopTabBar()
        }
    }
}

class MainViewModel {
    let foundationList: [Screen] = [
        .multipleTopTabBar
    ]
}

class MainViewController: UIViewController {
    private let viewModel = MainViewModel()
    
    lazy var navigationBar = UINavigationBar().then {
        let item = UINavigationItem()
        $0.setBackgroundImage(UIImage(), for: .default)
        $0.shadowImage = UIImage()
        $0.isTranslucent = true
        $0.tintColor = .clear
        item.title = "Main"
        $0.items = [item]
    }
        
    lazy var foundationList = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.rowHeight = 42
        $0.register(MainListCell.self, forCellReuseIdentifier: MainListCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        view.addSubview(foundationList)
        foundationList.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.foundationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainListCell.identifier, for: indexPath) as? MainListCell else { return UITableViewCell() }
        cell.title.text = viewModel.foundationList[indexPath.row].getTitle()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = viewModel.foundationList[indexPath.row].getInstance()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
