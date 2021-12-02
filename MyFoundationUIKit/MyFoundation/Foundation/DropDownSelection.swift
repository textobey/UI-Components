//
//  DropDownSelection.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/01.
//

import UIKit
import RxSwift
import RxCocoa

class DropDownSelection: UIView {
    private let disposeBag = DisposeBag()
    
    /// Dropdown component datasource.
    var dataSource = [String]()
    
    /// Dropdown tableView row height.
    private let componentHeight: CGFloat = 50
    
    /// Be in charge of background alpha + tapGesture.
    lazy var transparentView = UIView().then {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        $0.frame = window?.frame ?? self.frame
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        $0.alpha = 0
    }
    
    /// Dropdown will show when this button tapped.
    lazy var dropDownButton = UIButton().then {
        $0.setTitle("select fruit", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .darkGray
    }
    /// Dropdown arrow indicator.
    lazy var dropDownArrow = UIImageView().then {
        $0.tintColor = .white
        $0.image = UIImage(systemName: "chevron.down")
    }
    /// This is real dropdown.
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.layer.cornerRadius = 5
        $0.register(DropDownSelectionCell.self, forCellReuseIdentifier: DropDownSelectionCell.identifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bindRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DropDown is deinit,")
    }
    
    private func setupLayout() {
        addSubview(dropDownButton)
        dropDownButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        dropDownButton.addSubview(dropDownArrow)
        dropDownArrow.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(24)
        }
        
        addSubview(transparentView)
        //transparentView.snp.make.. X
        //cause, it was already set when it was init.
        
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(dropDownButton.snp.bottom)
            $0.leading.trailing.equalTo(dropDownButton)
            $0.height.equalTo(0)
        }
    }
    
    private func bindRx() {
        dropDownButton.rx.tap
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.dataSource = ["Apple", "Mango", "Orange"]
            })
            .subscribe(onNext: { owner, _ in
                owner.showDropDownComponent(frames: owner.dropDownButton.frame)
            }).disposed(by: disposeBag)
        
        transparentView.tapGesture()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.hideDropDownComponent()
            }).disposed(by: disposeBag)
    }
    
    private func showDropDownComponent(frames: CGRect) {
        dropDownArrow.animate(transform: CGAffineTransform(rotationAngle: .pi), duration: 0.2)
        DispatchQueue.main.async {
            // serial queue에서 동작하게 해서, reloadData()가 된 후에 프로세스가 진행 되도록함.
            self.tableView.reloadData()
        }
        dropDownAnimate(hidden: false)
    }
    
    private func hideDropDownComponent() {
        dropDownArrow.animate(transform: CGAffineTransform(rotationAngle: .pi * 2), duration: 0.2)
        dropDownAnimate(hidden: true)
    }
    
    private func dropDownAnimate(hidden: Bool) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) { [weak self] in
            guard let `self` = self else { return }
            self.transparentView.alpha = hidden ? 0 : 0.5
            self.tableView.snp.updateConstraints {
                $0.height.equalTo(hidden ? 0 : CGFloat(self.dataSource.count) * self.componentHeight)
            }
        }
    }
}

extension DropDownSelection: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DropDownSelectionCell.identifier, for: indexPath) as? DropDownSelectionCell {
            cell.titleLabel.text = dataSource[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return componentHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropDownButton.setTitle(dataSource[indexPath.row], for: .normal)
        hideDropDownComponent()
    }
}

class DropDownSelectionCell: UITableViewCell {
    static let identifier = String(describing: MainListCell.self)
    
    lazy var titleLabel = UILabel().then {
        $0.textColor = .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //self.selectionStyle = .none
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
