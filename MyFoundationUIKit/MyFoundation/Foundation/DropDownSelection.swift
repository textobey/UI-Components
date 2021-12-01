//
//  DropDownSelection.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/01.
//

import UIKit
import RxSwift
import RxCocoa

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

class DropDownSelection: UIView {
    private let disposeBag = DisposeBag()
    
    //private let _width: Int = 50
    private let componentHeight: CGFloat = 50
    
    lazy var transparentView = UIView()
    
    lazy var selectedButton = UIButton()
    
    lazy var btnSelectFruit = UIButton().then {
        $0.setTitle("select fruit", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .darkGray
    }
    lazy var btnSelectFruitArrow = UIImageView().then {
        $0.tintColor = .white
        $0.image = UIImage(systemName: "chevron.down")
    }
    
    /*
    lazy var btnSelectGender = UIButton().then {
        $0.setTitle("select gender", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .lightGray
    }
    lazy var btnSelectGenderArrow = UIImageView().then {
        $0.tintColor = .white
        $0.image = UIImage(systemName: "chevron.down")
    }
    */
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(DropDownSelectionCell.self, forCellReuseIdentifier: DropDownSelectionCell.identifier)
    }
    
    var dataSource = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bindRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(btnSelectFruit)
        btnSelectFruit.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        btnSelectFruit.addSubview(btnSelectFruitArrow)
        btnSelectFruitArrow.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(24)
        }
        /*
        addSubview(btnSelectGender)
        btnSelectGender.snp.makeConstraints {
            $0.top.equalTo(btnSelectFruit.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        btnSelectGender.addSubview(btnSelectGenderArrow)
        btnSelectGenderArrow.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(24)
        }
        */
    }
    
    private func bindRx() {
        btnSelectFruit.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dataSource = ["Apple", "Mango", "Orange"]
                owner.selectedButton = owner.btnSelectFruit
                owner.addTransparentView(frames: owner.btnSelectFruit.frame)
                owner.btnSelectFruitArrow.animate(transform: CGAffineTransform(rotationAngle: .pi), duration: 0.2)
                //owner.btnSelectFruitArrow.rotate()
            }).disposed(by: disposeBag)
        
        /*
        btnSelectGender.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dataSource = ["Male", "Female"]
                owner.selectedButton = owner.btnSelectGender
                owner.addTransparentView(frames: owner.btnSelectGender.frame)
                owner.btnSelectGenderArrow.animate(transform: CGAffineTransform(rotationAngle: .pi * 2), duration: 0.2)
                //owner.btnSelectGenderArrow.rotate()
            }).disposed(by: disposeBag)
        */
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        transparentView.frame = window?.frame ?? self.frame
        addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) { [weak self] in
            guard let `self` = self else { return }
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x,
                                          y: frames.origin.y + frames.height,
                                          width: frames.width,
                                          height: CGFloat(self.dataSource.count) * self.componentHeight)
        }
    }
    
    @objc func removeTransparentView() {
        btnSelectFruitArrow.animate(transform: CGAffineTransform(rotationAngle: .pi * 2), duration: 0.2)
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) { [weak self] in
            self?.transparentView.alpha = 0
            self?.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
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
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
}
