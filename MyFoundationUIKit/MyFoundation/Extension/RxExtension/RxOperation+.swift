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

extension ObservableType {
    func withPrevious() -> Observable<(Element?, Element)> {
      return scan([], accumulator: { (previous, current) in
          Array(previous + [current]).suffix(2)
        })
        .map({ (arr) -> (previous: Element?, current: Element) in
          (arr.count > 1 ? arr.first : nil, arr.last!)
        })
    }
    //func withPrevious(startWith first: Element) -> Observable<(Element, Element)> {
    //    return scan((first, first)) { ($0.1, $1) }.skip(1)
    //}
}

