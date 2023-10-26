//
//  DisposeTestService.swift
//  MyFoundation
//
//  Created by 이서준 on 10/26/23.
//

import Foundation
import RxSwift
import RxCocoa

class DisposeTestService {
    
    static let shared = DisposeTestService()
    
    func createNeverEndingObservable() -> Observable<String> {
        return Observable.create { observer in
            observer.onNext("Event 1")
            observer.onNext("Event 2")
            observer.onNext("Event 3")
            
            return Disposables.create()
        }
    }
    
    // fetchImageResources는 onCompleted/onError 이벤트가 방출되기 때문에 메모리 누수가 발생하지 않음.
    func notMemoryLeakDisposable() {
        RandomImageLoader.shared.fetchImageResources()
            .subscribe(onNext: { randomImages in
                print("Image download Completed!!")
            })
    }
    
    func takeOnceDisposable() {
        _ = RandomImageLoader.shared.fetchImageResources()
            .take(1)
            .subscribe(onNext: { randomImages in
                print("Image download Completed!!")
            })
    }
    
    func useDisposable() {
        //disposable?.dispose()
        var disposable: Disposable?
        
        let imageDisposable = RandomImageLoader.shared.fetchImageResources()
            .subscribe(onNext: { randomImages in
                //print(randomImages)
                print("Image download Completed!!")
                disposable?.dispose()
            })
        
        disposable = imageDisposable
    }
    
    func useCompositeDisposable() {
        let compositeDisposable = CompositeDisposable()
        
        let disposable = RandomImageLoader.shared.fetchImageResources()
            .subscribe(onNext: { randomImages in
                //if (conditionalExpression) {
                //    compositeDisposable.dispose()
                //}
                print(randomImages)
                compositeDisposable.dispose()
            })
        
        _ = compositeDisposable.insert(disposable)
    }
}

//var disposable: Disposable?

//let compositeDisposable = CompositeDisposable()
