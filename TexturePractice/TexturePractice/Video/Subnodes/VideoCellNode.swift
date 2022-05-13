//
//  VideoCellNode.swift
//  TexturePractice
//
//  Created by 이서준 on 2022/04/29.
//

import UIKit
import AsyncDisplayKit

class VideoCellNode: ASCellNode {
    lazy var videoNode = VideoContentNode()
    
    struct Const {
        static let insets: UIEdgeInsets = .init(
            top: 20.0,
            left: 15.0,
            bottom: 0.0,
            right: 15.0)
    }
    
    override init() {
        super.init()
        self.selectionStyle = .none
        self.automaticallyManagesSubnodes = true
    }
    
    func configure(video: Video) {
        videoNode.configure(video: video)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: Const.insets, child: videoNode)
    }
}
