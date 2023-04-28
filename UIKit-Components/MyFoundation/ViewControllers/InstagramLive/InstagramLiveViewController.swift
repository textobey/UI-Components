//
//  InstagramLiveViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2023/04/25.
//

import AVFoundation
import UIKit
import SnapKit

class InstagramLiveViewController: UIBaseViewController {
    
    private let url = URL(string: "https://assets.afcdn.com/video49/20210722/v_645516.m3u8")
    
    private let playerContainerView = UIView().then {
        $0.backgroundColor = .systemBackground
    }
    
    private let playerView = PlayerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "InstagramLive_Clone")
        setupLayout()
        playVideo()
    }
    
    private func setupLayout() {
        addSubview(playerContainerView)
        playerContainerView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        playerContainerView.addSubview(playerView)
        playerView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    private func playVideo() {
        guard let url = self.url else { return }
        playerView.play(with: url)
        // if true: 단말 음소거 상태에서도 오디오 출력 가능
        playerView.configureAudioSession(isActive: true)
    }
}
