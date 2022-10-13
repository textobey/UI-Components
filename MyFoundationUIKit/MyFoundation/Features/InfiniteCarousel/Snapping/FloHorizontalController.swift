//
//  FloHorizontalController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/13.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class FloHorizontalController: HorizontalSnappingController {
    
    private var dataSources: [RandomImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(FloListCell.self, forCellWithReuseIdentifier: FloListCell.identifier)
        
        // Scroll horizontal Header Page
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
}

extension FloHorizontalController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FloListCell.identifier, for: indexPath) as! FloListCell
        cell.banner.kf.setImage(with:  URL(string: "https://img-9gag-fun.9cache.com/photo/aLwzjzz_700b.jpg"))
        cell.number.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 320, height: (view.bounds.width - 22) / 2)
        return .init(width: view.frame.width - 40, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //return .init(top: 10, left: 16, bottom: 10, right: 16)
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    //func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //    return 10
    //}
    
    //func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //    return 0
    //}
}
