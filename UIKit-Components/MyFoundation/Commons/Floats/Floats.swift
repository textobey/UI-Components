//
//  Floats.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/27.
//

import UIKit

class FloatsView: UIView {
    
    private lazy var popupView: ShadowView = {
        let model = ShadowView.ShadowComponent(color: #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1), alpha: 0.12, x: 0, y: 3, blur: 14, spread: 2)
        let shadowView = ShadowView(model: model)
        shadowView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9)
        return shadowView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            //$0.width.equalTo(UIScreen.main.bounds.size.width)
            $0.height.equalTo(108)
        }
    }
}

class TextFloatsView: UIView {
    let thumbnail = UIImageView().then {
        $0.image = UIImage(systemName: "bookmark.fill")
        $0.tintColor = .yellow
    }
    
    let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.textAlignment = .center
        $0.font = UIFont.notoSans(size: 14, style: .bold)
    }
    
    let subtitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = #colorLiteral(red: 0.4352941176, green: 0.4352941176, blue: 0.4352941176, alpha: 1)
        $0.textAlignment = .center
        $0.font = UIFont.notoSans(size: 14, style: .medium)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(thumbnail)
        thumbnail.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(14)
            $0.height.equalTo(28)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnail.snp.trailing).offset(12)
            $0.bottom.equalTo(thumbnail.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnail.snp.centerY)
            $0.leading.equalTo(thumbnail.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
        }
    }
}



/*class Floats<T: UIView> {
    fileprivate let title: String
    fileprivate let contentModel: FloatsContentModel<T>?

    fileprivate var configureBlock: ((Floats, T) -> Void)?
    //fileprivate var actions: [AlertAction<T>] = [AlertAction<T>]()

    init(title: String, _ contentModel: FloatsContentModel<T>? = nil) {
        self.title = title
        self.contentModel = contentModel
    }
    
    //init(_ contentModel: FloatsContentModel<T>? = nil) {
    //    self.contentModel = contentModel
    //}

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
    
    func show() {
        let floatsController = FloatsController()
        //alertController.delegate = self
        //alertController.dataSource = self
        AlertPresenter.shared.present(alert: floatsController)
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        AlertPresenter.shared.dismiss(completion: completion)
    }
}
 
struct FloatsContentModel<T: UIView> {
    let contentView: T
}*/

/*struct AlertAction<T: UIView> {
    let title: String
    let autoDismiss: Bool
    let handler: ((T) -> Void)?
    let shouldDismissBlock: ((T) -> Bool)?
    let didnotDismissPerformBlock: ((T) -> Void)?
}*/
