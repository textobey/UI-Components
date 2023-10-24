//
//  KingfisherTestViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2023/10/17.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class KingfisherTestViewController: UIBaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private var dataSource: [RandomImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var isLoading: Bool = false
    private var currentPage: Int = 1
    
    private struct Metric {
        static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        static let collectionViewSpacing: CGFloat = 6
        static let collectionViewInset: CGFloat = 16
        static let itemWidth = (Self.screenWidth - (Self.collectionViewInset * 2) - Self.collectionViewSpacing) / 2
        static let itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.minimumLineSpacing = 6
            $0.minimumInteritemSpacing = 6
            $0.itemSize = Metric.itemSize
        }
    ).then {
        $0.dataSource = self
        $0.contentInset = UIEdgeInsets(
            top: 0,
            left: Metric.collectionViewInset,
            bottom: 0,
            right: Metric.collectionViewInset
        )
        $0.register(
            KingfisherTestCollectionViewCell.self,
            forCellWithReuseIdentifier: KingfisherTestCollectionViewCell.identifier
        )
    }
    
    deinit {
        print("Deinit- KingfisherTestViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        testKingfisherCache()
        setNavigationTitle(title: "Kingfisher Clear Memory Test")
        setupLayout()
        bindRx()
        fetchImageResources()
    }
    
    private func testKingfisherCache() {
        ImageCache.default.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
        ImageCache.default.memoryStorage.config.countLimit = 40
        
        //"default"로 생성된 diskStorage의 sizeLimit은 기본값이 0
        //ImageCache.default.diskStorage.config.sizeLimit = 1000 * 1024 * 1024
        
        //ImageCache.default.clearDiskCache()
    }
    
    private func setupLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    private func bindRx() {
        collectionView.rx.contentOffset
            .withUnretained(self)
            .filter { !$0.0.isLoading }
            .filter { $0.0.collectionView.isNearBottomEdge() }
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.fetchImageResources()
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchImageResources() {
        guard !isLoading else { return }
        
        isLoading = true
        
        Task {
            let size = try ImageCache.default.diskStorage.totalSize()
            print("diskStorage totalSize:", size)
        }
        
        RandomImageLoader.shared.fetchImageResources(page: currentPage) { [weak self] randomImages in
            if let randomImages = randomImages {
                print("newImagesCount: \(randomImages.count)")
                let currentDatasource = self?.dataSource
                self?.dataSource = (currentDatasource ?? []) + randomImages
                self?.currentPage += 1
                self?.isLoading = false
            }
        }
    }
}

extension KingfisherTestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: KingfisherTestCollectionViewCell.identifier,
            for: indexPath
        ) as? KingfisherTestCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.kf.setImage(with: URL(string: dataSource[indexPath.row].download_url ?? .empty))
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if let cell = collectionView.cellForItem(at: indexPath) as? KingfisherTestCollectionViewCell {
            cell.imageView.kf.cancelDownloadTask()
        }
    }
}
