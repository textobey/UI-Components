//
//  PickerButton.swift
//  TextoUI
//
//  Created by 이서준 on 2023/08/10.
//

import UIKit

public final class PickerButton: UIButton {
    
    public override var inputView: UIView? {
        return pickerView
    }
    
    public override var inputAccessoryView: UIView? {
        return toolbar
    }
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    fileprivate let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .systemBackground
        return pickerView
    }()
    
    fileprivate lazy var toolbar: PickerButtonToolbarView = {
        let toolbar = PickerButtonToolbarView()
        toolbar.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.size.height - pickerView.frame.height
        )
        return toolbar
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        pickerView.delegate = self
        pickerView.dataSource = self
        addGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addGestures() {
        addTarget(self, action: #selector(presentPickerView), for: .touchUpInside)
        
        toolbar.doneButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        toolbar.tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapClose))
    }
    
    public var dataSource = [String]() {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
}

extension PickerButton {
    @objc func presentPickerView() {
        DispatchQueue.main.async {
            self.titleLabel?.textColor = .systemBlue
        }
        UIView.animate(withDuration: 0.3) {
            self.becomeFirstResponder()
        }
    }
    
    @objc func didTapDone() {
        print("didTapDone")
    }
    
    @objc func didTapClose() {
        print("didTapClose")
    }
}

extension PickerButton: UIPickerViewDelegate, UIPickerViewDataSource {
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int ) -> NSAttributedString? {
        //FIXED: iOS16 버전에서 초기 1회 UIPickerView BackgroundColor에 DarkMode Theme가 적용되지 않는 문제
        return NSAttributedString(string: dataSource[row], attributes: [.foregroundColor: UIColor.black])
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
}

