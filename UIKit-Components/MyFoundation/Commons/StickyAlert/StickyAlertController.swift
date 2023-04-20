//
//  StickyAlertController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StickyAlertController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private(set) var headerView: StickeyHeaderView
    private(set) var sectionView: StickeySectionView
    
    let transition: AlertTransition = AlertTransition()
    
    private var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height - tableView.bounds.size.height
    }
    
    private let closeButton = UIButton().then {
        $0.tintColor = .white
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var contentView = UIView().then {
        $0.backgroundColor = .brown
    }
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.register(StickeyHeaderCell.self, forCellReuseIdentifier: StickeyHeaderCell.identifier)
        headerView.scrollView = $0
        headerView.frame = CGRect(x: 0, y: $0.safeAreaInsets.top, width: UIScreen.main.bounds.size.width / 2, height: 250)
        $0.backgroundView = UIView()
        $0.backgroundView?.addSubview(headerView)
        $0.contentInset = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
        $0.contentOffset = CGPoint(x: 0, y: -250)
    }
    
    lazy var footerButton = UIButton().then {
        $0.setTitle("Show StickyAlert", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 4
    }
    
    init(header: StickeyHeaderView, section: StickeySectionView) {
        self.headerView = header
        self.sectionView = section
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transition
        sectionView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
        bindRx()
    }
    
    func setupLayout() {
        let width = UIScreen.main.bounds.size.width / 2
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(width)
        }
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(sectionView)
        sectionView.snp.makeConstraints {
            $0.bottom.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-10)
            $0.size.equalTo(28)
        }
        
        contentView.addSubview(footerButton)
        footerButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    func bindRx() {
        closeButton.rx.tap.withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .withPrevious()
            .subscribe(onNext: { [weak self] (previous, current) in
                guard let `self` = self else { return }
                self.setStickeySection(set: self.tableView.contentOffset.y > 0)
                if let previousY = previous?.y {
                    self.animateFooterButton(show: previousY > current.y)
                }
            }).disposed(by: disposeBag)
    }
    
    private func animateFooterButton(show: Bool) {
        // tableView contentSize를 벗어나는 scroll은 무시
        guard tableView.contentOffset.y > 0, tableView.contentOffset.y < tableViewHeight else { return }
        
        if view.frame.contains(footerButton.frame) {
            if show {
                return
            } else {
                print("hidden")
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowUserInteraction, animations: {
                        //self.footerButton.frame.origin.y += 40
                        self.footerButton.snp.updateConstraints {
                            $0.bottom.equalToSuperview().offset(40)
                        }
                        self.view.layoutIfNeeded()
                    })
                }
            }
        } else {
            if show {
                print("show")
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowUserInteraction, animations: {
                        //self.footerButton.frame.origin.y -= 40
                        self.footerButton.snp.updateConstraints {
                            $0.bottom.equalToSuperview()
                        }
                        self.view.layoutIfNeeded()
                    })
                }
            } else {
                return
            }
        }
    }
    
    private func setStickeySection(set: Bool) {
        if set {
            self.sectionView.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
            }
            sectionView.titleLabel.textColor = .black
            closeButton.tintColor = .black
            sectionView.layer.zPosition = 1
        } else {
            self.sectionView.snp.remakeConstraints {
                $0.bottom.equalTo(self.headerView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
            sectionView.titleLabel.textColor = .white
            closeButton.tintColor = .white
            sectionView.layer.zPosition = 0
        }
    }
}

extension StickyAlertController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return contents.count
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 240 : 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StickeyHeaderCell.identifier, for: indexPath) as? StickeyHeaderCell else { return UITableViewCell() }
        /*cell.alpha = 0
         UIView.animate(
         withDuration: 0.5,
         delay: 0.05 * Double(indexPath.row),
         options: [.allowUserInteraction, .curveEaseInOut],
         animations: {
         cell.alpha = 1
         })*/
        //cell.needCellExpanding = indexPath.row == 0
        //cell.bindView(cityName: contents[indexPath.row], imageUrl: contentImages[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.updatePosition()
    }
}
