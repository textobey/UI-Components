//
//  HalfModalViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/18.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class HalfModalViewController: UIViewController {
    private let disposeBag = DisposeBag()
    let dismissTrigger = PublishRelay<Void>()
    let contentViewHeightRelay = PublishRelay<CGFloat>()
    
    private(set) var halfModalPresentationController: HalfModalPresentationController?

    weak var sendDelegate: HalfModalViewControllerSendDelegate?

    let dataSource: [Any]

    let contentView: HalfModalView

    let contentTitle: String

    let titleWrapperView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    lazy var titleLabel = UILabel().then {
        $0.text = contentTitle
        $0.textColor = .black
        $0.backgroundColor = .white
        $0.textAlignment = .left
    }

    lazy var close = UIButton().then {
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.rx.tap.bind(to: dismissTrigger).disposed(by: disposeBag)
    }

    init(title: String?, contentView: HalfModalView, dataSource: [Any]) {
        self.contentView = contentView
        self.contentTitle = title ?? .empty
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        self.contentView.dataSources = dataSource
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupLayout()
        bindRx()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentViewHeightRelay.accept(contentView._scrollContainerViewHeight)
    }

    private func setupLayout() {
        view.addSubview(titleWrapperView)
        titleWrapperView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(58)
        }
        titleWrapperView.addSubview(close)
        close.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(21)
        }
        titleWrapperView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(close)
            $0.leading.equalTo(close.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-24)
        }

        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(titleWrapperView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func bindRx() {
        contentView.outputRelay.withUnretained(self)
            .do(onNext: { $0.0.dismissTrigger.accept(()) })
            .map { $0.0.sendDelegate?.sendHalfModalViewControllerAction(action: $0.1) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension HalfModalViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let halfModalPresentationController = HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
        contentViewHeightRelay.bind(to: halfModalPresentationController.initOriginYRelay).disposed(by: disposeBag)
        return halfModalPresentationController
    }
}

class HalfModalView: UIView {
    var outputRelay = PublishRelay<OutputActionType>()
    
    // required
    private(set) var _scrollView = UIScrollView()
    
    private(set) var _scrollContainerViewHeight: CGFloat = 0
    
    var dataSources: [Any] = [] {
        didSet {
            updateLayout()
        }
    }

    func updateLayout() {
    }

    enum OutputActionType {
        case dismiss
        case button
        //case other..
    }
}

class HalfModalPanningView: UIView { }

protocol HalfModalViewControllerSendDelegate: AnyObject {
    func sendHalfModalViewControllerAction(action: HalfModalView.OutputActionType)
}
