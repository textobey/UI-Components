//
//  RandomImageLoader.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/07.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Kingfisher

class RandomImageLoader {
    static let `shared`: RandomImageLoader = RandomImageLoader()
    
    private let baseURL: String = "https://picsum.photos"
    
    func fetchImageResources(
        count: Int = 10,
        page: Int = 1,
        completionHandler: @escaping ([RandomImage]?) -> Void
    ) {
        guard let url = makeURL(count: count, page: page) else {
            completionHandler(nil)
            return
        }
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: ["Content-Type":"application/json"]
        )
        .validate(statusCode: 200 ..< 300)
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let randomImages = try JSONDecoder().decode([RandomImage].self, from: data)
                    completionHandler(randomImages)
                } catch {
                    print(error.localizedDescription)
                    completionHandler(nil)
                }
            case .failure(let error):
                print("failure jsonParse: \(error)")
                completionHandler(nil)
            }
        }
    }
    
    func fetchImageResources(
        count: Int = 10,
        page: Int = 1
    ) -> Observable<[RandomImage]> {
        return Observable<[RandomImage]>.create { [weak self] observer in
            guard let url = self?.makeURL(count: count, page: page) else {
                observer.on(.error(URLError(.badURL)))
                return Disposables.create()
            }
            
            let request = AF.request(
                url,
                method: .get,
                parameters: nil,
                encoding: URLEncoding.default,
                headers: ["Content-Type":"application/json"]
            )
            .validate(statusCode: 200 ..< 300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let randomImages = try JSONDecoder().decode([RandomImage].self, from: data)
                        observer.on(.next(randomImages))
                        observer.on(.completed)
                    } catch {
                        print(error.localizedDescription)
                        observer.on(.error(error))
                    }
                case .failure(let error):
                    print("failure jsonParse: \(error)")
                    observer.on(.error(error))
                }
            }
            
            return Disposables.create()
            
            //return Disposables.create {
            //    request.cancel()
            //}
        }
    }
    
    private func makeURL(count: Int, page: Int) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path = "/v2/list"
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(count)")
        ]
        return components?.url
    }
}
