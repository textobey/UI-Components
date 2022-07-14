//
//  UITableView+Rx.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/07/14.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    var indexPathsForVisibleRow: Observable<IndexPath?> {
        return Observable<IndexPath?>.create { observer in
            observer.on(.next(base.indexPathsForVisibleRows?.last))
            observer.on(.completed)
            return Disposables.create()
        }
    }
    
    var endUpdate: Observable<Void> {
        let endUpdates = sentMessage(#selector(base.endUpdates))
        return Observable.create { observer in
            let endUpdates = endUpdates.subscribe(onNext: { _ in
                observer.on(.next(()))
            })
            return Disposables.create([endUpdates])
        }
    }
    
    var reloaded: Observable<()> {
        let reloadData = sentMessage(#selector(base.reloadData))
        return Observable.create { observer in
            let reloadDataDisposable = reloadData.subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    observer.on(.next(()))
                }
            })
            return Disposables.create([reloadDataDisposable])
        }
    }
}
