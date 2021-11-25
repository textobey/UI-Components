//
//  MoreView.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/19.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        Text("MoreView")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(false)
            .navigationBarTitle("", displayMode: .inline)
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
