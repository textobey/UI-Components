//
//  ServiceConcrete_ApplyFactory.swift
//  SOLID
//
//  Created by 이서준 on 2022/08/18.
//

import Foundation

// 추상 팩토리를 구현 클래스가 팩토리 클래스
// 핵심체가 아닌 팩토리 클래스의 구현체에서는 다른 구현체 의존해도 무방
class ServiceConcrete_ApplyFactory: ServiceFactory {
    func makeService() -> Service {
        return ServiceConcreteImpl()
    }
}
