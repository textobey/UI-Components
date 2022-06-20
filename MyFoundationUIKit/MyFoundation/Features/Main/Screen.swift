//
//  Screen.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/22.
//

import UIKit

enum Screen: CaseIterable {
    case tooltip
    case newHot
    case multipleTopTabBar
    case multipleTopTabBar2
    case textBox
    case picker
    case dropDown
    case actionSheet
    case headerStack
    case compostionalCollection
    case standaloneNavigationBar
    case translucentPopup
    case sectionedTableView
    case stickyHeader
    case networkTest
    case calendar
    case popover
    case alert
    case stickyAlert
    case halfModal
    case appStoreClone
    
    func getTitle() -> String {
        switch self {
        case .tooltip:
            return "Tooltip"
        case .newHot:
            return "New&Hot"
        case .multipleTopTabBar:
            return "MultipleTopTabBar"
        case .multipleTopTabBar2:
            return "MultipleTopTabBar2"
        case .textBox:
            return "TextBox"
        case .picker:
            return "Picker"
        case .dropDown:
            return "DropDown"
        case .actionSheet:
            return "ActionSheet"
        case .headerStack:
            return "HeaderStack"
        case .compostionalCollection:
            return "CompostionalCollection"
        case .standaloneNavigationBar:
            return "StandaloneNavigationBar"
        case .translucentPopup:
            return "TranslucentPopup"
        case .sectionedTableView:
            return "SectionedTableView"
        case .stickyHeader:
            return "StickyHeader"
        case .networkTest:
            return "NetworkTest"
        case .calendar:
            return "Calendar"
        case .popover:
            return "Popover"
        case .alert:
            return "Alert"
        case .stickyAlert:
            return "StickyAlert"
        case .halfModal:
            return "HalfModal"
        case .appStoreClone:
            return "AppStoreClone"
        }
    }
    func getInstance() -> UIViewController {
        switch self {
        case .tooltip:
            return TooltipTestViewController()
        case .newHot:
            return NewHotViewController()
        case .multipleTopTabBar:
            return MultipleTopTabBarViewController()
        case .multipleTopTabBar2:
            return MultipleTopTabBar2ViewController()
        case .textBox:
            return TextBoxViewController()
        case .picker:
            return PickerViewController()
        case .dropDown:
            return DropDownViewController()
        case .actionSheet:
            return ActionSheetViewController()
        case .headerStack:
            return HeaderStackViewController()
        case .compostionalCollection:
            return CompostionalCollectionViewController()
        case .standaloneNavigationBar:
            return StandaloneNavigationBarViewController()
        case .translucentPopup:
            return TranslucentPopupViewController()
        case .sectionedTableView:
            return SectionedTableViewController()
        case .stickyHeader:
            return StickeyHeaderViewController()
        case .networkTest:
            return NetworkTestViewController()
        case .calendar:
            return CalendarViewController()
        case .popover:
            return PopoverViewController()
        case .alert:
            return AlertTestViewController()
        case .stickyAlert:
            return StickyAlertTestViewController()
        case .halfModal:
            return HalfModalTestViewController()
        case .appStoreClone:
            return TodayViewController()
        }
    }
}
