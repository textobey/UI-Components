//
//  InfinitePagingViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/17.
//

import UIKit

class InfinitePagingViewController: UIBaseViewController {
    lazy var collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(InfinitePagingCollectionViewCell.self, forCellWithReuseIdentifier: InfinitePagingCollectionViewCell.identifier)
    }
    
    private var itemCount: Int = 0
    private var _dataSource: [String] = []
    private var dataSource: [String] {
        get {
            return _dataSource
        }
        set {
            if newValue.count > 0 {
                itemCount = newValue.count
                _dataSource.removeAll()
                for _ in 0 ..< 3 {
                    _dataSource.append(contentsOf: newValue)
                }
                reload()
            }
        }
    }
    
    private var indexOfCellBeforeDragging = 0
    private var velocity: CGPoint = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "InfinitePaging")
        setupLayout()
        fetchImageResources()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewLayoutItemSize()
    }
    
    private func setupLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension InfinitePagingViewController {
    private func fetchImageResources() {
        RandomImageLoader.shared.fetchImageResources(count: 8) { [weak self] randomImages in
            if let randomImages = randomImages {
                self?.dataSource = randomImages.compactMap { $0.download_url }
            }
        }
    }
    
    private func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            DispatchQueue.main.async {
                let currentOffset = self.collectionView.contentOffset.x
                let targetOffset = currentOffset + self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing
                self.collectionView.setContentOffset(CGPoint(x: targetOffset, y: self.collectionView.contentOffset.y), animated: false)
            }
        }
    }
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = 20
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionViewLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width - inset * 2, height: collectionViewLayout.collectionView!.frame.size.height)
    }
    
    //private func calculateSectionInset() -> CGFloat {
    //    let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
    //    let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
    //    let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
    //    let cellBodyWidth: CGFloat = 236 + (cellBodyViewIsExpended ? 174 : 0)
    //
    //    let buttonWidth: CGFloat = 50
    //
    //    let inset = (collectionViewLayout.collectionView!.frame.width - cellBodyWidth + buttonWidth) / 4
    //    return inset
    //}
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewLayout.itemSize.width + collectionViewLayout.minimumLineSpacing
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(dataSource.count - 1, index))
        return safeIndex
    }
}

extension InfinitePagingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfinitePagingCollectionViewCell.identifier, for: indexPath) as! InfinitePagingCollectionViewCell
        cell.banner.kf.setImage(with: URL(string: dataSource[indexPath.row]))
        cell.number.text = "\(indexPath.row)"
        return cell
    }
}

extension InfinitePagingViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = collectionViewLayout.itemSize.width + collectionViewLayout.minimumLineSpacing
        let periodOffset = pageWidth * CGFloat((dataSource.count / 3))
        let offsetActivatingMoveToBeginning = pageWidth * CGFloat((dataSource.count / 3) * 2)
        let offsetActivatingMoveToEnd = pageWidth * CGFloat((self.dataSource.count / 3) * 1)
        
        let offsetX = scrollView.contentOffset.x
        if (offsetX > offsetActivatingMoveToBeginning) {
            scrollView.contentOffset = CGPoint(x: (offsetX - periodOffset), y: 0)
        } else if (offsetX < offsetActivatingMoveToEnd) {
            scrollView.contentOffset = CGPoint(x: (offsetX + periodOffset), y: 0)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSource.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        //let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = /*majorCellIsTheCellBeforeDragging &&*/ (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = (collectionViewLayout.itemSize.width + collectionViewLayout.minimumLineSpacing) * CGFloat(snapToIndex)
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            // This is a much better way to scroll to a cell:
            //let directionIsLeft = velocity.x > 0 ? true : false
            //let indexPath = IndexPath(row: indexOfMajorCell + (directionIsLeft ? 1 : -1), section: 0)
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
