//
//  MainListCell.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/25.
//

import UIKit
import SnapKit

class MainListCell: UITableViewCell {
    static let identifier = String(describing: MainListCell.self)
    
    lazy var title = UILabel().then {
        $0.textColor = .black
        $0.font = .montserrat(size: 17, style: .regular)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    private func setupLayout() {
        addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
