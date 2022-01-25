//
//  Screen.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/22.
//

import UIKit

enum Screen {
    case multipleTopTabBar
    case textBox
    case picker
    case dropDown
    case actionSheet
    case headerStack
    case compostionalCollection
    case standaloneNavigationBar
    case translucentPopup
    case sectionedTableView
    case stickyHeaderTableView
    case networkTest
    
    func getTitle() -> String {
        switch self {
        case .multipleTopTabBar:
            return "MultipleTopTabBar"
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
        case .stickyHeaderTableView:
            return "StickyHeaderTableView"
        case .networkTest:
            return "NetworkTest"
        }
    }
    func getInstance() -> UIViewController {
        switch self {
        case .multipleTopTabBar:
            return MultipleTopTabBarViewController()
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
        case .stickyHeaderTableView:
            return StickyHeaderTableViewController()
        case .networkTest:
            return NetworkTestViewController()
        }
    }
}