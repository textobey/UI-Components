//
//  Picker.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/29.
//

import UIKit
import RxSwift
import RxCocoa

class PickerViewController: UIBaseViewController {
    lazy var pickerModel = PickerViewInitComponent(type: .hour24, componentWidth: [85, 70, 20, 70])
    lazy var pickerView = PickerView(model: pickerModel)

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Picker")
        setupLayout()
    }
    
    deinit {
        Log.d("> PickerViewController Deinit.")
    }
    
    private func setupLayout() {
        addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
