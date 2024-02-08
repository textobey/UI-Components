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
        $0.backgroundColor = .gray
    }
    
    lazy var somethingLabel = UILabel().then {
        $0.text = "SomeView(TabBar)"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "DecreaseTableTableView Testing")
        setupLayout()
        bindRx()
    }
    
    private func setupLayout() {
        addSubview(tableView)
        addSubview(somethingView)
        
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            
            // FIXME: 이슈 재현을 원한다면 아래 bottom 제약조건을 변경해주세요
            $0.bottom.equalToSuperview().inset(112)
            //$0.bottom.equalTo(somethingView.snp.to)
        }
        
        somethingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(112)
        }
        
        somethingView.addSubview(somethingLabel)
        somethingLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
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
        if isHidden, startDraggingY - tableView.contentOffset.y > 0 {
            isHidden = false
            
            let animations = {
                self.somethingView.snp.updateConstraints {
                    $0.bottom.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            }
            
            let completion: ((Bool) -> Void) = { _ in
                // FIXME: 이슈 재현을 원한다면 아래 updateConstraints를 주석해주세요
                self.tableView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(112)
                }
                self.view.layoutIfNeeded()
            }
            
            DispatchQueue.main.async {
                UIView.animate(
                    withDuration: 3.5,
                    delay: 0,
                    options: [.curveEaseInOut, .allowUserInteraction],
                    animations: animations,
                    completion: completion
                )
            }

        } else if !isHidden, startDraggingY - tableView.contentOffset.y < 0 {
            isHidden =  true
            
            let animations = {
                self.somethingView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(112)
                }
                // FIXME: 이슈 재현을 원한다면 아래 updateConstraints를 주석해주세요
                self.tableView.snp.updateConstraints {
                    $0.bottom.equalToSuperview()
                }
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
        cell.langLabel.text = dataSources[indexPath.row]
        return cell
    }
}
