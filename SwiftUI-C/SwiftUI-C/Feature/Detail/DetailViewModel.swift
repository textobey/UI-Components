//
//  DetailViewModel.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/07.
//

import Foundation
import Combine
import SwiftUI

final class DetailViewModel: ObservableObject {
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
    
    func apply(_ input: Input) {
        
    }
    
    func bindInputs() {
        
    }
    
    func bindOutputs() {
        
    }
    
    private func requestWeatherAPI() {

    }
}
