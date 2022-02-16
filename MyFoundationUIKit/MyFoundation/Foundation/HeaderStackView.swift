//
//  HeaderStackView.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/21.
//

import UIKit

class HeaderStackView: UIView {
    lazy var baseView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var stackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.alignment = .fill
        $0.axis = .vertical
        $0.spacing = 20
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
        baseView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindView() {
        for (_, model) in HeaderStackModel.dummyData.enumerated() {
            stackView.addArrangedSubview(UIView().then {
                let headerTitle = UILabel().then {
                    $0.text = model.section
                    $0.font = .notoSans(size: 17, style: .bold)
                }
                let componentStackView = UIStackView().then {
                    $0.distribution = .equalSpacing
                    $0.alignment = .center
                    $0.alignment = .fill
                    $0.axis = .vertical
                }
                $0.addSubview(headerTitle)
                headerTitle.snp.makeConstraints {
                    $0.top.leading.trailing.equalToSuperview()
                }
                $0.addSubview(componentStackView)
                componentStackView.snp.makeConstraints {
                    $0.top.equalTo(headerTitle.snp.bottom).offset(16)
                    $0.leading.trailing.bottom.equalToSuperview()
                }
                
                model.component.forEach { component in
                    componentStackView.addArrangedSubview(UIView().then {
                        let titleLabel = UILabel().then {
                            $0.text = component
                            $0.textAlignment = .left
                        }
                        $0.addSubview(titleLabel)
                        titleLabel.snp.makeConstraints {
                            $0.top.bottom.equalToSuperview().inset(9)
                            $0.leading.equalToSuperview().offset(16)
                            $0.trailing.equalToSuperview()
                        }
                    })
                }
            })
        }
    }
}
