//
//  VideoContentNode.swift
//  TexturePractice
//
//  Created by 이서준 on 2022/04/29.
//

import UIKit
import Then
import AsyncDisplayKit

class VideoContentNode: ASDisplayNode {
    
    var state: VideoState?
    
    struct Const {
        static let videoRatio: CGFloat = 0.5
        static let stackSpacing: CGFloat = 0.2
        static let foregroundColorKey = NSAttributedString.Key.foregroundColor
        static let fontKey = NSAttributedString.Key.font
        static let insets: UIEdgeInsets = .init(
            top: 20.0, left: 15.0, bottom: 20.0, right: 15.0
        )
        static let playIconSize: CGSize = .init(
            width: 60.0, height: 60.0
        )
    }
    
    enum VideoState {
        case readyToPlay(URL)
        case play(URL)
        case pause(URL)
    }
    
    enum TextStyle {
        case title
        case description
        
        var fontStyle: UIFont {
            switch self {
            case .title:
                return UIFont.systemFont(ofSize: 14, weight: .bold)
            case .description:
                return UIFont.systemFont(ofSize: 10, weight: .regular)
            }
        }
        
        var fontColor: UIColor {
            switch self {
            case .title:
                return UIColor.black
            case .description:
                return UIColor.gray
            }
        }
        
        func attributedText(_ text: String) -> NSAttributedString {
            let attr = [
                Const.foregroundColorKey: fontColor,
                Const.fontKey: self.fontStyle
            ]
            return NSAttributedString(string: text, attributes: attr)
        }
    }
    
    lazy var playButton = ASButtonNode().then {
        $0.setImage(UIImage(systemName: "play.fill"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        // ASDisplayNode는 ASLayoutElementStyle를 상속받고 있다.
        // ASLayoutElementStyle 프로퍼티에 접근하여, ASDimension 혹은 ASLayoutSize를 지정함
        $0.style.preferredSize = Const.playIconSize
        $0.addTarget(self, action: #selector(self.replay), forControlEvents: .touchUpInside)
    }
    
    lazy var videoNode = { () -> GTVideoNode in
        let node = GTVideoNode(ratio: 0.5, videoGravity: .resizeAspectFill, playControlNode: self.playButton)
        node.backgroundColor = UIColor.blue.withAlphaComponent(0.05)
        return node
    }()
    
    // UI 구성 요소가 전혀 사용되지 않더라도, 불필요한 할당과 계산을 피하기 위해 게으른 프로퍼티로 생성
    lazy var titleNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.backgroundColor = .white
        node.maximumNumberOfLines = 2
        return node
    }()
    
    lazy var descriptionNode: ASTextNode = {
        let node = ASTextNode()
        node.backgroundColor = .white
        node.maximumNumberOfLines = 2
        return node
    }()
    
    lazy var descriptionNodeWithThen = ASTextNode().then {
        $0.backgroundColor = .white
        $0.maximumNumberOfLines = 2
    }
    
    /*
     노드를 생성하는 좋지 않은 방법.
     func badSmellTitleNode() -> ASTextNode {
        let node = ASTextNode()
        return node
    }
    */
    
    override init() {
        super.init()
        backgroundColor = .white
        // addSubnode를 하나하나 해주지 않더라도, node가 있다면 자동으로 addSubnode를 할수있는방법
        automaticallyManagesSubnodes = true
    }
    
    @objc func replay() {
        self.videoNode.replayVideo()
    }
}

extension VideoContentNode {
    func configure(video: Video) {
        self.titleNode.attributedText = TextStyle.title.attributedText(video.title)
        self.descriptionNode.attributedText = TextStyle.title.attributedText(video.description)
        self.videoNode.setVideoAsset(video.url, isCache: true)
    }
}

extension VideoContentNode {
    func videoRatioLayout() -> ASLayoutSpec {
        let videoRatioLayout = ASRatioLayoutSpec(
            ratio: Const.videoRatio,
            child: self.videoNode
        )
        // 특정 layout element를 가운데로 정렬하며 해당하는 layout element에 constraintedSize.max값을 전달해서 size를 계산합니다.
        let playButtonCenterLayout = ASCenterLayoutSpec(
            centeringOptions: .XY,
            sizingOptions: [],
            child: playButton
        )
        // 명칭 그대로 Overlay 해주는 LayoutSpec으로써, 특정 Overlay 대상 노드를 특정 child 노드위에 Overlay시키는 LayoutSpec입니다.
        return ASOverlayLayoutSpec(child: videoRatioLayout, overlay: playButtonCenterLayout)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        /*
            Flexbox는 다양한 화면 크기에서 일관된 레이아웃을 제공하도록 설계되어 있으며, Flexbox를 기반으로 child layout element의 위치와 크기를 결정합니다.
            해당 레이아웃에서는 child layout element들에 대해서 세로 또는 가로 스택으로 정렬합니다.
         
            Stack Layout은 다른 Stack Layout의 child layout element가 될 수 있으므로,
            ASStackLayoutSpec에서 제공해주는 모든 기능을 사용하여 거의 모든 레이아웃을 만들 수 있습니다.
         */
        let stackLayoutSpec = ASStackLayoutSpec(
            direction: .vertical,                           // child layout elements에 대해서 순차적으로 쌓는 방향을 지정합니다.
            spacing: Const.stackSpacing,                    // child layout elements 간의 균등한 사이간격을 지정합니다.
            justifyContent: .start,                         // 주축을 따른 정렬방법을 정의합니다.
            alignItems: .stretch,                           // 교차 축을 따라 정렬된 child layout elements들의 orientation을 지정합니다.
            children: [videoRatioLayout(), titleNode, descriptionNode] // stackLayout에 쌓이는 child layout elements 의미합니다.
        )
        // child element에 inset값을 적용 시켜주는 LayoutSpec입니다.
        return ASInsetLayoutSpec(insets: Const.insets, child: stackLayoutSpec)
    }
}
