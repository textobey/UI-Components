//
//  MusinsaBannerViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 11/14/23.
//

import UIKit
import SnapKit

class MusinsaBannerViewController: UIBaseViewController {
    
    struct Metric {
        static let cellWidth = UIScreen.main.bounds.size.width
    }
    
    private let list: [Int] = (1 ... 5).map { $0 }
    
    let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: Metric.cellWidth, height: 400)
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.contentInset = .zero
        $0.clipsToBounds = true
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(MusinsaBannerCell.self, forCellWithReuseIdentifier: MusinsaBannerCell.identifier)
    }
    
    lazy var pageLabel = UILabel().then {
        $0.textColor = .white
        $0.backgroundColor = .black.withAlphaComponent(0.2)
        $0.font = .notoSans(size: 12, style: .medium)
        $0.textAlignment = .center
        $0.layer.cornerRadius = 5
        $0.text = "< 1 / \(list.count) >"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Musinsa Banner")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        addSubview(pageLabel)
        pageLabel.snp.makeConstraints {
            $0.trailing.bottom.equalTo(collectionView)
            $0.height.equalTo(25)
            $0.width.equalTo(60)
        }
    }
}

extension MusinsaBannerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.setContentOffset(
            CGPoint(x: Metric.cellWidth * CGFloat(list.count) * 999, y: collectionView.contentOffset.y),
            animated: false
        )
        return Int.max
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MusinsaBannerCell.identifier,
            for: indexPath
        ) as? MusinsaBannerCell else {
            return UICollectionViewCell()
        }
        
        let currentRow = indexPath.row % list.count
        //cell.tag = indexPath.row + 1
        cell.tag = currentRow + 1
        cell.configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.visibleCells.count > 0 {
            pageLabel.text = "< \(collectionView.visibleCells[0].tag) / \(list.count) >"
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.visibleCells.count > 0 {
            let currentCell = collectionView.visibleCells[0] as! MusinsaBannerCell
            currentCell.imageView.frame.origin.x = scrollView.contentOffset.x - currentCell.frame.origin.x
            
            if collectionView.visibleCells.count > 1 {
                let nextCell = collectionView.visibleCells[1] as! MusinsaBannerCell
                nextCell.imageView.frame.origin.x = scrollView.contentOffset.x - nextCell.frame.origin.x
            }
        }
    }
}
