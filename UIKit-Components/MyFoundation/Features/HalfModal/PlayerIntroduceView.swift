//
//  PlayerIntroduceView.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class PlayerIntroduceView: BottomSheetBaseView {
    
    private let disposeBag = DisposeBag()
    
    override var _scrollView: UIScrollView {
        get {
            return scrollView
        }
    }
    
    lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
    }

    lazy var scrollContainerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    lazy var playerImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.kf.setImage(with: URL(string: "https://i.imgur.com/elhgVrw.jpg"))
    }

    lazy var playerName = UILabel().then {
        $0.text = "손흥민\n孫興慜 | Son Heung-min"
        $0.font = .notoSans(size: 22, style: .bold)
        $0.textColor = .black
    }

    lazy var infomationTitleStackView = UIStackView().then {
        //$0.spacing = 15
        $0.axis = .vertical
        $0.alignment = .center
        //$0.distribution = .fill
        $0.addBackground(color: UIColor.white)
    }

    lazy var infomationStackView = UIStackView().then {
        $0.spacing = 15
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.addBackground(color: UIColor.white)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
        bindDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupLayout() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
            $0.height.greaterThanOrEqualTo(scrollView.contentSize.height)
        }
        scrollView.addSubview(scrollContainerView)
        scrollContainerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.size.width)
        }
        scrollContainerView.addSubview(playerImage)
        playerImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(300)
        }
        scrollContainerView.addSubview(playerName)
        playerName.snp.makeConstraints {
            $0.top.equalTo(playerImage.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        /*scrollContainerView.addSubview(infomationTitleStackView)
        infomationTitleStackView.snp.makeConstraints {
            $0.top.equalTo(scrollContainerView.snp.bottom)
            $0.leading.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.size.width * 1 / 3)
        }*/
        scrollContainerView.addSubview(infomationStackView)
        infomationStackView.snp.makeConstraints {
            $0.top.equalTo(playerName.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func bindDataSource() {
        for (index, title) in PlayerDataSources.infomationsTitle.enumerated() {
            let infomationView = UIView()
            
            //let ratioView = UIView()
            let infomationTitleLabel = UILabel().then {
                $0.text = title
                $0.font = .notoSans(size: 16, style: .bold)
                $0.textColor = .black
            }
            
            let infomationLabel = UILabel().then {
                $0.text = PlayerDataSources.infomations[index]
                $0.font = .notoSans(size: 16, style: .regular)
                $0.textColor = .black
            }
            
            infomationView.addSubviews([infomationTitleLabel, infomationLabel])
            infomationTitleLabel.snp.makeConstraints {
                $0.centerY.equalTo(infomationLabel)
                $0.leading.equalToSuperview().offset(12)
            }
            
            infomationLabel.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(16)
                $0.leading.equalTo(infomationTitleLabel.snp.trailing).offset(10)
                $0.trailing.equalToSuperview().offset(-12)
            }
            
            infomationStackView.addArrangedSubview(infomationView)
        }
    }
}

struct PlayerDataSources {
    static let infomationsTitle: [String] = [
        "출생",
        "국적",
        "본관",
        "학력",
        "가족관계",
        "신체",
        "포지션",
        "주발",
        "후원사",
        "등번호",
        "유스클럽",
        "프로클럽",
        "통산득점",
        "통산도움",
        "병역",
        "종교",
        "응원가",
        "에이전트",
        "MBTI",
        "과거 등번호",
    ]
    static let infomations: [String] = [
        "1992년 7월 8일(29세)\n강원도 춘천시 후평동",
        "대한민국",
        "밀양 손씨",
        "가산초등학교(전학)\n부안초등학교(졸업)\n후평중학교(전학)\n육민관중학교(전학)\n동북중학교(전학)\n동북고등학교(중퇴)",
        "아버지 손웅정, 어미니 길은자, 형 손흥윤",
        "183cm, 78kg, 255mm, AB형",
        "윙어, 세컨드 스트라이커",
        "오른발(양발)",
        "Adidas",
        "대한민국, 토트넘 7번",
        "FC 서울[14] (2008)\n함부르크 SV (2008~2010)",
        "함부르크 SV II (2009~2010)\n함부르크 SV (2010~2013)\n바이어 04 레버쿠젠 (2013~2015)\n토트넘 홋스퍼 FC (2015~ )",
        "209골",
        "99도움",
        "예술체육요원",
        "미상",
        "Nice One Sonny, Nice One Son, Lemon Tree",
        "CAA",
        "ESFJ",
        "대한민국 축구 국가대표팀 - 9번, 11번\n함부르크 SV - 40번, 15번\n바이어 04 레버쿠젠 - 7번"
    ]
}
