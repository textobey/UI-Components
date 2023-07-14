//
//  UILabelNewLineViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2023/07/14.
//

import UIKit
import SnapKit

class UILabelNewLineViewController: UIBaseViewController {
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    }

    let labelStackView = UIStackView()
    let textViewStackView = UIStackView()
    
    let hStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
        $0.alignment = .top
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "UILabelNewLineTest")
        setupLayout()
        bindData()
    }
    
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        scrollView.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            //$0.directionalEdges.equalToSuperview().inset(8)
        }
        
        [labelStackView, textViewStackView].forEach {
            $0.axis = .vertical
            $0.spacing = 4
            hStack.addArrangedSubview($0)
        }
    }
    
    private func bindData() {
        let infoFont: UIFont = .italicSystemFont(ofSize: 10.0)
        let testFont: UIFont = .systemFont(ofSize: 12.0)
        
        var testStr: String = "This is some example text to test truncation consistency. At the end of this line, is a pair of newline chars:\n\nA HEADLINE\n\nThe headline was also followed by a pair of newline chars."

        for i in 3...10 {
            
            let infoLabel = UILabel()
            infoLabel.font = infoFont
            infoLabel.text = "UILabel - numLines: \(i)"
            labelStackView.addArrangedSubview(infoLabel)
            
            let v = UILabel()
            v.font = testFont
            v.numberOfLines = i
            v.text = testStr
            v.backgroundColor = .yellow
            v.lineBreakMode = .byTruncatingTail
            labelStackView.addArrangedSubview(v)
            
            labelStackView.setCustomSpacing(16.0, after: v)
            
        }
        
        for i in 3...10 {
            
            let infoLabel = UILabel()
            infoLabel.font = infoFont
            infoLabel.text = "TextViewLabel - numLines: \(i)"
            textViewStackView.addArrangedSubview(infoLabel)
            
            let v = TextViewLabel()
            v.font = testFont
            v.numberOfLines = i
            v.text = testStr
            v.backgroundColor = .cyan
            v.lineBreakMode = .byTruncatingTail
            textViewStackView.addArrangedSubview(v)
            
            textViewStackView.setCustomSpacing(16.0, after: v)
            
        }
    }
}
