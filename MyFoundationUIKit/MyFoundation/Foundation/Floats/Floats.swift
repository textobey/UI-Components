//
//  Floats.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/27.
//

import UIKit

class Floats<T: UIView> {
    //fileprivate let title: String
    fileprivate let contentModel: FloatsContentModel<T>?

    fileprivate var configureBlock: ((Floats, T) -> Void)?
    //fileprivate var actions: [AlertAction<T>] = [AlertAction<T>]()

    //init(title: String, _ contentModel: FloatsContentModel<T>? = nil) {
    //    self.title = title
    //    self.contentModel = contentModel
    //}
    
    init(_ contentModel: FloatsContentModel<T>? = nil) {
        self.contentModel = contentModel
    }

    func configure(_ configureBlock: ((Floats, T) -> Void)?) -> Self {
        self.configureBlock = configureBlock
        return self
    }

    //func add(action title: String, autoDismiss: Bool = true, handler: ((T) -> Void)? = nil) -> Self {
    //    let action = AlertAction(
    //        title: title,
    //        autoDismiss: autoDismiss,
    //        handler: handler,
    //        shouldDismissBlock: nil,
    //        didnotDismissPerformBlock: nil
    //    )
    //    actions.append(action)
    //    return self
    //}
    
    @discardableResult
    func show() -> Bool {
        let floatsController = FloatsController()
        //alertController.delegate = self
        //alertController.dataSource = self
        AlertPresenter.shared.present(alert: floatsController)
        defer { autoDismiss() }
        return true
    }
    
    private func autoDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.dismiss(completion: nil)
        })
    }
    
    @objc
    func dismiss(completion: (() -> Void)? = nil) {
        AlertPresenter.shared.dismiss(completion: completion)
    }
}
 
struct FloatsContentModel<T: UIView> {
    let contentView: T
}

/*struct AlertAction<T: UIView> {
    let title: String
    let autoDismiss: Bool
    let handler: ((T) -> Void)?
    let shouldDismissBlock: ((T) -> Bool)?
    let didnotDismissPerformBlock: ((T) -> Void)?
}*/
