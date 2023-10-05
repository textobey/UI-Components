//
//  PickerButtonToolbarView.swift
//  TextoUI
//
//  Created by 이서준 on 2023/08/10.
//

import UIKit

class PickerButtonToolbarView: UIView {
    
    var tapGesture: UITapGestureRecognizer? {
        didSet {
            guard let tapGesture = tapGesture else { return }
            outSideView.addGestureRecognizer(tapGesture)
        }
    }
    
    let outSideView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let toolbarWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        return view
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addTapGesture()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //deinit {
    //    removeGestureRecognizer(tapGesture)
    //}
    
    //private func addTapGesture() {
    //    outSideView.addGestureRecognizer(tapGesture)
    //}
    
    private func setupLayout() {
        addSubview(outSideView)
        outSideView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            outSideView.topAnchor.constraint(equalTo: topAnchor),
            outSideView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outSideView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(toolbarWrapper)
        toolbarWrapper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbarWrapper.topAnchor.constraint(equalTo: outSideView.bottomAnchor),
            toolbarWrapper.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbarWrapper.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbarWrapper.bottomAnchor.constraint(equalTo: bottomAnchor),
            toolbarWrapper.heightAnchor.constraint(equalToConstant: 44)
        ])

        toolbarWrapper.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: toolbarWrapper.trailingAnchor, constant: -24),
            doneButton.centerYAnchor.constraint(equalTo: toolbarWrapper.centerYAnchor)
        ])
    }
}
