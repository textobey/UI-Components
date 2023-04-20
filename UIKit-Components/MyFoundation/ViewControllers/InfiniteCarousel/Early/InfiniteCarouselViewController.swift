//
//  InfiniteCarouselViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/09/28.
//
//  Reference: https://github.com/dvHuni/Carousel-Example,
//             https://github.com/JK0369/ExCarouselWithAnimation

import UIKit
import RxSwift
import RxCocoa

class InfiniteCarouselViewController: UIBaseViewController {
    private let disposeBag = DisposeBag()
    
    private enum Const {
        static let itemSize = CGSize(width: 300, height: 400)
        static let itemSpacing = 24.0
        
        // safeArea.leading으로부터의 insetX 값.
        static var insetX: CGFloat {
            (UIScreen.main.bounds.size.width - Self.itemSize.width) / 2.0
        }
        
        // collectionView가 위치해야할 포지션 지정을 위한, inset 값
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
    
    // 스크롤이 originalDataSource의 끝으로 가야함을 의미하는 플래그값
    private var scrollToEnd: Bool = false
    // 스크롤이 originalDataSource의 시작으로 가야함을 의미하는 플래그값
    private var scrollToBegin: Bool = false
    
    private let collectionViewFlowLayout = TestCarouselLayout().then {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        carouselCollectionView.scrollToItem(
            at: IndexPath(item: originalDataSourceCount, section: 0),
            at: .centeredHorizontally,
            animated: false
        )
    }
    
    private func setupLayout() {
        addSubview(carouselCollectionView)
        carouselCollectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension InfiniteCarouselViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // originalDataSource가 시작하는 X좌표
        let beginOffset = carouselCollectionView.frame.width * CGFloat(originalDataSourceCount)
        // originalDataSource가 끝나는 X좌표
        let endOffset = carouselCollectionView.frame.width * CGFloat(originalDataSourceCount * 2 - 1)
        
        // orignalDataSource의 시작점보다 왼쪽으로 이동하는 경우
        if scrollView.contentOffset.x < beginOffset && velocity.x < .zero {
            scrollToEnd = true
        // orignalDataSource의 끝점보다 오른쪽으로 이동하는 경우
        } else if scrollView.contentOffset.x > endOffset && velocity.x > .zero {
            scrollToBegin = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollToBegin {
            carouselCollectionView.scrollToItem(
                at: IndexPath(item: originalDataSourceCount, section: .zero),
                at: .centeredHorizontally,
                animated: false
            )
            scrollToBegin.toggle()
            return
        }
        if scrollToEnd {
            carouselCollectionView.scrollToItem(
                at: IndexPath(item: originalDataSourceCount * 2 - 1, section: .zero),
                at: .centeredHorizontally,
                animated: false
            )
            scrollToEnd.toggle()
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return increasedDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as? CarouselCollectionViewCell else { return UICollectionViewCell() }
        cell.wrapperView.backgroundColor = increasedDataSource[indexPath.row]
        cell.titleLabel.text = "\(indexPath.row + 1)"
        return cell
    }
}

/*extension InfiniteCarouselViewController: UICollectionViewDelegateFlowLayout {
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
}*/

class TestCarouselLayout: UICollectionViewFlowLayout {
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            let lastestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            return lastestOffset
        }
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2
        
        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}

//extension Reactive where Base: TestCarouselLayout {
//    var targetContentOffset: Observable<[Any]> {
//        return methodInvoked(#selector(base.targetContentOffset(forProposedContentOffset:withScrollingVelocity:)))
//            .map { $0 }
//    }
//}
