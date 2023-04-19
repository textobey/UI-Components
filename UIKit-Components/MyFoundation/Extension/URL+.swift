//
//  URL+.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/18.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

extension URL {
    func retrieveImage(completionHandler: @escaping (RetrieveImageResult?) -> Void) {
        KingfisherManager.shared.retrieveImage(with: self, completionHandler: { result in
            switch result {
            case .success(let image):
                completionHandler(image)
                return
            case .failure(_):
                completionHandler(nil)
                return
            }
        })
    }
}


