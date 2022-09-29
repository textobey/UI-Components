//
//  InfiniteCarouselViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/09/28.
//
//  Reference: https://github.com/dvHuni/Carousel-Example,
//             https://github.com/JK0369/ExCarouselWithAnimation

import UIKit

class InfiniteCarouselViewController: UIBaseViewController {
    private enum Const {
        static let itemSize = CGSize(width: 300, height: 400)
        static let itemSpacing = 24.0
        
        static var insetX: CGFloat {
            (UIScreen.main.bounds.size.width - Self.itemSize.width) / 2.0
        }
        static var collectionViewContentInset: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: Self.insetX, bottom: 0, right: Self.insetX)
        }
    }
    
    private let dataSource: [UIColor] = [.orange, .brown, .blue, .gray, .cyan]
    
    private var originalDataSourceCount: Int {
        get {
            dataSource.count
        }
    }
    
    private var increasedDataSource: [UIColor] {
        get {
            dataSource + dataSource + dataSource
        }
    }
    
    private var previousIndex: Int?
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = Const.itemSize
        $0.minimumLineSpacing = Const.itemSpacing
        $0.minimumInteritemSpacing = 0
    }
    
    private lazy var carouselCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.isScrollEnabled = true
        $0.isPagingEnabled = false // 한 페이지의 넓이를 조정 할 수 없기 때문에, scrollViewWillEndDragging을 사용하여 구현
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.delegate = self
        $0.dataSource = self
        $0.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier)
        $0.contentInsetAdjustmentBehavior = .never // 내부적으로 safeAre에 의해 가려지는 것을 방지하기 위해 자동으로 inset을 조정하는것을 비활성화
        $0.contentInset = Const.collectionViewContentInset
        $0.decelerationRate = .fast // 스크롤이 빠르게 되도록(페이징 애니메이션 같이 보이게하기 위함)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "InfiniteCarousel")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(carouselCollectionView)
        carouselCollectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension InfiniteCarouselViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return increasedDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as? CarouselCollectionViewCell else { return UICollectionViewCell() }
        cell.wrapperView.backgroundColor = increasedDataSource[indexPath.row]
        return cell
    }
}

extension InfiniteCarouselViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = Const.itemSize.width + Const.itemSpacing
        let index = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrolledOffset = scrollView.contentOffset.x + scrollView.contentInset.left
        let cellWidth = Const.itemSize.width + Const.itemSpacing
        let index = Int(round(scrolledOffset / cellWidth))
        
        defer {
            self.previousIndex = index
            self.carouselCollectionView.reloadData()
        }
        
        guard let previousIndex = self.previousIndex, previousIndex != index else { return }
        print("selected index is \(previousIndex)")
    }
}
