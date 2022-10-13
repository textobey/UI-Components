//
//  API+NetworkErrorRx.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/26.
//

import Moya
import RxMoya
import RxSwift
import Foundation

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func filter500StatusCode() -> Single<Element> {
        return flatMap { response in
            guard response.statusCode != 500 else {
                throw MoyaError.statusCode(response)
            }
            return .just(response)
        }
    }
    
    /*
    func filterError() -> Observable<Result<Response, APIError>> {
        return self.asObservable()
            .map { response -> Result<Response, APIError> in
                switch response.statusCode {
                case 200 ... 300:
                    return .success(response)
                case 400 ... 500:
                    return .failure(.apiError(statusCode: response.statusCode))
                default:
                    return .failure(.apiError(statusCode: 0))
                }
            }
    }
    */
}
