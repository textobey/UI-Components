//
//  RxCocoaTraitsViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RxCocoaTraitsViewController: UIBaseViewController {
    
    private let disposeBag = DisposeBag()
    
    let driverInterval = Driver<Int>.interval(.seconds(3))
    
    let signalInterval = Signal<Int>.interval(.seconds(3))
    
    lazy var driverButton = UIButton(type: .system).then {
        $0.setTitle("Driver 추가 구독 시작", for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.6).cgColor
    }
    
    lazy var signalButton = UIButton(type: .system).then {
        $0.setTitle("Signal 추가 구독 시작", for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.6).cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "RxCocoaTraits_Tests")
        setupLayout()
        bindRx()
    }
    
    private func setupLayout() {
        addSubview(driverButton)
        driverButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-32)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(32)
        }
        
        addSubview(signalButton)
        signalButton.snp.makeConstraints {
            $0.top.equalTo(driverButton.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(32)
        }
    }
    
    // Driver를 추가 구독했을때, interval(.seconds(3))에 의해
    // 다음 Event가 Emit 되기 이전이라도 .share(repay: 1)로 인하여 가장 최근 1개의 값을 출력하는걸 확인할수있음
    private func 드라이버추가구독시작() {
        driverInterval
            .drive(onNext: { count in
                print("Extend Driver Count is: \(count)")
            })
            .disposed(by: disposeBag)
    }
    
    // Signal을 추가 구독했을때, interval(.seconds(3))에 의해
    // 다음 Event가 Emit 되기 이전까지 print 구문이 출력되지 않는걸 확인할수있음
    private func 시그널추가구독시작() {
        signalInterval
            .emit(onNext: { count in
                print("Extend Signal Count is: \(count)")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindRx() {
        driverInterval
            .drive(onNext: { count in
                print("Origin Driver Count is: \(count)")
            })
            .disposed(by: disposeBag)
        
        signalInterval
            .emit(onNext: { count in
                print("Origin Signal Count is: \(count)")
            })
            .disposed(by: disposeBag)
        
        driverButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.드라이버추가구독시작()
            })
            .disposed(by: disposeBag)
        
        signalButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.시그널추가구독시작()
            })
            .disposed(by: disposeBag)
    }
}
