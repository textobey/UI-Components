//
//  Screen.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/22.
//

import UIKit

enum Screen: CaseIterable {
    case carousels
    case stickyHeader
    case alert
    case bottomSheet
    case newHot
    case textBox
    case standaloneNavigationBar
    case translucentPopup
    case popover
    case appStoreClone
    case stickyAlert
    case picker
    case dropDown
    case actionSheet
    case stretchScrollView
    case kingfisherTest
    case headerStack
    case compostionalCollection
    case sectionedTableView
    case instagramLive
    case uiLabelNewLineViewController
    case disposeTestViewController
    
    func getTitle() -> String {
        switch self {
        case .carousels:
            return "Carousels"
        case .stickyHeader:
            return "StickyHeader"
        case .alert:
            return "Alert"
        case .bottomSheet:
            return "BottomSheet"
        case .newHot:
            return "New&Hot(netflix)"
        case .textBox:
            return "TextBox"
        case .standaloneNavigationBar:
            return "StandaloneNavigationBar"
        case .translucentPopup:
            return "TranslucentPopup"
        case .popover:
            return "Popover"
        case .appStoreClone:
            return "AppStoreClone"
        case .stickyAlert:
            return "StickyAlert"
        case .picker:
            return "Picker"
        case .dropDown:
            return "Dropdown"
        case .actionSheet:
            return "ActionSheet"
        case .stretchScrollView:
            return "StretchScrollView"
        case .kingfisherTest:
            return "KingfisherClearMemoryTest"
        case .headerStack:
            return "HeaderStack"
        case .compostionalCollection:
            return "CompostionalCollection"
        case .sectionedTableView:
            return "SectionedTableView"
        case .instagramLive:
            return "InstagramLive_Clone"
        case .uiLabelNewLineViewController:
            return "UILabelNewLineTest"
        case .disposeTestViewController:
            return "DisposeTestView"
        }
    }
    
    func getInstance() -> UIViewController {
        switch self {
        case .carousels:
            return CarouselsViewController()
        case .stickyHeader:
            return StickeyHeaderViewController()
        case .alert:
            return AlertTestViewController()
        case .bottomSheet:
            return BottomSheetImplViewController()
        case .newHot:
            return NewHotViewController()
        case .textBox:
            return TextBoxViewController()
        case .standaloneNavigationBar:
            return StandaloneNavigationBarViewController()
        case .translucentPopup:
            return TranslucentPopupViewController()
        case .popover:
            return PopoverViewController()
        case .appStoreClone:
            return TodayViewController()
        case .stickyAlert:
            return StickyAlertTestViewController()
        case .picker:
            return PickerViewController()
        case .dropDown:
            return DropDownViewController()
        case .actionSheet:
            return ActionSheetViewController()
        case .stretchScrollView:
            return StretchScrollViewController()
        case .kingfisherTest:
            return KingfisherTestViewController()
        case .headerStack:
            return HeaderStackViewController()
        case .compostionalCollection:
            return CompostionalCollectionViewController()
        case .sectionedTableView:
            return SectionedTableViewController()
        case .instagramLive:
            return InstagramLiveViewController()
        case .uiLabelNewLineViewController:
            return UILabelNewLineViewController()
        case .disposeTestViewController:
            return DisposeTestViewController()
        }
    }
}
