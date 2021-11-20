//
//  NavigationBar.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/19.
//

import SwiftUI

enum NavigationBarType {
    case back                                      // 뒤로가기 버튼
    case leadingTitle                              // 왼쪽 타이틀
    case leadingItems                              // 왼쪽 아이템
    case leadingItems_centerTitle                  // 왼쪽 아이템 + 가운데 타이틀
    case leadingItems_trailingItems                // 왼쪽 아이템 + 오른쪽 아이템
    case leadingItems_centerTitle_trailingItems    // 왼쪽 아이템 + 가운데 타이틀 + 오른쪽 아이템
    case leadingTitle_trailingItems                // 왼쪽 타이틀 + 오른쪽 아이템
    case centerTitle                               // 가운데 타이틀
    case centerTitle_trailingItems                 // 가운데 타이틀 + 오른쪽 아이템
    case back_leadingTitle                         // 뒤로가기 버튼 + 왼쪽 타이틀
    case back_centerTitle                          // 뒤로가기 버튼 + 가운데 타이틀
    case back_leadingTitle_trailingItems           // 뒤로가기 버튼 + 왼쪽 타이틀 + 오른쪽 아이템
    case back_centerTitle_trailingItems            // 뒤로가기 버튼 + 가운데 타이틀 + 오른쪽 아이템
}

struct NavigationBar<LT: View, RT: View>: View {
    typealias NCM = NavigationControlManager
    
    let navigationBarType: NavigationBarType
    let title: String?
    let leadingItems: () -> LT?
    let trailingItems: () -> RT?
    
    init(navigationBarType: NavigationBarType,
         title: String? = "",
         @ViewBuilder leadingItems: @escaping () -> LT? = { nil },
         @ViewBuilder trailingItems: @escaping () -> RT? = { nil }) {
        self.navigationBarType = navigationBarType
        self.title = title
        self.leadingItems = leadingItems
        self.trailingItems = trailingItems
    }
    
    var body: some View {
        makeNavigationBar()
    }
    
    @ViewBuilder
    fileprivate func makeNavigationBar() -> some View {
        switch navigationBarType {
        case .back, .back_leadingTitle, .back_leadingTitle_trailingItems:
            VStack {
                HStack {
                    Button(action: {
                        print("backbutton Tapped!")
                        NCM.shared.popCurrentView()
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 10, height: 18, alignment: .leading)
                            .foregroundColor(.black)
                    }
                    .buttonStyle(StaticButtonStyle())
                    HStack {
                        Text(title!)
                            .foregroundColor(.black)
                            .font(Font.montserrat(size: 17))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.hidden(navigationBarType == .back)
                    
                    HStack {
                        trailingItems()
                    }
                    .hidden(navigationBarType != .back_leadingTitle_trailingItems)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding([.leading, .trailing], 12)
                .frame(height: 44, alignment: .center)
            }
            
        case .leadingTitle, .centerTitle:
            Text(title!)
                .foregroundColor(.black)
                .font(Font.montserrat(size: 21, style: .bold))
                .frame(width: UIScreen.main.bounds.size.width, height: 44, alignment: navigationBarType == .centerTitle ? .center : .leading)
                .padding(.leading, navigationBarType == .leadingTitle ? 12 : 0)
            
        case .leadingTitle_trailingItems, .centerTitle_trailingItems:
            ZStack {
                Text(title!)
                    .foregroundColor(.black)
                    .font(Font.montserrat(size: 21, style: .bold))
                    .padding(.leading, 12)
                    .frame(width: UIScreen.main.bounds.size.width, height: 44, alignment: navigationBarType == .centerTitle_trailingItems ? .center : .leading)
                
                HStack {
                    trailingItems()
                }
                .padding(.trailing, 12)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .top)

        case .leadingItems, .leadingItems_centerTitle, .leadingItems_centerTitle_trailingItems, .leadingItems_trailingItems:
            ZStack {
                HStack {
                    leadingItems()
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                Text(title!)
                    .foregroundColor(.black)
                    .font(Font.montserrat(size: 21, style: .bold))
                    .frame(height: 44, alignment: .center)
                    .hidden(navigationBarType == .leadingItems || navigationBarType == .leadingItems_trailingItems)
                
                trailingItems()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .hidden(navigationBarType == .leadingItems || navigationBarType == .leadingItems_centerTitle)
            }
            .padding([.leading, .trailing], 12)
            .frame(maxWidth: .infinity, alignment: .top)

        case .back_centerTitle, .back_centerTitle_trailingItems:
            ZStack {
                HStack {
                    Button(action: {
                        print("backbutton Tapped!")
                        NCM.shared.popCurrentView()
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 10, height: 18, alignment: .leading)
                            .foregroundColor(.black)
                    }
                    .buttonStyle(StaticButtonStyle())
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                Text(title!)
                    .foregroundColor(.black)
                    .font(Font.montserrat(size: 21, style: .bold))
                    .frame(height: 44, alignment: .center)
                
                HStack {
                    trailingItems()
                }
                .hidden(navigationBarType != .back_centerTitle_trailingItems)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding([.leading, .trailing], 12)
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }
}

extension NavigationBar where LT == EmptyView {
    init(navigationBarType: NavigationBarType, title: String? = "", @ViewBuilder trailingItems: @escaping () -> RT) {
        self.init(navigationBarType: navigationBarType,
                  title: title,
                  leadingItems: { EmptyView() },
                  trailingItems: trailingItems
        )
    }
}

extension NavigationBar where RT == EmptyView {
    init(navigationBarType: NavigationBarType, title: String? = "", @ViewBuilder leadingItems: @escaping () -> LT) {
        self.init(navigationBarType: navigationBarType,
                  title: title,
                  leadingItems: leadingItems,
                  trailingItems: { EmptyView() }
        )
    }
}

extension NavigationBar where RT == EmptyView, LT == EmptyView {
    init(navigationBarType: NavigationBarType, title: String? = "") {
        self.init(navigationBarType: navigationBarType,
                  title: title,
                  leadingItems: { EmptyView() },
                  trailingItems: { EmptyView() }
        )
    }
}

