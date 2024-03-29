//
//  PassiveCarouselViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/06.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PassiveCarouselViewController: UIBaseViewController {
    //private let cellSize: CGSize = CGSize(width: 300, height: 200)
    private var minimumLineSpacing: CGFloat = 6
    private var cellCount: Int = 0
    private var previousIndex: Int = 0
    
    private var dataSources: [RandomImage] = [] {
        willSet {
            self.cellCount = newValue.count
            setupLayout()
        }
    }
    
    private lazy var carouselCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        //$0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.itemSize = CGSize(width: view.bounds.width - 40, height: 100)
        $0.minimumLineSpacing = minimumLineSpacing
    }).then {
        //$0.isScrollEnabled = true
        //$0.isPagingEnabled = false // 한 페이지의 넓이를 조정 할 수 없기 때문에, scrollViewWillEndDragging을 사용하여 구현
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        //$0.isPagingEnabled = true
        //$0.clipsToBounds = true
        $0.register(PassiveCarouselCollectionViewCell.self, forCellWithReuseIdentifier: PassiveCarouselCollectionViewCell.identifier)
        $0.contentInsetAdjustmentBehavior = .never // 내부적으로 safeAre에 의해 가려지는 것을 방지하기 위해 자동으로 inset을 조정하는것을 비활성화
        //let cellWidth = floor(cellSize.width)
        //let insetX = (view.bounds.width - cellWidth) / 2
        let insetX: CGFloat = 20
        $0.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        //$0.decelerationRate = .fast // 스크롤이 빠르게 되도록(페이징 애니메이션 같이 보이게하기 위함)
        $0.delegate = self
        $0.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Passive Carousel")
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_ :)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
        //setupLayout()
        RandomImageLoader.shared.fetchImageResources(count: 8) { [weak self] randomImages in
            if let randomImages = randomImages {
                self?.dataSources = randomImages + randomImages + randomImages
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //carouselCollectionView.scrollToItem(at: <#T##IndexPath#>, at: <#T##UICollectionView.ScrollPosition#>, animated: <#T##Bool#>)
    }
    
    private func setupLayout() {
        addSubview(carouselCollectionView)
        carouselCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(150)
        }
    }
    
    @objc func panAction(_ sender: UIPanGestureRecognizer) {
        self.velocity = sender.velocity(in: carouselCollectionView)
    }
    
    var startPoint: CGFloat = 0
    var endPoint: CGFloat = 0
    var velocity: CGPoint = .zero
    let speedThreshold: CGFloat = 300
}

extension PassiveCarouselViewController: UIGestureRecognizerDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.startPoint = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("startPoint:", self.startPoint)
        print("endPoint:", scrollView.contentOffset.x)
        print("velocity:", self.velocity)
        self.endPoint = scrollView.contentOffset.x
        
        defer {
            self.velocity = .zero
        }
        
        var index: Int = 0
        
        if velocity.x.magnitude > speedThreshold {
            index = self.previousIndex + (velocity.x < 0 ? 1 : -1)
        }
        else {
            if max(startPoint, endPoint) - min(startPoint, endPoint) > (UIScreen.main.bounds.width / 3) {
                index = self.previousIndex + (velocity.x < 0 ? 1 : -1)
            } else {
                index = self.previousIndex
            }
        }
        
        if Int(index) + 1 > cellCount || Int(index) + 1 < 0 {
            index = self.previousIndex
        }
        
        DispatchQueue.main.async {
            self.previousIndex = Int(index)
            self.carouselCollectionView.scrollToItem(at: IndexPath(item: Int(index), section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension PassiveCarouselViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return cellCount
        return 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PassiveCarouselCollectionViewCell.identifier, for: indexPath) as? PassiveCarouselCollectionViewCell else { return UICollectionViewCell() }
        let row = indexPath.row % dataSources.count
        cell.banner.kf.setImage(with: URL(string: dataSources[row].download_url ?? .empty), placeholder: .none, options: [.transition(.fade(0.2))])
        cell.number.text = String(indexPath.row + 1) + "\n" + (dataSources[row].author ?? .empty)
        return cell
    }
}
