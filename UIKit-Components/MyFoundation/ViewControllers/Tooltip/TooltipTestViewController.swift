//
//  TooltipTestViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/26.
//

import UIKit

class TooltipTestViewController: UIBaseViewController {
    fileprivate let dataSource: [Int] = [1, 2, 3, 4, 5, 6]
    
    let window: UIWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first!
    
    private lazy var stackView = UIStackView().then {
        $0.spacing = 15
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.addBackground(color: .white)
    }
    
    private lazy var tooltip = UIButton(frame: CGRect(x: 150, y: 300, width: 0, height: 0)).then {
        $0.setTitle("Tooltip", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .notoSans(size: 12, style: .regular)
        $0.backgroundColor = .blue
        $0.titleLabel?.textAlignment = .center
        $0.isUserInteractionEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Tooltip")
        setupLayout()
        bindDataSource()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tooltip.snp.removeConstraints()
        tooltip.removeFromSuperview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeTooltip()
    }
    
    private func setupLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
//        let window: UIWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first!
//        window.addSubview(tooltip)
//        tooltip.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.size.equalTo(CGSize(width: 0, height: 0))
//        }
    }
    
    private func bindDataSource() {
        let viewArray = dataSource.map { String($0) }.map { data -> UILabel in
            let label = UILabel().then {
                $0.text = data
                $0.textColor = .black
                $0.textAlignment = .center
                $0.lineBreakMode = .byTruncatingTail
                $0.font = .notoSans(size: 16, style: .bold)
                $0.sizeToFit()
            }
            return label
        }
        viewArray.forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func removeTooltip() {
        //view.layoutIfNeeded()
        //DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            //self.tooltip.snp.removeConstraints()
            //self.tooltip.removeFromSuperview()
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.75,
                initialSpringVelocity: 0.8,
                options: .transitionCrossDissolve,
                animations: {
                    self.window.addSubview(self.tooltip)
                    self.tooltip.frame = CGRect(x: 150, y: 300, width: 160, height: 80)
                    self.window.layoutIfNeeded()
                    //self.tooltip.snp.remakeConstraints {
                    //    $0.center.equalToSuperview()
                    //    $0.size.equalTo(CGSize(width: 80, height: 20))
                    //}
                    //self.view.layoutIfNeeded()
                }, completion: { _ in
                    //snapshot.removeFromSuperview()
                    //transitionContext.containerView.addSubview(toViewController.view)
                    //transitionContext.completeTransition(true)
                    
                }
            )
        //})
        //view.layoutIfNeeded()
    }
}
