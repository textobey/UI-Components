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
    
    var dataSources: [RandomImage] = []
    
    // 스크롤이 originalDataSource의 끝으로 가야함을 의미하는 플래그값
    private var scrollToEnd: Bool = false
    // 스크롤이 originalDataSource의 시작으로 가야함을 의미하는 플래그값
    private var scrollToBegin: Bool = false
    
    private var originalDataSourceCount = 3
    
    private lazy var disposableTrigger: Void = {
        let indexPath = IndexPath(row: fetchCenteredHorizontallyIndex(), section: 0)
        //currentIndex.accept(indexPath.row)
        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: false
        )
    }()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = disposableTrigger
    }
}

extension FloHorizontalController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 8
        return dataSources.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FloListCell.identifier, for: indexPath) as! FloListCell
        //cell.banner.kf.setImage(with: URL(string: "https://img-9gag-fun.9cache.com/photo/aLwzjzz_700b.jpg"))
        cell.banner.kf.setImage(with: URL(string: dataSources[indexPath.row % originalDataSourceCount].download_url ?? .empty))
        //cell.number.text = "\((indexPath.row + 1) % originalDataSourceCount)"
        cell.number.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //real size..recommend size smaller than the screen
        return .init(width: view.frame.width - 40, height: (view.frame.width - 22) / 2)//view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //return .init(top: 10, left: 16, bottom: 10, right: 16)
        //start/end point inset
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    //func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //    return 10
    //}
    
    //func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //    return 0
    //}
}

extension FloHorizontalController {
    //override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //    print("currentIndex is: ",currentIndex.value)
    //}
    
    //override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //    let centerIndex = fetchCenteredHorizontallyIndex()
    //    let row = centerIndex + (currentIndex.value % originalDataSourceCount)
    //    currentIndex.accept(row)
    //    collectionView.scrollToItem(
    //        at: IndexPath(row: row, section: 0),
    //        at: .centeredHorizontally,
    //        animated: false
    //    )
    //}
}

extension FloHorizontalController {
    private func fetchCenteredHorizontallyIndex() -> Int {
        //floor(repeat / 2) * originalDataSourceCount - 1
        let center = (dataSources.count / originalDataSourceCount) / 2
        let centerStartPoint = center * originalDataSourceCount
        return centerStartPoint - 1
    }
}
