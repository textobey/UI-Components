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

class NetworkTestViewController: UIBaseViewController {
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "NetworkTest")
        requestCurrentWeahterAPI()
    }
    
    func requestCurrentWeahterAPI() {
        getCurrentWeather(lat: "37.48119118657402", lon: "126.88432643360242")
            .asObservable()
            .subscribe(onNext: { model in
                print(model)
            }).disposed(by: disposeBag)
    }
    
    func getCurrentWeather(lat: String, lon: String) -> Single<CurrentWeather> {
        return API.currentWeather(lat: lat, lon: lon).request()
    }
}
