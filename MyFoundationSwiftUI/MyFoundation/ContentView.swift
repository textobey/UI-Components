//
//  ContentView.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/19.
//

import SwiftUI

struct ContentView: View {
    enum Tab: String {
        case home = "Home"
        case search = "Search"
        case more = "More"
    }
    @State private var selection: Tab = .home
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                HomeView().tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }.tag(Tab.home)
                
                SearchView().tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }.tag(Tab.search)
                
                MoreView().tabItem {
                    Image(systemName: "ellipsis")
                    Text("More")
                }.tag(Tab.more)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("", displayMode: .inline)
            .edgesIgnoringSafeArea([.top])
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
