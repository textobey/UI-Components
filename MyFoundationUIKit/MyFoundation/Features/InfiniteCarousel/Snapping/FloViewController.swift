//
//  FloViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/13.
//

import UIKit

class FloViewController: UIBaseViewController {
    
    private var dataSources: [RandomImage] = [] {
        didSet {
            setupLayout()
        }
    }
    
    lazy var horizontalController = FloHorizontalController().then {
        $0.dataSources = self.dataSources
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "AppStoreClone")
        fetchImageResources()
    }
    
    private func setupLayout() {
        view.addSubview(horizontalController.view)
        horizontalController.view.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()//.inset(11)
            $0.height.equalTo(calHorizontalHeight())
        }
    }
    
    private func calHorizontalHeight() -> CGFloat {
        return (view.bounds.width - 22) / 2
    }
    
    private func fetchImageResources() {
        RandomImageLoader.shared.fetchImageResources(count: 8) { [weak self] randomImages in
            if let randomImages = randomImages {
                self?.dataSources = [[RandomImage]](repeating: randomImages, count: 50).flatMap { $0 }
            }
        }
    }
}
