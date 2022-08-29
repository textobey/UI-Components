//
//  ServiceFactory.swift
//  SOLID
//
//  Created by 이서준 on 2022/08/18.
//

import Foundation

// Service도 추상팩토리(프로토콜) 이기때문에, 추상 팩토리끼리 의존성
protocol ServiceFactory {
    func makeService() -> Service
}
