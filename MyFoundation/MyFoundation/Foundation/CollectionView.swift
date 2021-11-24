//
//  CollectionView.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/24.
//

import SwiftUI

/// 사용 가능한 width 값을 확보하여, 실제 구현체인 _FlexibleView로 전달함.
struct CollectionView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    @State private var avaiableWidth: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            // 투명한 선을 긋고, readSize를 통해 현재 View에서 사용 가능한 크기를 구함
            // CollectionView를 선언할때, padding을 파라미터 없이 지정해놨기 때문에 시스템에서 최적의 간격을 자동으로 지정해주는것을 이용함
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    // *
                    // print("CollectionView", size)
                    avaiableWidth = size.width
                }
            
            _FlexibleView(availableWidth: avaiableWidth,
                          data: data,
                          spacing: spacing,
                          alignment: alignment,
                          content: content)
        }
    }
}


/// 주어진 Content(View)를 배치하고 필요하다면 여러 행으로 나눈 뷰
struct _FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    // View Update Trigger 역할을 위해서 @State 변수로 선언
    @State var elementsSize: [Data.Element: CGSize] = [:]
    
    var body : some View {
        // Dynamic GridView
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                // 직렬큐인 메인스레드에서 작업을 진행하게 해서, readSize 클로저값을 받고 비동기로 UI 업데이트 진행
                                DispatchQueue.main.async {
                                    elementsSize[element] = size
                                }
                            }
                    }
                }
            }
        }
    }
    
    /// 몇개의 행이 필요한지 계산하여, Data를 이중배열로 return함
    private func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
        
        for element in data {
            // dictionary가 optional type이기 때문에, default Value를 CGSize(avaiableWidth, 1)로 지정
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]
            // content로 전달된 view의 width + spacing이 0보다 크거나 같으면, element를 해당 행에 추가
            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            }
            // 0보다 작으면, 1행을 증가시키고 새로운 배열도 추가
            else {
                currentRow = currentRow + 1
                rows.append([element])
                // 남은 width값 초기화
                remainingWidth = availableWidth
            }
            // 남은 width값 계산
            remainingWidth = remainingWidth - (elementSize.width + spacing)
        }
        return rows
    }
}
