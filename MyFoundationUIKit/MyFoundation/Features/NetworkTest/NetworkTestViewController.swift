//
//  NetworkTestViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/19.
//

import UIKit
import Moya

class NetworkTestViewController: UIBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "NetworkTest")
        requestCurrentWeahterAPI()
    }
    
    func requestCurrentWeahterAPI() {
        let provider = MoyaProvider<API>()
        provider.request(.currentWeather(lat: "37.48119118657402", lon: "126.88432643360242")) { result in
            switch result {
            case .success(let response):
                let result = try? response.map(CurrentWeather.self)
                print("CurrentWeather is\n", result!)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
