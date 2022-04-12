//
//  AlertPresenter.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/08.
//

import UIKit

enum OverlapMode {
    case queue //팝업을 queue에 쌓는다.
    case overlap //현재 떠있는 팝업 위에 띄우려는 팝업을 노출시킨다.
    case forceFirstStack //현재 떠있는 팝업을 내리고 queue에 첫번째로 저장, 띄우려는 팝업을 노출시킨다.
}

class AlertPresenter {
    static let shared: AlertPresenter = AlertPresenter()
    
    private var alreadyPresenting: Bool = false
    private var isOnKeyboardWindow: Bool = false
    
    private var alertWindow: ModalWindow?
    private var alertController: UIViewController?
    
    private var queue: [UIViewController] = [UIViewController]()
    
    func present(alert: UIViewController) {
        if alreadyPresenting {
            queue.append(alert)
        } else {
            self.alertWindow = ModalWindow(windowLevel: .statusBar + 2)
            self.alertController = alert
            self.alertWindow?.present(alert, animated: true)
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        alertController?.dismiss(animated: true) {
            self.alertController = nil
            self.alertWindow = nil
        }
    }
}
