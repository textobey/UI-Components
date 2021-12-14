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
    var isBorderStyle   : Bool?    = false
    var backgroundColor : UIColor? = #colorLiteral(red: 0.8862745098, green: 0.8901960784, blue: 0.9019607843, alpha: 0.3)
    var rowHeight       : CGFloat? = 50
    var cornerRadius    : CGFloat? = 10
    //CACornerMask           Corner
    //layerMinXMinYCorner    top left corner
    //layerMaxXMinYCorner    top right corner
    //layerMinXMaxYCorner    bottom left corner
    //layerMaxXMaxYCorner    bottom right corner
    var rectCorner      : CACornerMask? = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
}

class DropDownSelection: UIView {
    private let disposeBag = DisposeBag()
    /// Dropdown UI 생성에 필요한 모델입니다.
    let model: DropDownInitComponent
    /// Dropdown에서 선택된 요소들에 대한 정보입니다. get만 하시고 임의로 set하지 않도록 해야합니다.
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
        Log.d("> DropDownView Deinit.")
    }
    
    /// Dropdown이 열렸을 때, Dropdown 바깥 영역(Dim 영역)을 담당합니다.
    lazy var transparentView = UIView().then {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        $0.frame = window?.frame ?? self.frame
        //$0.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        $0.alpha = 0
    }
    
    /// Dropdown을 열기 위한 버튼입니다.
    lazy var dropDownButton = UIButton().then {
        $0.backgroundColor = model.isBorderStyle! ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : model.backgroundColor
        $0.layer.borderWidth = model.isBorderStyle! ? 1 : 0
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        $0.layer.cornerRadius = model.cornerRadius!
        $0.clipsToBounds = true
        //$0.roundCorners(corners: [.allCorners], radius: model.cornerRadius!)
    }
    lazy var dropDownButtonTitle = UILabel().then {
        $0.text = "\(model.dataSource[0])"
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.font = .notoSans(size: 16, style: .regular)
    }
    /// isBorderStyle일 경우, border를 가려주기 위한 View. CALayer로 부분부분만 그리는게 나을지..?
    lazy var borderMaskView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    /// Dropdown arrow indicator입니다.
    lazy var dropDownArrow = UIImageView().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "chevron.down")
    }
    /// 실제 Dropdown을 담당합니다.
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = model.isBorderStyle! ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : model.backgroundColor
        $0.layer.borderWidth = model.isBorderStyle! ? 1 : 0
        $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
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
        dropDownButton.addSubviews([dropDownButtonTitle, dropDownArrow])
        dropDownButtonTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalTo(dropDownArrow.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
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
        
        guard model.isBorderStyle! else { return }
        addSubview(borderMaskView)
        borderMaskView.snp.makeConstraints {
            $0.leading.trailing.equalTo(tableView).inset(1)
            $0.centerY.equalTo(dropDownButton.snp.bottom)
            $0.height.equalTo(2)
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
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                owner.hideDropDownComponent()
                guard let cell = owner.tableView.cellForRow(at: indexPath) as? DropDownSelectionCell else { return }
                owner.dropDownButtonTitle.text = cell.titleLabel.text
                owner.selectedElement = (indexPath.row, cell.titleLabel.text!)
            }).disposed(by: disposeBag)
        
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
    }
    
    /// Dropdown이 나타날때, 수행해야하는 동작이 지정된 함수입니다.
    private func showDropDownComponent(frames: CGRect) {
        dropDownArrow.animate(transform: CGAffineTransform(rotationAngle: .pi), duration: 0.2)
        changeCornerRadius(isOpen: true)
        DispatchQueue.main.async {
            // serial queue에서 동작하게 해서, reloadData()가 된 후에 처리가 진행 되도록함.
            self.tableView.reloadData()
        }
        dropDownAnimate(hidden: false)
        guard model.isBorderStyle! else { return }
        borderMaskView.isHidden = false
    }
    
    /// Dropdown이 숨겨질때, 수행해야하는 동작이 지정된 함수입니다.
    private func hideDropDownComponent() {
        dropDownArrow.animate(transform: CGAffineTransform(rotationAngle: .pi * 2), duration: 0.2)
        changeCornerRadius(isOpen: false)
        dropDownAnimate(hidden: true)
        guard model.isBorderStyle! else { return }
        borderMaskView.isHidden = true
    }
    
    /// Dropdown 표시/숨김처리간에 수행해줄 애니메이션입니다.
    private func dropDownAnimate(hidden: Bool) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) { [weak self] in
            guard let `self` = self else { return }
            self.transparentView.alpha = hidden ? 0 : 0.5
            self.tableView.snp.updateConstraints {
                $0.height.equalTo(hidden ? 0 : CGFloat(self.model.dataSource.count) * self.model.rowHeight!)
            }
        }
    }
    
    /// Dropdown이 열렸는지, 닫혔는지에 따라 Dropdown버튼의 cornerRadius를 변경합니다.
    private func changeCornerRadius(isOpen: Bool) {
        let top: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let all: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        let corner: CACornerMask = isOpen ? top : all
        dropDownButton.layer.maskedCorners = corner
    }
}
