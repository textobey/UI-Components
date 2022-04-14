//
//  StickyAlertTestViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/14.
//

import UIKit
import RxSwift
import RxCocoa

class StickyAlertViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private let closeButton = UIButton().then {
        $0.tintColor = .white
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var contentView = UIView().then {
        $0.backgroundColor = .brown
    }
    
    private let contents = [
        "Seoul",
        "Daejeon",
        "Daegu",
        "Busan"
    ]
    
    private let contentImages = [
        "https://imgur.com/Q6Za0ZO.jpg",
        "https://imgur.com/Eqbzusk.jpg",
        "https://imgur.com/SeU2Abo.jpg",
        "https://imgur.com/TBbqYg8.jpg"
    ]
    
    var headerView = StickeyHeaderView()
    
    var sectionView = StickeySectionView()
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.register(StickeyHeaderCell.self, forCellReuseIdentifier: StickeyHeaderCell.identifier)
        headerView.scrollView = $0
        headerView.frame = CGRect(x: 0, y: $0.safeAreaInsets.top, width: view.frame.width, height: 250)
        $0.backgroundView = UIView()
        $0.backgroundView?.addSubview(headerView)
        $0.contentInset = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
        $0.contentOffset = CGPoint(x: 0, y: -250)
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
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
        }
        
        contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-10)
            $0.size.equalTo(28)
        }
    }
    
    func bindRx() {
        closeButton.rx.tap.withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.didScroll
            .skip(1)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let frame = owner.sectionView.frame.minY
                let offset = owner.tableView.contentOffset.y
                owner.setStickeySection(set: offset >= frame)
            }).disposed(by: disposeBag)
    }
    
    private func setStickeySection(set: Bool) {
        if set {
            sectionView.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
            }
            sectionView.layer.zPosition = 1
        } else {
            sectionView.snp.remakeConstraints {
                $0.top.equalTo(headerView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
            sectionView.layer.zPosition = 0
        }
    }
}

class StickyAlertTestViewController: UIBaseViewController {
    private let disposeBag = DisposeBag()
    
    lazy var button = UIButton().then {
        $0.setTitle("Show StickyAlert", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "StickyAlert")
        setupLayout()
        bindRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let orientation = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(orientation, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let orientation = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientation, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    private func setupLayout() {
        addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(32)
        }
    }
    
    private func bindRx() {
        button.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let viewController = StickyAlertViewController()
                owner.navigationController?.present(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
}

extension StickyAlertViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 240 : 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StickeyHeaderCell.identifier, for: indexPath) as? StickeyHeaderCell else { return UITableViewCell() }
        cell.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            options: [.allowUserInteraction, .curveEaseInOut],
            animations: {
            cell.alpha = 1
        })
        cell.needCellExpanding = indexPath.row == 0
        cell.bindView(cityName: contents[indexPath.row], imageUrl: contentImages[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.updatePosition()
    }
}
