//
//  TextBox.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/29.
//

import UIKit
import RxSwift

class TextBoxViewController: UIBaseViewController {
    /// TextField
    lazy var textField = TextField(maxLength: 10, placeHolder: "PlaceHolder Text", endEditingWithView: self.view)
    /// TextView == MultiLineTextField
    lazy var textView = TextView(maxLength: 100, placeHolder: "PlaceHolder Text", endEditingWithView: self.view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "TextBox")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(124)
        }
    }
}
