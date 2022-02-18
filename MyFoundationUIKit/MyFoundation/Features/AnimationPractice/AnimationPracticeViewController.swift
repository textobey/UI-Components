//
//  AnimationPracticeViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/02/18.
//

import UIKit

class AnimationPracticeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 나중에 연습해야봐야지..일단 기록 먼저
        // allowUserInteraction 옵션을 부여해야, 애니메이션동안에 사용자 상호작용을 받을수있음.
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.8, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.view.layoutIfNeeded()
        }
    }
}
