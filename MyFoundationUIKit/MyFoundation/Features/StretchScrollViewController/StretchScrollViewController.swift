//
//  StretchScrollViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/08/29.
//

import UIKit

class StretchScrollViewController: UIBaseViewController {
    
    // StickyHeaderTableView와 같이 TableView를 이용하는것이 아닌,
    // ScrollView, Constraints, attribute 설정을 통해 구현.
    lazy var subView = StretchScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "StretchScrollView")
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    private func setupLayout() {
        addSubview(subView)
        subView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
