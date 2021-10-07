//
//  ListView.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/07.
//

import SwiftUI
import RxFlow
import RxSwift
import RxCocoa
import Combine

struct ListView: View {
    @ObservedObject var viewModel = ListViewModel()
    var steps = PublishRelay<Step>()
    
    var body: some View {
        List(viewModel.weathers?.list ?? []) { weather in
            Text(weather.name ?? "Error")
                .onTapGesture {
                    steps.accept(AppStep.detail(weather))
                }
        }.onAppear() {
            viewModel.apply(.getWeatherList)
        }
    }
}

