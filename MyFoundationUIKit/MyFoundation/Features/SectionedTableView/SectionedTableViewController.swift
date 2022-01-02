//
//  SectionedTableViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/31.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

struct SectionModel {
    var category: String
    var items: [String]
}

// SectionModelType을 준수하기 위해 만든 구조체
extension SectionModel: AnimatableSectionModelType {
    var identity: String {
        return category
    }
    init(original: SectionModel, items: [String]) {
        self = original
        self.items = items
    }
}

struct SectonModelDummyData {
    static let data: [SectionModel] = [
        SectionModel(category: "G-Dragon", items: gDragonTrack),
        SectionModel(category: "Crush", items: crushTrack)
    ]
    
    static let gDragonTrack: [String] = [
        "그XX",
        "니가 뭔데",
        "This love",
        "결국",
        "Black",
        "무제"
    ]
    static let crushTrack: [String] = [
        "2411",
        "어떻게 지내",
        "향수",
        "Cereal",
        "자나깨나",
        "SOFA",
        "가끔"
    ]
}

class SectionedTableViewController: UIBaseViewController {
    private let disposeBag = DisposeBag()
    
    lazy var tableView = UITableView().then {
        $0.rowHeight = 40
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.register(SectionedListCell.self, forCellReuseIdentifier: SectionedListCell.identifier)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "SectionedTableView")
        setupLayout()
        bindRx()
    }
    
    private func setupLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindRx() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: SectionedListCell.identifier, for: indexPath) as! SectionedListCell
                cell.title.text = item.identity
                return cell
            }
        )
        
        dataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].category
        }
        
        Observable.just(SectonModelDummyData.data)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
