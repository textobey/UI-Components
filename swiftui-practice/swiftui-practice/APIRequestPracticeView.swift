//
//  APIRequestPracticeView.swift
//  swiftui-practice
//
//  Created by 이서준 on 2021/09/30.
//

import SwiftUI

struct APIRequestPracticeView: View {
    @ObservedObject var viewModel: APIRequestPracticeViewModel

    var body: some View {
        //ZStack {
            VStack {
                VStack {
                    Text(viewModel.switching((viewModel.weatherResponse?.weather?.first?.main ?? "Clear")))
                    Text("\(viewModel.weatherResponse?.main?.temp ?? 30)" + "도")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    Text(viewModel.weatherResponse?.name ?? "error")
                        .foregroundColor(.white)
                }
            }
            .onAppear(perform: {
                viewModel.apply(.appear)
            })
            .padding()
            .font(.largeTitle)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        //}
    }
}
