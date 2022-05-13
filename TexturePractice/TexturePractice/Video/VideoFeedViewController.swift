//
//  VideoFeedViewController.swift
//  TexturePractice
//
//  Created by 이서준 on 2022/04/29.
//

import UIKit
import SnapKit
import AsyncDisplayKit

class VideoFeedViewController: UIViewController {
    
    // 모든 UI 구성 요소는 struct에 위치하여한다.
    // 값 참조와 호출시마다 개별 인스턴스를 생성해주는 struct가 적절해서?
    struct Const {
        static let numberOfSection: Int = 1
        static let itemCount: Int = 4
    }
    
    lazy var tableNode = ASTableNode(style: .plain)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tableNode.backgroundColor = .gray
        view.addSubnode(tableNode)
        //위 보다는 추가할수있는 Subnode가 있다면, 아래의 자동적으로 addSubnode해주는..
        //automaticallyManagesSubnodes = true
        tableNode.dataSource = self
        tableNode.onDidLoad { _ in // weak..?
            // 뷰 관련 속성(메인쓰레드에서 다뤄야하는)에 대한 접근은 didLoad Block에서 처리해야함
            self.tableNode.view.separatorStyle = .none
            self.tableNode.view.snp.makeConstraints {
                $0.directionalEdges.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableNode.reloadData()
    }
}

extension VideoFeedViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return Const.numberOfSection
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return Const.itemCount
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = VideoCellNode()
        cell.configure(video: Video())
        return cell
    }
}
