//
//  Application_NotFactory.swift
//  SOLID
//
//  Created by 이서준 on 2022/08/18.
//

import Foundation

// 핵심체인 Application에서 구현체에 의존하는 상태
class Application_NotFactory {
    var service: ServiceConcrete_NotFactory?
    
    init() {
        service = makeService()
    }
    
    /// 구현체에 의존하는 상태
    func makeService() -> ServiceConcrete_NotFactory {
        return ServiceConcrete_NotFactory()
    }
}
