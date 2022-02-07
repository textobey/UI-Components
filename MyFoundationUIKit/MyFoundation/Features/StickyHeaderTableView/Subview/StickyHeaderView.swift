////
////  StickyHeaderView.swift
////  MyFoundation
////
////  Created by 이서준 on 2022/01/12.
////
//
//import UIKit
//import Then
//import SnapKit
//
//class StickyHeaderView: UIView {
//
//    lazy var imageView = UIImageView().then {
//        $0.image = UIImage(named: "IMG3264")
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupLayout()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupLayout() {
//        addSubview(imageView)
//        imageView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
//}
//
