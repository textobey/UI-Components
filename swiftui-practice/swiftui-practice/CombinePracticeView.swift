//
//  CombinePracticeView.swift
//  swiftui-practice
//
//  Created by 이서준 on 2021/09/29.
//

import SwiftUI

struct CombinePracticeView: View {
    @ObservedObject var viewModel: CombinePracticeViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.labelText ?? "Practice")
            Spacer()
            List(0 ..< 5) { index in
                HStack {
                    Image(systemName: "star")
                    Text("Hello World!")
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.apply(.didTap(index: index))
                }
            }
            .alert(isPresented: $viewModel.isErrorShown) { () -> Alert in
                Alert(title: Text("Error"), message: Text("Error"))
            }
        }
    }
}
