//
//  StandaloneNavigationBarViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StandaloneNavigationBarViewController: UIBaseViewController {
    let navigationBar = UINavigationBar()
    let item = UINavigationItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "StandaloneNavigationBar")
        setupLayout()
    }
    
    private func setupLayout() {
        guard let naviFrame = navigationController?.navigationBar.frame else { return }
        let safeAreaTop = UIApplication.shared.windows.first?.safeAreaInsets.top ?? CGFloat(0)
        
        navigationBar.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-(naviFrame.height + safeAreaTop))
        }
    }
    
    func navigationSet() {
        //appendLeftNavigationItem()
        //appendSpaceNavigaitonItem()
        
        //navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .white
        
        //Add it to viewcontroller's view and set it's constraints
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        //setImage(UIImage(systemName: "chevron.left"), for: .normal)
        //backbutton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        //backbutton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        item.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        item.title = ""

        navigationBar.items = [item]
    }
}
