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
    case textBox
    case picker
    case dropDown
    
    func getTitle() -> String {
        switch self {
        case .multipleTopTabBar:
            return "MultipleTopTabBar"
        case .textBox:
            return "TextBox"
        case .picker:
            return "Picker"
        case .dropDown:
            return "DropDown"
        }
    }
    func getInstance() -> UIViewController {
        switch self {
        case .multipleTopTabBar:
            return MultipleTopTabBarViewController()
        case .textBox:
            return TextBoxViewController()
        case .picker:
            return PickerViewController()
        case .dropDown:
            return DropDownViewController()
        }
    }
}

class MainViewModel {
    let foundationList: [Screen] = [
        .multipleTopTabBar,
        .textBox,
        .picker,
        .dropDown
    ]
}

class MainViewController: UIBaseViewController {
    private let viewModel = MainViewModel()
        
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
        setNavigationTitle(title: "Main", needBackButton: false)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(foundationList)
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