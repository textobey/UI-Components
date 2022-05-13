//
//  GTVideoNode.swift
//  TexturePractice
//
//  Created by 이서준 on 2022/04/29.
//

import UIKit
import Then
import AsyncDisplayKit

class GTVideoNode: ASDisplayNode {
    fileprivate var state: VideoState?
    private let ratio: CGFloat
    private let automaticallyPause: Bool
    private let videoGravity: AVLayerVideoGravity
    private var willCache: Bool = true
    private var playControlNode: ASDisplayNode?
    
    fileprivate lazy var videoNode = ASVideoNode().then {
        $0.shouldAutoplay = false
        $0.shouldAutorepeat = false
        $0.muted = true
    }

    enum VideoState {
        case readyToPlay(URL)
        case play(URL)
        case pause(URL)
    }
    
    required init(
        ratio: CGFloat,
        videoGravity: AVLayerVideoGravity,
        automaticallyPause: Bool = true,
        playControlNode: ASDisplayNode?
    ) {
        self.ratio = ratio
        self.videoGravity = videoGravity
        self.automaticallyPause = automaticallyPause
        self.playControlNode = playControlNode
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    // 상위 레이아웃에서 정의된 constrainedSize(ASSizeRange)를 기반으로 Wrapping된 사이즈를 계산하여 반환함.
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // 레이아웃 요소를 비율에 따라 그려내는 프로퍼티
        return ASRatioLayoutSpec(ratio: ratio, child: videoNode)
    }
    
    func setPlayControlNode(_ node: ASDisplayNode) {
        self.playControlNode = node
    }
    
    func setVideoAsset(_ url: URL, isCache: Bool = true) {
        self.willCache = isCache
        self.state = .readyToPlay(url)
        let asset = AVAsset(url: url)
        asset.loadValuesAsynchronously(forKeys: ["playable"], completionHandler: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                asset.cancelLoading()
                self.videoNode.asset = asset
            })
        })
    }
}

extension GTVideoNode {
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
        self.playVideo()
    }
    
    override func didExitVisibleState() {
        super.didExitVisibleState()
        if automaticallyPause {
            self.pauseVideo()
        }
    }
}

extension GTVideoNode {
    func playVideo(forcePlay: Bool = false) {
        guard let state = self.state, case .readyToPlay(let url) = state else { return }
        self.videoNode.play()
        self.videoNode.playerLayer?.videoGravity = videoGravity
        self.playControlNode?.isHidden = true
        self.state = .play(url)
    }
    
    func replayVideo() {
        guard let state = self.state, case .pause(let url) = state else { return }
        self.state = .readyToPlay(url)
        self.playVideo(forcePlay: true)
    }
    
    func pauseVideo() {
        guard let state = self.state, case .play(let url) = state else { return }
        self.videoNode.pause()
        self.videoNode.asset?.cancelLoading()
        self.playControlNode?.isHidden = false
        if !self.willCache {
            self.videoNode.asset = nil
        }
        self.state = .pause(url)
    }
}
