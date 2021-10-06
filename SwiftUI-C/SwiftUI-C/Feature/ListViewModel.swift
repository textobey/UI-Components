//
//  ListViewModel.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/05.
//

import Foundation
import Combine
import SwiftUI

final class ListViewModel: ObservableObject {
    @Published var weathers: Find?
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        bindInputs()
        bindOutputs()
    }
    
    deinit {
        bag.removeAll()
    }
    
    enum Input {
        case getWeatherList
    }
    
    private let getWeatherListSubject = PassthroughSubject<Void, Never>()
    private let weatherListSubject = PassthroughSubject<Find, Never>()
    
    func apply(_ input: Input) {
        switch input {
        case .getWeatherList:
            getWeatherListSubject.send(())
        }
    }
    
    func bindInputs() {
        getWeatherListSubject
            .sink(receiveValue: requestWeatherAPI)
            .store(in: &bag)
    }
    
    func bindOutputs() {
        weatherListSubject
            .compactMap { $0 }
            .assign(to: \.weathers, on: self)
            .store(in: &bag)
    }
    
    private func requestWeatherAPI() {
        APIService.shared.weathers(completionHandler: { [weak self] weather, error in
            DispatchQueue.main.async {
                if let weather = weather {
                    print(weather)
                    self?.weatherListSubject.send(weather)
                }
            }
        })
    }
}
