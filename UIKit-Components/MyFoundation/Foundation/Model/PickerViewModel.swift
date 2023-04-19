//
//  PickerViewModel.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/13.
//

import Foundation
import RxSwift
import RxCocoa

enum PickerViewType {
    case calendar // 년, 월, 일
    case hour24   // 오전,오후O
    case hour12   // 오전,오후X
    case minute5  // 5분후부터 0시간 0분동안
}

class PickerViewModel {
    typealias SelectedDate = (year: String, month: String, day: String)
    /// 픽커뷰를 구성하는 기준이 되는 타입
    let type: PickerViewType
    
    // - willSet으로 분기하기보다 두개의 변수로 확실히 나누어 관리함.
    //   + DataSource를 업데이트 하기 위한 변수이므로, 해당 변수를 참조하여 상호작용에 이용하면 안됩니다.
    /// selectedDate "oldValue"
    private var pastSelectedDate: SelectedDate = ("\(Date().year)", "\(Date().month)", "\(Date().day)")
    
    /// selectedDate "newValue"
    var currentSelectedDate: SelectedDate {
        didSet {
            if !isDayChange() { // 년, 월이 변경 되었을때, 해당 년, 월이 가지고 있는 '일'수가 다르기 때문에 업데이트 진행
                dataSource = dataSourceGenerator()
            }
            pastSelectedDate = currentSelectedDate
        }
    }
    
    var dataSource: [[String]] = []
    
    init(type: PickerViewType, _ selectedDate: SelectedDate? = nil) {
        self.type = type
        self.currentSelectedDate = selectedDate ?? ("\(Date().year)", "\(Date().month)", "\(Date().day)")
        self.dataSource = dataSourceGenerator()
    }
    
    deinit {
        Log.d("> PickerViewModel Deinit.")
    }
    
    /// PickerView를 구성할 DataSources를 생성합니다.
    private func dataSourceGenerator() -> [[String]] {
        /// 선택된 년도와 월에 대한 String값을 가지고, 새롭게 만들어진 Date
        let newDate = (currentSelectedDate.year + "-" + currentSelectedDate.month + "-" + "01" + " 08:00:00").toDate() ?? Date()
        switch type {
        case .calendar:
            return [
                Array(2019 ... 2022).map { "\($0)" },
                ["년"],
                Array(1 ... 12).map(makeTwoDigits),
                ["월"],
                Array(newDate.startOfMonth().day ... newDate.endOfMonth().day)
                    .map { $0 < 10 ? "0" + "\($0)" : "\($0)" },
                ["일"]
            ]
        case .hour24:
            return [
                ["오전", "오후"],
                Array(0 ... 11).map(makeTwoDigits),
                [":"],
                Array(0 ... 59).map(makeTwoDigits)
            ]
        case .hour12:
            return [
                Array(0 ... 11).map(makeTwoDigits),
                ["시"],
                Array(0 ... 59).map(makeTwoDigits),
                ["분"]
            ]
        case .minute5:
            return [
                ["5분 후 부터"],
                Array(0 ... 11).map(makeTwoDigits),
                ["시간"],
                Array(0 ... 59).map(makeTwoDigits),
                ["분 동안"]
            ]
        }
    }
    
    /// PickerView에서 .calendar 타입일때, 년도 또는 월에 대한 정보가 변경 되었을때 selectedDate를 업데이트합니다.
    func updateSelectedDate(component: Int, row: Int) {
        if component == 0 {
            currentSelectedDate.year = dataSource[component][row]
        } else if component == 2 {
            currentSelectedDate.month = dataSource[component][row]
        } else if component == 4 {
            currentSelectedDate.day = dataSource[component][row]
        }
    }
    
    /// ex) 3시 -> 03시, 3월 -> 03월로 자릿수를 만들어 줍니다.
    private func makeTwoDigits(_ num: Int) -> String {
        return num < 10 ? "0" + "\(num)" : "\(num)"
    }
    /// 년,월,일 중 '일'이 변경 되었는지 체크합니다.
    private func isDayChange() -> Bool {
        return pastSelectedDate.day != currentSelectedDate.day ? true : false
    }
}
