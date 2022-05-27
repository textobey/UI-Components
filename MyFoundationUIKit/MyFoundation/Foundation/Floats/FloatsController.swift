//
//  FloatsController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/27.
//

import UIKit
import SnapKit

class FloatsController: UIViewController {
    
    private lazy var popupView: ShadowView = {
        let model = ShadowView.ShadowComponent(color: #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1), alpha: 0.12, x: 0, y: 3, blur: 14, spread: 2)
        let shadowView = ShadowView(model: model)
        shadowView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9)
        return shadowView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = .clear
        modalPresentationStyle = .overFullScreen
        //transitioningDelegate = transition
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            //$0.width.equalTo(UIScreen.main.bounds.size.width)
            $0.height.equalTo(108)
        }
    }
}
