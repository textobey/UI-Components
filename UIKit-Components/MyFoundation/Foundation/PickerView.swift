//
//  PickerView.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/29.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct PickerViewInitComponent {
    let type             : PickerViewType
    var pickerViewWidth  : CGFloat? = 295
    var pickerViewHeight : CGFloat? = 134
    var rowHeight        : CGFloat? = 42
    var componentWidth   : [CGFloat]
}

class PickerView: UIView {
    private let disposeBag = DisposeBag()
    private let viewModel: PickerViewModel
    private var pickerModel: PickerViewInitComponent
    
    /// RxDataSources 팟에서 제공하는 pickerView dataSource
    lazy var adapter = RxPickerViewViewAdapter<[[String]]>(
        components: [],
        numberOfComponents: { dataSource, pickerView, items -> Int in
            return items.count
        },
        numberOfRowsInComponent: { dataSource, pickerView, items, component -> Int in
            return items[component].count
        },
        viewForRow: { dataSource, pickerView, items, row, component, view -> UIView in
            return UIView()
        }
    )
    
    lazy var containerView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        $0.layer.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
    }
    
    lazy var pickerView = UIPickerView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.isMultipleTouchEnabled = false
    }
    
    lazy var confirm = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        $0.backgroundColor = .white
    }
    
    init(model: PickerViewInitComponent) {
        self.pickerModel = model
        self.viewModel = PickerViewModel(type: model.type)
        super.init(frame: .zero)
        setupLayout()
        bindRx()
        checkModelCount()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.d("> PickerView Deinit.")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Remove main view rounded border
        pickerView.layer.borderWidth = 0
        // Remove component borders
        pickerView.subviews.forEach {
            $0.layer.borderWidth = 0
            $0.isHidden = $0.frame.height <= 1.0
        }
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(pickerModel.pickerViewWidth!)
            $0.height.equalTo(pickerModel.pickerViewHeight!)
        }
        containerView.addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        addSubview(confirm)
        confirm.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(52)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(42)
            $0.height.equalTo(24)
            $0.bottom.equalToSuperview().offset(-52)
        }
    }
    
    private func bindRx() {
        confirm.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                print(owner.viewModel.currentSelectedDate)
            }).disposed(by: disposeBag)
        
        /// 아래와 같은 방법으로 delegate 구현없이 생성 가능하다.
        //Observable.just(viewModel.dataSource)
        //    .bind(to: pickerView.rx.items(adapter: adapter))
        //    .disposed(by: disposeBag)
    }
    
    private func checkModelCount() {
        if pickerModel.componentWidth.count > viewModel.dataSource.count {
            (0 ..< pickerModel.componentWidth.count - viewModel.dataSource.count).forEach { _ in
                viewModel.dataSource.append(["Error"])
            }
        } else if pickerModel.componentWidth.count < viewModel.dataSource.count {
            (0 ..< viewModel.dataSource.count - pickerModel.componentWidth.count).forEach { _ in
                pickerModel.componentWidth.append(30)
            }
        }
    }
}

extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.dataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.dataSource[component].count
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerModel.componentWidth[component]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerModel.rowHeight!
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if viewModel.type == .calendar {
            DispatchQueue.main.async {
                self.viewModel.updateSelectedDate(component: component, row: row)
                pickerView.reloadAllComponents()
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let baseView = UIView()
        baseView.backgroundColor = .white
        let timeLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .notoSans(size: 26, style: .bold)
            $0.text = viewModel.dataSource[component][row]
        }
        baseView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return baseView
    }
}
