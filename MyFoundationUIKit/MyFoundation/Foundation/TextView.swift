//
//  TextView.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/29.
//

import UIKit
import RxSwift
import RxCocoa

class TextView: UIView {
    private let disposeBag = DisposeBag()
    /// TextView 생성에 필요한 모델입니다.
    private let model: TextFieldInitComponent
    
    lazy var baseView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8901960784, blue: 0.9019607843, alpha: 0.3)
        $0.layer.borderColor = model.borderColor
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var textView = UITextView().then {
        $0.delegate = self
        $0.text = model.placeHolder
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)
        $0.backgroundColor = .clear
        $0.font = model.textFont
        $0.textAlignment = .left
        $0.contentInset = .zero
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var maxLengthIndicator = UILabel().then {
        $0.text = "\(model.maxLength ?? 0)자 이내"
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        $0.textAlignment = .right
        $0.font = .notoSans(size: 12, style: .regular)
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
        print("> TextView Deinit.")
    }
    
    private func setupLayout() {
        addSubview(baseView)
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(model.textViewHeight!)
        }
        baseView.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
        baseView.addSubview(maxLengthIndicator)
        maxLengthIndicator.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    private func bindView() {
        model.endEditingWithView?.tapGesture()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.model.endEditingWithView?.endEditing(true)
            }).disposed(by: disposeBag)
    }
}

extension TextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        DispatchQueue.main.async {
            // 제한된 글자수보다 더 입력을 시도할때, DispatchQueue를 이용하여 mainThread에서
            // textView.text.removeLast()의 동작 수행을 처리하게 지정한다.
            if textView.text.count > self.model.maxLength! {
                textView.text.removeLast()
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4) {
            textView.text = nil
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        baseView.layer.borderWidth = 1
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            textView.text = model.placeHolder
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
        baseView.layer.borderWidth = 0
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // textView의 text가 바뀐 range를 계산해서
        guard let rangeOfTextToReplace = Range(range, in: textView.text) else { return false }
        // 바뀐 text 내용을 가져옴
        let substringToReplace = textView.text[rangeOfTextToReplace]
        // 현재길이 = textView.text.count - 바뀐 text 내용.count + 입력된 text
        let currentLength = textView.text.count - substringToReplace.count + text.count
        if currentLength > model.maxLength ?? 0 + 1 {
            // (maxLength + 1)을 초과하여 입력하지 못함
            return false
        }
        return true
    }
}
