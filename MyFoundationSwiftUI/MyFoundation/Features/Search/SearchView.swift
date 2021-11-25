//
//  SearchView.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/19.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        VStack {
            NavigationBar(navigationBarType: .back_leadingTitle, title: "검색")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(false)
                .navigationBarTitle("", displayMode: .inline)
            
            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
