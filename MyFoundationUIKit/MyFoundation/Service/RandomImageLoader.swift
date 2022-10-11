//
//  RandomImageLoader.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/07.
//

import UIKit
import Alamofire
import Kingfisher

class RandomImageLoader {
    static let `shared`: RandomImageLoader = RandomImageLoader()
    
    private let baseURL: String = "https://picsum.photos/v2/list?page=2&limit="//100"
    
    func fetchImageResource(completionHandler: @escaping ([RandomImage]?) -> Void) -> UIImage {
        AF.request(
            makeEndPoint(from: 1),
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
        
        return UIImage()
    }
    
    func fetchImageResources(count: Int, completionHandler: @escaping ([RandomImage]?) -> Void) {
        AF.request(
            makeEndPoint(from: count),
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
    
    private func makeEndPoint(from necessaryCount: Int) -> String {
        return baseURL + String(necessaryCount)
    }
}
