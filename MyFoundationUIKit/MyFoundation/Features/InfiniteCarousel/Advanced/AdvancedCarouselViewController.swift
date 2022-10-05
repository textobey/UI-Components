//
//  AdvancedCarouselViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/04.
//
//  Reference: https://nsios.tistory.com/45

import UIKit

class AdvancedCarouselViewController: UIBaseViewController {
    
    private let cellSize: CGSize = CGSize(width: 200, height: 200)
    private var minimumLineSpacing: CGFloat = 20
    private let cellCount: Int = 8
    private var previousIndex: Int = 0
    
    private lazy var carouselCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.estimatedItemSize = cellSize
        $0.itemSize = cellSize
        $0.minimumLineSpacing = minimumLineSpacing
    }).then {
        //$0.isScrollEnabled = true
        //$0.isPagingEnabled = false // 한 페이지의 넓이를 조정 할 수 없기 때문에, scrollViewWillEndDragging을 사용하여 구현
        //$0.showsHorizontalScrollIndicator = false
        //$0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .clear
        //$0.clipsToBounds = true
        $0.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.identifier)
        $0.contentInsetAdjustmentBehavior = .never // 내부적으로 safeAre에 의해 가려지는 것을 방지하기 위해 자동으로 inset을 조정하는것을 비활성화
        let cellWidth = floor(cellSize.width)
        let insetX = (view.bounds.width - cellWidth) / 2
        $0.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        $0.decelerationRate = .fast // 스크롤이 빠르게 되도록(페이징 애니메이션 같이 보이게하기 위함)
        $0.delegate = self
        $0.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Advanced Carousel")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(carouselCollectionView)
        carouselCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
}

extension AdvancedCarouselViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier, for: indexPath) as? CarouselCell else { return UICollectionViewCell() }
        //cell.customView.backgroundColor = .brown
        cell.backgroundColor = .brown
        if indexPath.row == previousIndex {
            return cell
        }
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellWidthIncludeSpacing = cellSize.width + minimumLineSpacing
        let offsetX = carouselCollectionView.contentOffset.x
        let index = (offsetX + carouselCollectionView.contentInset.left) / cellWidthIncludeSpacing
        let roundedIndex = round(index)
        let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
        if let cell = carouselCollectionView.cellForItem(at: indexPath) {
            animateZoomforCell(zoomCell: cell)
        }
        
        if Int(roundedIndex) != previousIndex {
            let preIndexPath = IndexPath(item: previousIndex, section: 0)
            if let preCell = carouselCollectionView.cellForItem(at: preIndexPath) {
                animateZoomforCellremove(zoomCell: preCell)
            }
            previousIndex = indexPath.item
        }
    }
    
    // MARK: Paging Effect
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludeSpacing = cellSize.width + minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
        let roundedIndex: CGFloat = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

extension AdvancedCarouselViewController {
    func animateZoomforCell(zoomCell: UICollectionViewCell) {
        (zoomCell as! CarouselCell).customView.backgroundColor = .red
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                zoomCell.transform = .identity
        })
    }
    
    func animateZoomforCellremove(zoomCell: UICollectionViewCell) {
        (zoomCell as! CarouselCell).customView.backgroundColor = .blue
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                zoomCell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
    }
}

/*
class AdvancedCarouselViewController: UIBaseViewController {
    
    /*private let carosuelFlowLayout = CarouselLayout().then {
        $0.itemSize = CGSize(width: 315, height: 347)//CGSize(width: 315 * 0.796, height: 347)
        $0.sideItemScale = 30//175 / 251
        $0.spacing = -30
        $0.isPagingEnabled = true
        $0.sideItemAlpha = 0.5
    }*/
    
    /*private lazy var carouselCollectionView = UICollectionView(frame: .zero, collectionViewLayout: carosuelFlowLayout).then {
        $0.isScrollEnabled = true
        $0.isPagingEnabled = false // 한 페이지의 넓이를 조정 할 수 없기 때문에, scrollViewWillEndDragging을 사용하여 구현
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .clear
        //$0.clipsToBounds = true
        $0.delegate = self
        $0.dataSource = self
        $0.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier)
        //$0.contentInsetAdjustmentBehavior = .never // 내부적으로 safeAre에 의해 가려지는 것을 방지하기 위해 자동으로 inset을 조정하는것을 비활성화
        //$0.contentInset = Const.collectionViewContentInset
        //$0.decelerationRate = .fast // 스크롤이 빠르게 되도록(페이징 애니메이션 같이 보이게하기 위함)
    }*/
    
    private var carouselCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 315, height: 347), collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Advanced Carousel")
        addCollectionView()
        setupLayout()
    }
    
    private func addCollectionView() {
        let layout = CarouselLayout()
        layout.itemSize = CGSize(width: carouselCollectionView.frame.size.width * 0.796, height: carouselCollectionView.frame.size.width)
        layout.sideItemScale = 175 / 251
        layout.spacing = -197
        layout.isPagingEnabled = true
        layout.sideItemAlpha = 0.5
        
        carouselCollectionView.collectionViewLayout = layout
        self.carouselCollectionView.delegate = self
        self.carouselCollectionView.dataSource = self
        self.carouselCollectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.identifier)
    }
    
    private func setupLayout() {
        carouselCollectionView.backgroundColor = .clear
        superView.backgroundColor = .brown
        
        addSubview(carouselCollectionView)
        //carouselCollectionView.snp.makeConstraints {
        //    $0.center.equalToSuperview()
        //    $0.size.equalTo(CGSize(width: 315, height: 347))
        //}
    }
}

extension AdvancedCarouselViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier, for: indexPath) as! CarouselCell
        cell.customView.backgroundColor = .white
        return cell
    }
}
*/
