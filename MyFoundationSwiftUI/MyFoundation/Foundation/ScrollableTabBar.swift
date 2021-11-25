//
//  ScrollableTabBar.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/25.
//

import SwiftUI

/// 페이징 기능이 포함된 스크롤이 가능한 ScrollTabBar
struct ScrollableTabBar<Content: View>: UIViewRepresentable {
    var content: Content
    
    let scrollView = UIScrollView()
    
    // ScrollView의 width와 height를 계산하여 가져올 CGRect 값
    var rect: CGRect
    
    // ScrollView의 offset(x)를 저장할 변수
    @Binding var offset: CGFloat
    
    // Tabs..
    var tabs: [AnyHashable]
    
    init(tabs: [AnyHashable], rect: CGRect, offset: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._offset = offset
        self.rect = rect
        self.tabs = tabs
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        setupScrollView()
        // setting Content Size
        scrollView.contentSize = CGSize(width: rect.width * CGFloat(tabs.count), height: rect.height)
        scrollView.addSubview(extractView())
        scrollView.delegate = context.coordinator
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if uiView.contentOffset.x != offset {
            // ScrollView DidScroll이 animation을 2번 발생시키는 결함이 있기 때문에
            // updateUIView가 수행될때, delegate nil 상태로 만들고
            uiView.delegate = nil
            
            UIView.animate(withDuration: 0.4) {
                // 애니메이션 진행
                uiView.contentOffset.x = offset
            } completion: { status in
                // 완료되면 delegate 다시 설정
                if status {
                    uiView.delegate = context.coordinator
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    /// Setting ScrollView
    func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    /// Extracting SwiftUI View
    func extractView() -> UIView {
        // 탭 개수에 따라 frame 달라짐(ex. UIScreen...width * tab.count)
        let controller = UIHostingController(rootView: content)
        controller.view.frame = CGRect(x: 0, y: 0, width: rect.width * CGFloat(tabs.count), height: rect.height)
        return controller.view
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollableTabBar
        
        init(parent: ScrollableTabBar) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset.x
        }
    }
}

/// ScrollableTabBar의 Tab을 담당하는 View(+indicator)
struct TabBar: View {
    @Binding var offset: CGFloat
    @Binding var showCapsule: Bool
    @State var width: CGFloat = 0
    let tabs: [String]
    
    var body: some View {
        GeometryReader { proxy -> AnyView in
            // GeometryReader를 이용하여, 차지할수있는 width 값에서 tabs.count를 나누어 균등한 계산한 균등한 width값
            // + 후에 GUI 발행후에, 화면을 전부 채우지 않는 경우 + 화면을 넘어가서 스크롤로 채우는 경우도 고려하여 수정해야함
            let equalWidth = proxy.frame(in: .global).width / CGFloat(tabs.count)
            
            DispatchQueue.main.async {
                // main 쓰레드에서 작업을 진행하고, width가 update되면 view refresh
                self.width = equalWidth
            }
            
            return AnyView(
                ZStack(alignment: .bottomLeading) {
                    Capsule()
                        .fill(Color.white)
                        .frame(width: equalWidth - 15, height: showCapsule ? 40 : 4)
                        // UIScrollView의 offset 변경에 따라, x좌표 업데이트
                        .offset(x: getOffset() + 7, y: 0)
                    
                    HStack(spacing: 0) {
                        ForEach(0 ..< tabs.count) { index in
                            Text(tabs[index])
                                .font(Font.notoSans(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(showCapsule ? (getIndexFromOffset() == CGFloat(index) ? .black : .white) : .white)
                                .frame(width: equalWidth, height: 40)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        // 각 화면이 UIScreen.main.bounds.width와 같은 width값을 가지고 있기 때문에, index를 곱해주면
                                        // 선택된 Tab에 해당하는 UIScrollView.offset.x를 계산 할 수 있음
                                        offset = UIScreen.main.bounds.width * CGFloat(index)
                                    }
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
            )
        }
        .padding()
        .frame(height: 40)
    }
    
    // Calculating Offset
    func getOffset() -> CGFloat {
        let progress = offset / UIScreen.main.bounds.size.width
        return progress * width
    }
    
    func getIndexFromOffset() -> CGFloat {
        let indexFloat = offset / UIScreen.main.bounds.width
        return indexFloat.rounded(.toNearestOrAwayFromZero)
    }
}
