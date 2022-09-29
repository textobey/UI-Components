//
//  InfiniteCarouselViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/09/28.
//
//  Reference: https://github.com/dvHuni/Carousel-Example

import UIKit

class InfiniteCarouselViewController: UIBaseViewController {
    
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
    
    private lazy var carouselCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.scrollDirection = .horizontal
    }).then {
        $0.backgroundColor = .white
        $0.delegate = self
        $0.dataSource = self
        $0.isPagingEnabled = true
        $0.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
