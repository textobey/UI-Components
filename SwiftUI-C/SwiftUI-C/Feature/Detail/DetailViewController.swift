//
//  DetailViewController.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/07.
//

import UIKit
import SwiftUI
import RxFlow
import RxSwift
import RxCocoa

class DetailViewController: RxFlowViewController {
    var weather: ListModel?
    
    init(_ weather: ListModel) {
        self.weather = weather
        super.init(nibName: nil, bundle: nil)
        contentViewController = UIHostingController(rootView: DetailView(steps: steps, weather: weather))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
