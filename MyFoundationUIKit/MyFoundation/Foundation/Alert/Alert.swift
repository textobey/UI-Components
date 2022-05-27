//
//  Alert.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/08.
//

import UIKit

class Alert<T: UIView> {
    fileprivate let title: String
    fileprivate let contentModel: AlertContentModel<T>?

    fileprivate var configureBlock: ((Alert, T) -> Void)?
    fileprivate var actions: [AlertAction<T>] = [AlertAction<T>]()

    init(title: String, _ contentModel: AlertContentModel<T>? = nil) {
        self.title = title
        self.contentModel = contentModel
    }

    func configure(_ configureBlock: ((Alert, T) -> Void)?) -> Self {
        self.configureBlock = configureBlock
        return self
    }

    func add(action title: String, autoDismiss: Bool = true, handler: ((T) -> Void)? = nil) -> Self {
        let action = AlertAction(
            title: title,
            autoDismiss: autoDismiss,
            handler: handler,
            shouldDismissBlock: nil,
            didnotDismissPerformBlock: nil
        )
        actions.append(action)
        return self
    }
    
    func show() {
        let alertController = AlertController()
        alertController.delegate = self
        alertController.dataSource = self
        AlertPresenter.shared.present(alert: alertController)
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        AlertPresenter.shared.dismiss(completion: completion)
    }
}
 
struct AlertContentModel<T: UIView> {
    let contentView: T
}

struct AlertAction<T: UIView> {
    let title: String
    let autoDismiss: Bool
    let handler: ((T) -> Void)?
    let shouldDismissBlock: ((T) -> Bool)?
    let didnotDismissPerformBlock: ((T) -> Void)?
}

extension Alert: AlertControllerDelegate {
    func alertControllerAlertType(_ alertController: AlertController) -> UIView.Type {
        return T.self
    }
    
    func alertControllerClose(_ alertController: AlertController) {
        return dismiss()
    }
    func alertController(_ alertController: AlertController, didSelectActionButtonAtIndex index: Int) {
        let contentView = contentModel?.contentView ?? T.self.init()
        let handler = actions[index].handler
        let autoDismiss = actions[index].autoDismiss
        if autoDismiss {
            dismiss {
                handler?(contentView)
            }
        } else {
            if let shouldDismiss = actions[index].shouldDismissBlock {
                if shouldDismiss(contentView) {
                    dismiss {
                        handler?(contentView)
                    }
                } else {
                    actions[index].didnotDismissPerformBlock?(contentView)
                }
            } else {
                handler?(contentView)
            }
        }
    }
    func alertControllerAlertView(_ alertController: AlertController) -> UIView? {
        return contentModel?.contentView
    }
}

extension Alert: AlertControllerDataSource {
    func alertControllerNumberOfActions(_ alertController: AlertController) -> Int {
        return actions.count
    }
    func alertControllerTitleString(_ alertController: AlertController) -> String {
        return title
    }
    func alertController(_ alertController: AlertController, actionTitleForIndex index: Int) -> String {
        return actions[index].title
    }
}
