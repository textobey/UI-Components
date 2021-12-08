//
//  DropDownSelection.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/01.
//

import UIKit
import RxSwift
import RxCocoa

struct DropDownInitComponent {
    let dataSource      : [String]
    let backgroundColor : UIColor? = .darkGray
    let rowHeight       : CGFloat? = 50
    let cornerRadius    : CGFloat? = 10
    let rectCorner      : CACornerMask? = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
}

class DropDownSelection: UIView {
    private let disposeBag = DisposeBag()
    /// Dropdown UI 생성에 필요한 모델입니다.
    let model: DropDownInitComponent
    lazy var selectedElement: (row: Int, string: String) = (0, model.dataSource[0])
    
    init(model: DropDownInitComponent) {
        self.model = model
        super.init(frame: .zero)
        setupLayout()
        bindView()
        bindRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DropDown is deinit,")
    }
    
    /// Dropdown이 열렸을 때, Dropdown 바깥 영역(Dim 영역)을 담당합니다.
    lazy var transparentView = UIView().then {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        $0.frame = window?.frame ?? self.frame
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        $0.alpha = 0
    }
    
    /// Dropdown을 열기 위한 버튼입니다.
    lazy var dropDownButton = UIButton().then {
        $0.setTitle("\(model.dataSource[0])", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = model.backgroundColor
        $0.layer.cornerRadius = model.cornerRadius!
    }
    /// Dropdown arrow indicator입니다.
    lazy var dropDownArrow = UIImageView().then {
        $0.tintColor = .white
        $0.image = UIImage(systemName: "chevron.down")
    }
    /// 실제 Dropdown을 담당합니다.
    lazy var tableView = UITableView().then {
        $0.layer.cornerRadius = model.cornerRadius!
        $0.rowHeight = model.rowHeight!
        $0.layer.maskedCorners = model.rectCorner!
        $0.register(DropDownSelectionCell.self, forCellReuseIdentifier: DropDownSelectionCell.identifier)
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
    
    private func bindView() {
        Observable.just(model.dataSource)
            .bind(to: tableView.rx.items(cellIdentifier: DropDownSelectionCell.identifier, cellType: DropDownSelectionCell.self)) { [weak self] row, element, cell in
                guard let `self` = self else { return }
                cell.titleLabel.text = element
                cell.isSelected = (row == self.selectedElement.row)
            }.disposed(by: disposeBag)
    }
    
    private func bindRx() {
        dropDownButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.showDropDownComponent(frames: owner.dropDownButton.frame)
            }).disposed(by: disposeBag)
        
        transparentView.tapGesture()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.hideDropDownComponent()
            }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                owner.hideDropDownComponent()
                guard let cell = owner.tableView.cellForRow(at: indexPath) as? DropDownSelectionCell else { return }
                owner.dropDownButton.setTitle(cell.titleLabel.text, for: .normal)
                owner.selectedElement = (indexPath.row, cell.titleLabel.text!)
            }).disposed(by: disposeBag)
    }
    
    private func showDropDownComponent(frames: CGRect) {
        dropDownArrow.animate(transform: CGAffineTransform(rotationAngle: .pi), duration: 0.2)
        DispatchQueue.main.async {
            // serial queue에서 동작하게 해서, reloadData()가 된 후에 처리가 진행 되도록함.
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
                $0.height.equalTo(hidden ? 0 : CGFloat(self.model.dataSource.count) * self.model.rowHeight!)
            }
        }
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
        self.selectionStyle = .none
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
            } else {
                titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
            }
        }
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
