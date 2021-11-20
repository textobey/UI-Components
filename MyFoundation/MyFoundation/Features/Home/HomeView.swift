//
//  HomeView.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/19.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            NavigationBar(navigationBarType: .centerTitle_trailingItems, title: "Title", trailingItems: {
                NavigationLink(destination: SearchView(), label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color.black.opacity(0.1))
                        .clipShape(Circle())
                })
                
            })
            
            Spacer()
            
            Text("HomeView")
                .font(Font.notoSans(size: 21, style: .bold))
                .frame(alignment: .center)
            
            Spacer()
        }
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
