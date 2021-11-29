//
//  TextField.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/29.
//

import UIKit
import RxSwift
import RxCocoa

/*
struct TextFieldConfig {
    let maxLength: Int?
    let textFieldFont: UIFont?
    let textFieldAlignment: NSTextAlignment?
    let placeHolder: String
    let placeHolderFont: UIFont?
    let placeHolderColor: UIColor?
    let placeHolderLeftPadding: CGFloat?
    let placeHolderRightPadding: CGFloat?
    let needTextFieldAddButton: Bool?
    let needTextFieldClearButton: Bool?
    let needPreBackGroundColor: Bool?
    weak var endEditingWithView: UIView?
}
*/

class TextField: UIView {
    private let disposeBag = DisposeBag()
    
    /// 입력 가능한 최대 글자수
    private let maxLength: Int
    /// Text Font
    private let textFieldFont: UIFont
    /// PlaceHolder 내용
    private let placeHolder: String
    /// PlaceHolder Font
    private let placeHolderFont: UIFont
    
    ///  프로퍼티로 전달된 뷰에 탭(포커스아웃)을 통해 텍스트뷰 편집을 종료할수있습니다.
    private weak var endEditingWithView: UIView?
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        $0.layer.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var textField = UITextField().then {
        $0.delegate = self
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        $0.textColor = .black
        $0.backgroundColor = .clear
        $0.font = textFieldFont
        $0.textAlignment = .left
        let placeHolderAttr = NSAttributedString(string: placeHolder,
                                                 attributes: [.foregroundColor: UIColor.lightGray,
                                                              .font: placeHolderFont])
        $0.attributedPlaceholder = placeHolderAttr
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(maxLength: Int,
         textFieldFont: UIFont? = .notoSans(size: 16, style: .regular),
         placeHolder: String,
         placeHolderFont: UIFont? = .notoSans(size: 16, style: .regular),
         endEditingWithView: UIView?) {
        self.maxLength = maxLength
        self.textFieldFont = textFieldFont ?? .notoSans(size: 16, style: .regular)
        self.placeHolder = placeHolder
        self.placeHolderFont = placeHolderFont ?? .notoSans(size: 16, style: .regular)
        self.endEditingWithView = endEditingWithView
        super.init(frame: .zero)
        setupLayout()
        bindRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(baseView)
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        baseView.addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-12)
        }
    }
    private func bindRx() {
        endEditingWithView?.tapGesture().subscribe(onNext: { [weak self] _ in
            self?.endEditingWithView?.endEditing(true)
        }).disposed(by: disposeBag)
    }
}

extension TextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let rangeOfTextToReplace = Range(range, in: textField.text ?? "") else { return false }
        let substringToReplace = textField.text![rangeOfTextToReplace]
        let currentLength = (textField.text?.count ?? 0) - substringToReplace.count + string.count
        if currentLength > maxLength + 1 {
            return false
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let string = textField.text else { return }
        DispatchQueue.main.async { [weak self] in
            if string.count > self?.maxLength ?? 0 {
                textField.text?.removeLast()
            }
            //self?.currentText = textField.text!
        }
    }
}
