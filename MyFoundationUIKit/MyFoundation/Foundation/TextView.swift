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
    
    /// 입력 가능한 최대 글자수
    private let maxLength: Int
    /// Text Font
    private let textViewFont: UIFont
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
    
    private lazy var textView = UITextView().then {
        $0.delegate = self
        $0.text = placeHolder
        $0.textColor = .lightGray
        $0.backgroundColor = .clear
        $0.font = textViewFont
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(maxLength: Int,
         textViewFont: UIFont? = .notoSans(size: 16, style: .regular),
         placeHolder: String,
         placeHolderFont: UIFont? = .notoSans(size: 16, style: .regular),
         endEditingWithView: UIView?) {
        self.maxLength = maxLength
        self.textViewFont = textViewFont ?? .notoSans(size: 16, style: .regular)
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
        baseView.addSubview(textView)
        textView.snp.makeConstraints {
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

extension TextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        DispatchQueue.main.async { [weak self] in
            // 제한된 글자수보다 더 입력을 시도할때, DispatchQueue를 이용하여 mainThread에서
            // textView.text.removeLast()의 동작 수행을 Serial하게 지정한다.
            if textView.text.count > self?.maxLength ?? 0 {
                textView.text.removeLast()
            }
            //self?.parent.text = textView.text
        }
        //if textView.markedTextRange == nil {
        //    parent.text = textView.text ?? String()
        //}
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // textView의 text가 바뀐 range를 계산해서
        guard let rangeOfTextToReplace = Range(range, in: textView.text) else { return false }
        // 바뀐 text 내용을 가져옴
        let substringToReplace = textView.text[rangeOfTextToReplace]
        // 현재길이 = textView.text.count - 바뀐 text 내용.count + 입력된 text
        let currentLength = textView.text.count - substringToReplace.count + text.count
        if currentLength > maxLength + 1 {
            // (maxLength + 1)을 초과하여 입력하지 못함
            return false
        }
        return true
    }
}
