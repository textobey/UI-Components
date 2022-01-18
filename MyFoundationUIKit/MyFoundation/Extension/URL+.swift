//
//  URL+.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/01/18.
//

import UIKit
import Kingfisher

extension URL {
    var retrieveImage: UIImage? {
        KingfisherManager.shared.retrieveImage(with: self, completionHandler: { result in
            switch result {
            case .success(let image):
                return image
            case .failure(error):
                return nil
            }
        })
    }
}
