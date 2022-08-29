//
//  Application_ApplyFactory.swift
//  SOLID
//
//  Created by 이서준 on 2022/08/18.
//

import Foundation

// 핵심체인 Application에서는 모두 추상팩토리(protocol에만 의존)
class Application_ApplyFactory {
    let serviceFactory: ServiceFactory
    var service: Service?
    
    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
        service = makeService()
    }
    
    func makeService() -> Service {
        return serviceFactory.makeService()
    }
}

let serviceContrete = ServiceConcrete_ApplyFactory()
let application = Application_ApplyFactory(serviceFactory: serviceContrete)
