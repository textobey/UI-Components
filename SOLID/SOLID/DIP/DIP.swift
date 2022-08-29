//
//  DIP.swift
//  SOLID
//
//  Created by 이서준 on 2022/08/18.
//

import Foundation

/*
 
 jake의 iOS앱 개발 알아가기(https://ios-development.tistory.com/710?category=1008271%5C)
 
 의존성 역전 원칙. DIP(Dependency Inversion Principle
 개념: 핵심 부분을 담당하는 모듈의 제어흐름과 다른 모듈들의 의존 방향이 반대
 방법: 변동성이 큰 구현체에 의존하지 않고, 추상 클래스에서만 의존해야 한다는 정의
    interface(protocol)는 구현체보다 변동성이 낮은점을 이용
 
 DIP를 이용한 코드의 장점:

 변경되기 쉬운것에 의존하지 않기 때문에, 변경이 잦아도 코드에서 변경해야할 부분이 적은 장점
 testable한 코드 작성에 용이: 핵심체는 protocol에만 의존하기 때문에 protocol의 구현체를 갈아끼워, testable 코드 작성에 용이
 
 */
