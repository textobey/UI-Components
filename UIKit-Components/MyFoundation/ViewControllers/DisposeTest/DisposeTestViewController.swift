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

    }
    
    func printString() {
        print("yoyoyoyo")
    }
}

//case1: 일반적인 Cold Observable 생성 후 subscribe -> Disposable 생성, dispose 처리 안함
//result: Instruments를 활용한 메모리누수 확인
//Observable<String>.create({ observer in
//    observer.onNext("method: memoryLeakDisposable")
//    return Disposables.create()
//}).subscribe(
//    onNext: { event in
//        print(event)
//    },
//    onError: { print($0) },
//    onCompleted: { print("Completed") },
//    onDisposed: { print("Disposed") }
//)

//case2: Disposable 와일드카드패턴을 활용한 unuse 처리
//result: Instruments를 활용한 메모리누수 확인
//_ = Observable<String>.create({ observer in
//    observer.onNext("method: memoryLeakDisposable")
//    return Disposables.create()
//}).subscribe(
//    onNext: { event in
//        print(event)
//    },
//    onError: { print($0) },
//    onCompleted: { print("Completed") },
//    onDisposed: { print("Disposed") }
//)

//case3: take(1) 오퍼레이터를 활용하여 1회의 이벤트 발생만을 보장하는 방식
//result: 메모리누수 발생하지 않음
//Observable<String>.create({ observer in
//    observer.onNext("method: memoryLeakDisposable 1")
//    observer.onNext("method: memoryLeakDisposable 2")
//    return Disposables.create()
//}).take(1).subscribe(
//    onNext: { event in
//        print(event)
//    },
//    onError: { print($0) },
//    onCompleted: { print("Completed") },
//    onDisposed: { print("Disposed") }
//)

//case4: Disposable 타입 프로퍼티를 선언하여 Disposable을 저장/관리하는 방식
//result: 메모리누수 발생하지 않음
//var disposable: Disposable?
//
//disposable?.dispose()
//disposable = Observable<String>.create({ observer in
//    observer.onNext("method: memoryLeakDisposable")
//    // observer.onError(MyError.anError)
//    // observer.onCompleted()
//    return Disposables.create()
//}).subscribe(
//    onNext: { event in
//        print(event)
//    },
//    onError: { print($0) },
//    onCompleted: { print("Completed") },
//    onDisposed: { print("Disposed") }
//)

//case5: CompositeDisposable 타입 프로퍼티를 선언하여 Disposable을 저장/관리하는 방식
//result: 메모리누수 발생하지 않음
//let compositeDisposable = CompositeDisposable()
//
//let disposable = Observable<String>.create({ observer in
//    observer.onNext("method: memoryLeakDisposable")
//    return Disposables.create()
//}).subscribe(
//    onNext: { event in
//        print(event)
//    },
//    onError: { print($0) },
//    onCompleted: { print("Completed") },
//    onDisposed: { print("Disposed") }
//)
//disposeKey를 저장해두면 compositeDisposable에서 관리중인 특정 disposable만 콕 찝어 관리하는것이 가능한 장점
//let disposeKey = compositeDisposable.insert(disposable)

