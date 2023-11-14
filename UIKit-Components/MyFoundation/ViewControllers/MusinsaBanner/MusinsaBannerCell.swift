//
//  MusinsaBannerCell.swift
//  MyFoundation
//
//  Created by 이서준 on 11/14/23.
//

import UIKit
import SnapKit

class MusinsaBannerCell: UICollectionViewCell {
    
    static let identifier = String(describing: MusinsaBannerCell.self)
    
    let imageView = UIImageView().then {
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let titleLabel = UILabel().then {
        $0.text = "23 F/W 럭키박스"
        $0.font = .notoSans(size: 24, style: .bold)
        $0.textColor = .white
    }
    
    let descriptionLabel = UILabel().then {
        $0.text = "세일 | 최대 80% 할인"
        $0.font = .notoSans(size: 14, style: .regular)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(frame.width * 2 / 3)
            $0.centerX.equalToSuperview()
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configure() {
        Task {
            let image = try await loadImage(row: self.tag)
            imageView.image = image
        }
    }
    
    private func loadImage(row: Int) async throws -> UIImage {
        let urlString = "https://images.pexels.com/photos/53421\(row)/pexels-photo-53421\(row).jpeg?auto=compress&cs=tinysrgb&w=400"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else {
                throw URLError(.badServerResponse)
            }
            
            return image

        } catch {
            throw error
        }
    }
}
