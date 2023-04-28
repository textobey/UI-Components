//
//  PlayerView.swift
//  MyFoundation
//
//  Created by 이서준 on 2023/04/28.
//

import AVFoundation
import UIKit

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

extension PlayerView {
    func configureAudioSession(isActive: Bool) {
        // AVAudioSession을 핸들링 하는 작업은 실패할 수 있기 때문에, try catch로 작업
        do {
            // OS에게 앞으로 앱에서 오디오를 사용할것임을 알리는 setActive(_:)
            try AVAudioSession.sharedInstance().setActive(false)
            if isActive {
                // 현재 오디오 세션의 카테고리를 설정(playback: 단말 음소거 상태에서도 오디오를 출력할수있음)
                try AVAudioSession.sharedInstance().setCategory(.playback)
                // 오디오 세션 모드를 설정(moviePlayback: 영상 재생시에 Apple에서 권장하는 모드)
                try AVAudioSession.sharedInstance().setMode(.moviePlayback)
                try AVAudioSession.sharedInstance().setActive(true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
