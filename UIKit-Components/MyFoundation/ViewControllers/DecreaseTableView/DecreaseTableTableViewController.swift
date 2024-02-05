//
//  DecreaseTableTableViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DecreaseTableTableViewController: UIBaseViewController {
    
    private let disposeBag = DisposeBag()
    
    var isHidden = false
    var startDraggingY: CGFloat = 0
    
    let dataSources: [String] = [
        "Java", "Python", "C", "C++", "C#", "JavaScript", "TypeScript",
        "Ruby", "Kotlin", "Swift", "Go", "Rust", "PHP", "Perl", "Lua",
        "Objective-C", "Shell", "R", "Scala", "Groovy", "Visual Basic .NET",
        "Dart", "MATLAB", "COBOL", "Fortran", "Ada"
    ]
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.estimatedRowHeight = 56
        $0.rowHeight = 56
        $0.register(DecreaseTestingCell.self, forCellReuseIdentifier: DecreaseTestingCell.identifier)
    }
    
    lazy var somethingView = UIView().then {
        $0.backgroundColor = .purple.withAlphaComponent(0.5)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "DecreaseTableTableView Testing")
        setupLayout()
        bindRx()
    }
    
    private func setupLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(somethingView)
        somethingView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(112)
        }
    }
    
    private func bindRx() {
        tableView.rx.willBeginDragging
            .subscribe(with: self, onNext: { owner, _ in
                owner.startDraggingY = owner.tableView.contentOffset.y
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didScroll
            .subscribe(with: self, onNext: { owner, _ in
                owner.relocatedSomthingView()
            })
            .disposed(by: disposeBag)
    }
    
    
    // 타이밍을 보완하는 수정 방법?
    // case1. default(show): tableView.bottom.equalTo(somethingView.snp.top)
    // case2. show -> dismiss: tableView.bottom.equalTo(somethingView.snp.top) 유지.
    // case3. dismiss -> show:
    // willBegingDragging 시점에 tableView.bottom.equalToSuperview() 로 변경.
    // didEndDragging 시점에 tableView.bottom.equalTo(somethingView.snp.top)으로 변경
    
    // frame 배치 방법도, autolayout 배치 방법도 동일한 문제 있음
    private func relocatedSomthingView() {
        somethingView.translatesAutoresizingMaskIntoConstraints = true
        
        if isHidden, startDraggingY - tableView.contentOffset.y > 0 {
            isHidden = false
            
            var frame = somethingView.frame
            frame.origin.y -= 112
            
            let animations = {
                //self.somethingView.snp.updateConstraints {
                //    $0.bottom.equalToSuperview().offset(112)
                //}
                self.somethingView.frame = frame
                self.view.layoutIfNeeded()
            }
            
            DispatchQueue.main.async {
                UIView.animate(
                    withDuration: 2.5,
                    delay: 0,
                    options: [.curveEaseInOut, .allowUserInteraction],
                    animations: animations
                )
            }

        } else if !isHidden, startDraggingY - tableView.contentOffset.y < 0 {
            isHidden =  true
            
            var frame = somethingView.frame
            frame.origin.y += 112
            
            let animations = {
                //self.somethingView.snp.updateConstraints {
                //    $0.bottom.equalToSuperview()
                //}
                
                self.somethingView.frame = frame
                self.view.layoutIfNeeded()
            }
            
            DispatchQueue.main.async {
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    options: [.curveEaseInOut, .allowUserInteraction],
                    animations: animations
                )
            }
        }
    }
}

extension DecreaseTableTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DecreaseTestingCell.identifier, for: indexPath) as! DecreaseTestingCell
        print("재사용됨: \(dataSources[indexPath.row])")
        cell.langLabel.text = dataSources[indexPath.row]
        return cell
    }
}
