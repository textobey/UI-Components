//
//  DetailView.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/07.
//

import SwiftUI
import RxFlow
import RxSwift
import RxCocoa
import Combine

struct DetailView: View {
    @ObservedObject var viewModel = DetailViewModel()
    var steps = PublishRelay<Step>()
    let weather: ListModel
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text(weather.weather!.first!.switching())
                    Text("\(weather.main?.temp ?? 30)" + "도")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    Text(weather.name ?? "error")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .font(.largeTitle)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
    }
}
