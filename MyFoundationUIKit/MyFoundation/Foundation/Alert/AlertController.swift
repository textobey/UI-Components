//
//  AlertController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/08.
//

import UIKit
import SnapKit

class AlertController: UIViewController {
    var delegate: AlertControllerDelegate?
    var dataSource: AlertControllerDataSource?
    
    let transition: AlertTransition = AlertTransition()
    
    private lazy var popupView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
        $0.layer.cornerRadius = 12
    }
    
    lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    lazy var scrollContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        //$0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.itemSize = CGSize(width: (294 - 12) / 2, height: 40)
        $0.minimumLineSpacing = 12
        $0.minimumInteritemSpacing = 0
    }).then {
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.register(AlertActionCell.self, forCellWithReuseIdentifier: AlertActionCell.identifier)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = .clear
        modalPresentationStyle = .custom
        transitioningDelegate = transition
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(160)
            $0.width.equalTo(330)
        }
        
        popupView.addSubviews([scrollView, collectionView])
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.bottom.equalTo(collectionView.snp.top).offset(-14)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
        
        scrollView.addSubview(scrollContainerView)
        scrollContainerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().offset(-14)
            $0.height.equalTo(40)
        }
    }
    
    @objc func handleAlertAction(_ sender: UIButton) {
        delegate?.alertController(self, didSelectActionButtonAtIndex: sender.tag)
    }
}

extension AlertController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.alertControllerNumberOfActions(self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let actionCount = dataSource?.alertControllerNumberOfActions(self) ?? 0
        let title = dataSource?.alertController(self, actionTitleForIndex: indexPath.item) ?? .empty
        let identifier = AlertActionCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AlertActionCell
        cell.button.setTitle(title, for: .normal)
        cell.button.tag = indexPath.item
        cell.button.addTarget(self, action: #selector(handleAlertAction(_:)), for: .touchUpInside)
        return cell
    }
}
    

protocol AlertControllerDelegate {
    /// Alert에 X버튼을 눌렀을 때에 대한 이벤트입니다.
    func alertControllerClose(_ alertController: AlertController)
    /// 선택된 버튼 index에 따른 이벤트입니다.
    func alertController(_ alertController: AlertController, didSelectActionButtonAtIndex index: Int)
    /// alertController에 올려진 alertView를 반환합니다.
    func alertControllerAlertView(_ alertController: AlertController) -> UIView?
}

protocol AlertControllerDataSource {
    /// alert에 추가된 action의 개수를 반환합니다.
    func alertControllerNumberOfActions(_ alertController: AlertController) -> Int
    /// alert popup title을 반환합니다.
    func alertControllerTitleString(_ alertController: AlertController) -> String
    /// alert에 추가된 버튼(action)의 title을 반환합니다.
    func alertController(_ alertController: AlertController, actionTitleForIndex index: Int) -> String
}

/*
struct ContentView: View {
    @State private var showingAlert = false
    
    var body: some View {
        Button(action: {
            self.showingAlert = true
        }) {
            Text("Show Alert")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Title"),
                  message: Text("This is a alert message"),
                  dismissButton: .default(Text("Dismiss"))
            )
        }
    }
}
 */
