//
//  RxOperation+.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/21.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func mapVoid() -> Observable<Void> {
        self.map { _ in Void() }
    }
}
