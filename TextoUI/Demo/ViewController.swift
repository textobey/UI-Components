//
//  ViewController.swift
//  Demo
//
//  Created by 이서준 on 2023/08/10.
//

import UIKit
import TextoUI

class ViewController: UIViewController {
    
    let pickerButton: PickerButton = {
        let pickerButton = PickerButton()
        pickerButton.setTitle("내가 만든 쿠키 아니고 모듈", for: .normal)
        pickerButton.titleLabel?.textAlignment = .right
        pickerButton.contentHorizontalAlignment = .right
        pickerButton.setTitleColor(UIColor.secondaryLabel, for: .normal)
        pickerButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        return pickerButton
    }()
    
    let carouselScrollView = CarouselScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        bindDataSource()
        
        carouselScrollView.didChangePage = { page in
            print("currentPage :", page)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //bindDataSource()
    }
    
    func setupLayout() {
        //view.addSubview(pickerButton)
        
        //pickerButton.translatesAutoresizingMaskIntoConstraints = false
        //NSLayoutConstraint.activate([
        //    pickerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        //    pickerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        //    pickerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        //])
        
        view.addSubview(carouselScrollView)
        carouselScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            carouselScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            carouselScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselScrollView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func bindDataSource() {
        pickerButton.dataSource = [
            "안녕하세요",
            "감사해요",
            "잘있어요",
            "다시만나요",
        ]
        
        carouselScrollView.dataSource = [
            UIImage(systemName: "playstation.logo")!,
            UIImage(systemName: "xbox.logo")!,
            UIImage(systemName: "camera")!,
            UIImage(systemName: "keyboard")!
        ]
    }
}

