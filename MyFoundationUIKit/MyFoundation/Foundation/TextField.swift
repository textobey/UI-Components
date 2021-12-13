//
//  TextField.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/29.
//

import UIKit
import RxSwift
import RxCocoa

struct TextFieldInitComponent {
    var maxLength: Int? = 10
    var textFont: UIFont? = .notoSans(size: 16, style: .regular)
    var placeHolder: String? = "PlaceHolder Text"
    var placeHolderFont: UIFont? = .notoSans(size: 16, style: .regular)
    var borderColor: CGColor? = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    weak var endEditingWithView: UIView?
    /// !Caution. used only textField
    var needClearButton: Bool? = true
    /// !Mandatory property + used only textView
    var textViewHeight: CGFloat? = 184
}

class TextField: UIView {
    private let disposeBag = DisposeBag()
    /// TextField 생성에 필요한 모델입니다.
    private let model: TextFieldInitComponent
    
    lazy var baseView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8901960784, blue: 0.9019607843, alpha: 0.3)
        $0.layer.borderColor = model.borderColor!
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var textField = UITextField().then {
        $0.delegate = self
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.backgroundColor = .clear
        $0.font = model.textFont!
        $0.textAlignment = .left
        let placeHolderAttr = NSAttributedString(string: model.placeHolder!,
                                                 attributes: [.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4),
                                                              .font: model.placeHolderFont!])
        $0.attributedPlaceholder = placeHolderAttr
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var divider = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var clearButton = UIButton().then {
        $0.setImage(UIImage(systemName: "x.circle"), for: .normal)
        $0.isHidden = !model.needClearButton!
    }
    
    init(model: TextFieldInitComponent) {
        self.model = model
        super.init(frame: .zero)
        setupLayout()
        bindView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("> TextField Deinit.")
    }
    
    private func setupLayout() {
        addSubview(baseView)
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        baseView.addSubviews([textField, clearButton, divider])
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().offset(10)
            if model.needClearButton! {
                $0.trailing.equalTo(divider.snp.leading).offset(-4)
            } else {
                $0.trailing.equalToSuperview().offset(-10)
            }
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
        divider.snp.makeConstraints {
            $0.centerY.equalTo(textField)
            $0.width.equalTo(model.needClearButton! ? 1 : 0)
            $0.height.equalTo(model.needClearButton! ? 18 : 0)
            $0.trailing.equalTo(clearButton.snp.leading).offset(-7)
        }
        clearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalTo(textField)
            $0.size.equalTo(model.needClearButton! ? 20 : 0)
        }
    }
    private func bindView() {
        model.endEditingWithView?.tapGesture()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.model.endEditingWithView?.endEditing(true)
            }).disposed(by: disposeBag)
        
        textField.rx.text
            .withUnretained(self)
            .map { $0.0.shouldHideClearButton($0.1?.count ?? 0) }
            .bind(to: clearButton.rx.isHidden, divider.rx.isHidden)
            .disposed(by: disposeBag)
        
        clearButton.rx.tap.withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.textField.text = nil
                owner.clearButton.isHidden = true
                owner.divider.isHidden = true
            }).disposed(by: disposeBag)
            
    }
    private func shouldHideClearButton(_ textCount: Int) -> Bool {
        return textField.isEditing ? false : true
    }
}

extension TextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let rangeOfTextToReplace = Range(range, in: textField.text ?? "") else { return false }
        let substringToReplace = textField.text![rangeOfTextToReplace]
        let currentLength = (textField.text?.count ?? 0) - substringToReplace.count + string.count
        if currentLength > model.maxLength ?? 0 + 1 {
            return false
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let string = textField.text else { return }
        DispatchQueue.main.async {
            if string.count > self.model.maxLength ?? 0 {
                textField.text?.removeLast()
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        baseView.layer.borderWidth = 1
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        baseView.layer.borderWidth = 0
        return true
    }
}
