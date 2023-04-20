//
//  NewHotContentView.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/06/22.
//

import UIKit
import SnapKit
import Kingfisher

class NewHotContentView: UIView {
    
    lazy var contentWrapperView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var contentImage = UIImageView().then {
        $0.kf.setImage(with: URL(string: NewBooks.dummyData.image))
        $0.contentMode = .scaleToFill
    }
    
    lazy var contentName = UILabel().then {
        $0.text = NewBooks.dummyData.title
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 22, weight: .bold)
    }
    
    lazy var contentDescription = UILabel().then {
        $0.text = NewBooks.dummyData.subtitle
        $0.textColor = .lightGray
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
        $0.font = .systemFont(ofSize: 18, weight: .regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(contentWrapperView)
        contentWrapperView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        contentWrapperView.addSubview(contentImage)
        contentImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        contentWrapperView.addSubview(contentName)
        contentName.snp.makeConstraints {
            $0.top.equalTo(contentImage.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        contentWrapperView.addSubview(contentDescription)
        contentDescription.snp.makeConstraints {
            $0.top.equalTo(contentName.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}

struct NewBooks {
    static let dummyData: NewBooks = NewBooks(
        title: "Microsoft Excel Step by Step",
        subtitle: "Office 2021 and Microsoft 365",
        isbn13: "9780137564279",
        price: "$30.62",
        image: "https://itbook.store/img/books/9780137564279.png",
        url: "https://itbook.store/books/9780137564279"
    )

    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}
