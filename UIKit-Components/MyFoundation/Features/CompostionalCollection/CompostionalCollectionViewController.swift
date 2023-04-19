//
//  CompostionalCollectionViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/22.
//

import UIKit

class CompostionalCollectionViewController: UIBaseViewController {
    
    /// UICollectionViewCompositionalLayout -> iOS 13부터 지원하는, UICollectionViewLayout.
    /// Section 내부 Element의 Layout을 선언할수있음
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutDiffSection()).then {
        $0.backgroundColor = .white
        $0.delegate = self
        $0.dataSource = self
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.register(CompostionalCollectionViewCell.self, forCellWithReuseIdentifier: CompostionalCollectionViewCell.identifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "CompostionalCollection")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // NSCollectionLayoutDimension 유형으로, 레이아웃의 부분 너비/높이를 설정하거나 절대 또는 예상 크기를 설정함
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        // 위에 정의된 크기에 따라 렌더링 되는 레이아웃의 셀
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // 셀의 contentInsets
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        // horizontal 혹은 vertical 형식으로 생성함
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(CGFloat(10))
        
        // group을 전달하여, 섹션을 초기화 함. 결과적으로 섹션은 UICollectionViewCompositionalLayout을 구성함.
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createLayoutDiffSection() -> UICollectionViewLayout {
        // NSCollectionLayoutEnvironment는 뷰와 관련된 유용한 프로퍼티를 포함하고 있음. 해당 프로퍼티를 통해 뷰의 width/height를 가져올수있고, 이것을 바탕으로 다양한 크기의 뷰를 만들수있음.
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvioronment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var columns: Int = 1
            switch sectionIndex {
            case 1:
                // section이 1일때, 3개의 열로 배치함
                columns = 3
            case 2:
                columns = 5
            default:
                columns = 1
            }
            
            // fractional(1.0)은 그룹의 전체 너비 및 높이를 차지하도록 할당하는것.
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let groupHeight: NSCollectionLayoutDimension = columns == 1 ? .absolute(44) : .fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }
}

extension CompostionalCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompostionalCollectionViewCell.identifier, for: indexPath) as? CompostionalCollectionViewCell {
            switch indexPath.row % 10 {
            case 0:
                cell.backgroundColor = .blue
            case 1:
                cell.backgroundColor = .yellow
            case 2:
                cell.backgroundColor = .green
            case 3:
                cell.backgroundColor = .orange
            case 4:
                cell.backgroundColor = .systemBlue
            case 5:
                cell.backgroundColor = .darkGray
            case 6:
                cell.backgroundColor = .systemPink
            case 7:
                cell.backgroundColor = .systemRed
            case 8:
                cell.backgroundColor = .magenta
            case 9:
                cell.backgroundColor = .systemIndigo
            default:
                cell.backgroundColor = .white
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
