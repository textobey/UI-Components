//
//  DropDownViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/01.
//

import UIKit

class DropDownViewController: UIViewController {
    //private let disposeBag = DisposeBag()
    
    private let backButton = UIButton().then {
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var navigationBar = UINavigationBar().then {
        let item = UINavigationItem()
        $0.setBackgroundImage(UIImage(), for: .default)
        $0.shadowImage = UIImage()
        $0.isTranslucent = true
        $0.backgroundColor = .white
        $0.tintColor = .clear
        item.leftBarButtonItems = [UIBarButtonItem(customView: backButton)]
        item.title = "TextBox"
        $0.items = [item]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
    }
}
