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
    lazy var textFieldModel = TextFieldInitComponent(maxLength: 50, endEditingWithView: self.view)
    lazy var textField = TextField(model: textFieldModel)
    /// TextView == MultiLineTextField
    lazy var textViewModel = TextFieldInitComponent(maxLength: 100, endEditingWithView: self.view)
    lazy var textView = TextView(model: textViewModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "TextBox")
        setupLayout()
    }
    
    deinit {
        Log.d("> TextFieldViewController Deinit.")
    }
    
    private func setupLayout() {
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
