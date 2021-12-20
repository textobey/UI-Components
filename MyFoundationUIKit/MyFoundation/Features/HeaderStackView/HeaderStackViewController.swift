//
//  HeaderStackViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/20.
//

import UIKit

struct HeaderStackModel {
    static let dummyData: [HeaderStackStandard] = [
        HeaderStackStandard(section: "Season", component: ["Spring", "Summer", "Fall", "Winter"])
        //HeaderStackStandard(section: "Game", component: ["LOL", "PUBG", "BattleField", "LostArk"])
    ]
    
    struct HeaderStackStandard {
        let section: String
        let component: [String]
    }
}

class HeaderStackViewController: UIViewController {
    
    lazy var headerStackView = HeaderStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(headerStackView)
        headerStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

class HeaderStackView: UIView {
    lazy var baseView = UIView().then {
        $0.backgroundColor = .white
    }
    
    /// free setup ui
    lazy var headerTitle = UILabel().then {
        $0.textColor = .black
    }
    
    lazy var componentStackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.alignment = .fill
        $0.axis = .vertical
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bindView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(baseView)
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        baseView.addSubview(headerTitle)
        headerTitle.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        baseView.addSubview(componentStackView)
        componentStackView.snp.makeConstraints {
            $0.top.equalTo(headerTitle.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindView() {
        for (_, model) in HeaderStackModel.dummyData.enumerated() {
            headerTitle.text = model.section
            model.component.forEach { component in
                componentStackView.addArrangedSubview(UIView().then {
                    let titleLabel = UILabel().then {
                        $0.text = component
                        $0.textAlignment = .left
                    }
                    $0.addSubview(titleLabel)
                    titleLabel.snp.makeConstraints {
                        $0.top.bottom.equalToSuperview().inset(9)
                        $0.leading.trailing.equalToSuperview()
                    }
                })
            }
        }
    }
}
