//
//  DisposeTestViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 10/26/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DisposeTestViewController: UIBaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private var storage: String = "0" {
        didSet {
            print(storage)
        }
    }
    
    lazy var button = UIButton(type: .system).then {
        $0.setTitle("Image Download!", for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.6).cgColor
        $0.addTarget(self, action: #selector(memoryLeakDisposable), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Dispose Test")
        setupLayout()
    }
    
    deinit {
        print("DisposeTestViewController Deinit")
    }
    
    private func setupLayout() {
        addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(32)
        }
    }
    
    @objc func memoryLeakDisposable() {
        Observable<String>.create({ observer in
            observer.onNext("1")
            // observer.onError(MyError.anError)
            // observer.onCompleted()
            return Disposables.create()
        }).subscribe(
            onNext: { [weak self] num in
                self?.storage = num
                self?.printString()
            },
            onError: { print($0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Disposed") }
        )
        //DisposeTestService.shared.createNeverEndingObservable()
        //    .delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
        //    .subscribe(onNext: { element in
        //        print(element)
        //    })
    }
    
    func printString() {
        print("yoyoyoyo")
    }
}
