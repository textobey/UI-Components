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
    }
}

class PlayerView: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            return playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        let layer = layer as! AVPlayerLayer
        // videoGravity는 영상의 비율을 결정해줌
        layer.videoGravity = .resizeAspectFill
        return layer
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        print("Deinit PlayerView")
    }
    
    private var playerItemContext = 0
    
    // Keep the reference and use it to observe the loading status.
    private var playerItem: AVPlayerItem?
    
    private func setupAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        let asset = AVAsset(url: url)

        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                completion?(asset)
            case .failed:
                print(".failed")
            case .cancelled:
                print(".cancelled")
            default:
                print("default")
            }
        }
    }
    
    @available(iOS 15, *)
    func setupAsset_iOS15(with url: URL) async throws -> AVAsset? {
        let asset = AVAsset(url: url)
        
        // iOS 16부터 AVFoundation은 Swift 클라이언트에 대해 AVAsset, 및 메서드의 동기식 속성 ​​및 메서드를 더 이상 사용하지 않습니다 .
        // 아래 설명된 구문을 선호하는 메서드를 사용하여 속성 값을 비동기적으로 로드하는 것을 더 이상 사용하지 않습니다.
        guard try await asset.load(.isPlayable) else {
            return nil
        }
        
        let duration = try await asset.load(.duration)
        print(duration)
        
        return asset
    }
    
    private func setupPlayerItem(with asset: AVAsset) {
        playerItem = AVPlayerItem(asset: asset)
        playerItem?.addObserver(
            self,
            forKeyPath: #keyPath(AVPlayerItem.status),
            options: [.old, .new],
            context: &playerItemContext
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.player = AVPlayer(playerItem: self?.playerItem!)
        }
    }
    
    // AVPlayer상태가 지속적으로 변경되는 동적 객체입니다. 플레이어의 상태를 관찰하는 데 사용할 수 있는 두 가지 방법이 있습니다.
    // 1. General State Observations: You can use key-value observing (KVO) to observe state changes to many of the player’s dynamic properties, such as its currentItem or its playback rate.
    // 2. Timed State Observations: KVO works well for general state observations, but isn’t intended for observing continuously changing state like the player’s time. AVPlayer provides two methods to observe time changes:
    
    // 상태 변화를 받기 위해서 구현한 메서드
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?
        , context: UnsafeMutableRawPointer?
    ) {
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            // Switch over status value
            switch status {
            case .readyToPlay:
                print(".readyToPlay")
                player?.play()
            case .failed:
                print(".failed")
            case .unknown:
                print(".unknown")
            @unknown default:
                print("@unknown default")
            }
        }
    }
}

extension PlayerView {
    func play(with url: URL) {
        Task {
            if #available(iOS 15, *) {
                guard let asset = try await setupAsset_iOS15(with: url) else { return }
                self.setupPlayerItem(with: asset)
            } else {
                setupAsset(with: url) { [weak self] asset in
                    self?.setupPlayerItem(with: asset)
                }
            }
        }
    }
}
