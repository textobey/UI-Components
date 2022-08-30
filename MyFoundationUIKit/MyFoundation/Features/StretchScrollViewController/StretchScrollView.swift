//
//  StretchScrollView.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/08/29.
//

import UIKit
import SnapKit
import Kingfisher

class StretchScrollView: UIView {

    lazy var scrollView = UIScrollView().then {
         $0.backgroundColor = .green
         $0.isScrollEnabled = true
         $0.alwaysBounceVertical = true
         $0.showsVerticalScrollIndicator = true
         $0.showsHorizontalScrollIndicator = false
         $0.translatesAutoresizingMaskIntoConstraints = false
    }

    lazy var scrollContainerView = UIView().then {
        // 컨텐츠 모드를 scaleToFill로 하여 영역에 모두 채워지도록함
         $0.contentMode = .scaleToFill
         $0.backgroundColor = .red
    }
    
    lazy var headerImageView = UIImageView().then {
        // 컨텐츠 모드를 scaleAspectFill로 하여 영역에 모두 채워지도록함
         $0.contentMode = .scaleAspectFill
         let url = "https://imgur.com/t7mO4wR.jpg"
         $0.kf.setImage(with: URL(string: url))
    }

    let label = UILabel().then {
         $0.numberOfLines = 0
         $0.textAlignment = .center
         $0.backgroundColor = .white
         $0.text = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        // 포인트
        // 1. label.snp.top을 이미지 높이만큼 띄우고
        // 2. headerImageView.snp.bottom이 label.snp.top을 따라가게 한다.
        // 3. headerImageView.snp.top은 safeArea에 걸어놔서 스크롤이 안됨
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
             $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(scrollContainerView)
        scrollContainerView.snp.makeConstraints {
             $0.top.centerX.equalToSuperview()
             $0.width.equalTo(UIScreen.main.bounds.size.width)
        }
        
        scrollView.addSubview(label)
        label.snp.makeConstraints {
             $0.top.equalToSuperview().offset(300)
             $0.centerX.bottom.equalToSuperview()
             $0.width.equalTo(UIScreen.main.bounds.size.width)
        }
        
        scrollContainerView.addSubview(headerImageView)
        headerImageView.snp.makeConstraints {
             $0.top.equalTo(safeAreaLayoutGuide.snp.top).priority(900)
             $0.leading.trailing.bottom.equalToSuperview()
             $0.bottom.equalTo(label.snp.top)
             //$0.height.lessThanOrEqualTo(300)
        }
    }
}
