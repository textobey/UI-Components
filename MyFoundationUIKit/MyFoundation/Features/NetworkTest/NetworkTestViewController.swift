//
//  NetworkTestViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/19.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

struct TestModel: Decodable {
    let lat: String
    let lon: String
}

class NetworkTestViewController: UIBaseViewController {
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "NetworkTest")
        requestCurrentWeahterAPI()
    }
    
    func requestCurrentWeahterAPI() {
            
        /*
        API.currentWeather(lat: "37.48119118657402", lon: "126.88432643360242")
            .request()
            .map {
                guard let value = try $0.mapString().data(using: .utf8) else { return $0 }
                let newResponse = Response(
                    statusCode: $0.statusCode,
                    data: value,
                    request: $0.request,
                    response: $0.response
                )
                return newResponse
            }
            .map(CurrentWeather.self, using: API.jsonDecoder)
            .asObservable()
            .bind(onNext: { element in
                print(element)
            }).disposed(by: disposeBag)
        */

        /*let provider = MoyaProvider<API>()
        provider.request(.currentWeather(lat: "37.48119118657402", lon: "126.88432643360242")) { result in
            switch result {
            case .success(let response):
                let result = try? response.map(CurrentWeather.self)
                print("CurrentWeather is\n", result!)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }*/
    }
}
