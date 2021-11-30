//
//  PickerView.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/29.
//

import UIKit
import RxCocoa

class PickerViewModel {
    var selectedDate: (year: String, month: String, day: String) = ("\(2020)", "\(1)", "\(1)")
    
    let arrayOftime1: [[String]] = [
        ["오전", "오후"],
        Array(1 ... 23).map { $0 < 10 ? "0" + "\($0)" : "\($0)" },
        [":"],
        Array(1 ... 59).map { $0 < 10 ? "0" + "\($0)" : "\($0)" }
    ]
    var arrayOftime2: [[String]] = [
        Array(2020 ... 2023).map { "\($0)" },
        ["년"],
        Array(1 ... 12).map { $0 < 10 ? "0" + "\($0)" : "\($0)" },
        ["월"],
        Array(1 ... 31).map { $0 < 10 ? "0" + "\($0)" : "\($0)" },
        ["일"]
    ]
    func updateArrayoftime2(year: String) {
        selectedDate.year = year
        let newDate = makeStringToDate()
        let arrayOftime2day = Array(newDate.startOfMonth().day ... newDate.endOfMonth().day)
            .map { $0 < 10 ? "0" + "\($0)" : "\($0)" }
        arrayOftime2[4] = arrayOftime2day
    }
    func updateArrayoftime2(month: String) {
        selectedDate.month = month
        let newDate = makeStringToDate()
        let arrayOftime2day = Array(newDate.startOfMonth().day ... newDate.endOfMonth().day)
            .map { $0 < 10 ? "0" + "\($0)" : "\($0)" }
        
        arrayOftime2[4] = arrayOftime2day
        
    }
    private func makeStringToDate() -> Date {
        let newDateString = selectedDate.year + "-" + selectedDate.month + "-" + "01" + " 08:00:00"
        return newDateString.toDate() ?? Date()
    }
}

class PickerView: UIView {
    private let viewModel = PickerViewModel()
    
    lazy var containerView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        $0.layer.borderColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
    }
    
    lazy var pickerView = UIPickerView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setDefaultRowValue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(134)
        }
        containerView.addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setDefaultRowValue() {
        //pickerView.selectRow(0, inComponent: 0, animated: false)
        //pickerView.selectRow(11, inComponent: 2, animated: false)
        //pickerView.selectRow(29, inComponent: 4, animated: false)
    }
}

extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.arrayOftime2.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.arrayOftime2[component].count
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        //return component == 2 ? 10 : 95
        return component % 2 == 0 ? 74 : 24
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            viewModel.updateArrayoftime2(year: viewModel.arrayOftime2[component][row])
        } else if component == 2 {
            viewModel.updateArrayoftime2(month: viewModel.arrayOftime2[component][row])
        }
        pickerView.reloadAllComponents()
        //print("selectedComponet:", component)
        //print("selectedRow:", row)
        //print(Int(viewModel.arrayOftime2[component][row]))
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        print(viewModel.arrayOftime2[4])
        let baseView = UIView()
        baseView.backgroundColor = .white
        let timeLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .notoSans(size: 26, style: .bold)
            $0.text = viewModel.arrayOftime2[component][row]
        }
        baseView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        return baseView
    }
}

/*
extension UIPickerView {
    func setPickerLabels(labels: [Int:UILabel]) { // [component number:label]
        
        let fontSize: CGFloat = 20
        let labelWidth: CGFloat = self.frame.size.width / CGFloat(self.numberOfComponents)
        //let x: CGFloat = self.frame.origin.x
        let y: CGFloat = (self.frame.size.height / 2) - (fontSize / 2)

        for i in 0 ... self.numberOfComponents {
            
            if let label = labels[i] {
                label.frame = CGRect(x: labelWidth * CGFloat(i), y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.center
                self.addSubview(label)
            }
        }
    }
}
*/
