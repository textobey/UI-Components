//
//  TabBarController.swift
//  RxFlowTabPager
//
//  Created by 이서준 on 2022/03/24.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa
import Tabman
import Pageboy

class TabBarController: TabmanViewController, Stepper {
    var steps = PublishRelay<Step>()
    
    // MARK: Properties
    
    /// View controllers that will be displayed in page view controller.
    //lazy var viewControllers: [UIViewController & Stepper] = [
    //    ChildViewController(page: 1),
    //    ChildViewController(page: 2),
    //    ChildViewController(page: 3)
    //]
    
    lazy var viewControllers: [UIViewController] = [] {
        didSet {
            layoutView()
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func layoutView() {
        // Set PageboyViewControllerDataSource dataSource to configure page view controller.
        dataSource = self
        
        // Create a bar
        let bar = TMBarView.TabBar()
        
        // Customize bar properties including layout and other styling.
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 4.0, right: 8.0)
        bar.layout.visibleButtonCount = 3
        bar.spacing = 16.0
        
        // Set tint colors for the bar buttons and indicator.
        bar.buttons.customize {
            $0.tintColor = UIColor.tabmanForeground.withAlphaComponent(0.4)
            $0.selectedTintColor = .tabmanForeground
            if #available(iOS 11, *) {
                $0.adjustsFontForContentSizeCategory = true
            }
        }
        bar.indicator.tintColor = .tabmanForeground
        
        // Add bar to the view - as a .systemBar() to add UIKit style system background views.
        addBar(bar.systemBar(), dataSource: self, at: .bottom)
    }
}

extension TabBarController: PageboyViewControllerDataSource, TMBarDataSource {

    
    // MARK: PageboyViewControllerDataSource
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count // How many view controllers to display in the page view controller.
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index] // View controller to display at a specific index for the page view controller.
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        nil // Default page to display in the page view controller (nil equals default/first index).
    }
    
    // MARK: TMBarDataSource
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        //return TMBarItem(title: "Page No. \(index + 1)", image: UIImage.star ?? UIImage(), selectedImage: UIImage.starFilled ?? UIImage())
        return TMBarItem(image: UIImage.star ?? UIImage(), selectedImage: UIImage.starFilled ?? UIImage())
    }
}


// MARK: - Star Image Extensions
extension UIImage {
    
    class var star: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "star")
        } else {
            return nil
        }
    }
    
    class var starFilled: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "star.fill")
        } else {
            return nil
        }
    }
}

class ChildViewController: UIViewController, Stepper {
    var steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: Properties
    let page: Int
    
    let label = UIButton()
    
    // MARK: Init
    init(page: Int) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
        bindRx()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        label.setTitle("Page \(page)", for: .normal)
        label.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        label.setTitleColor(.black, for: .normal)
    }
    
    func bindRx() {
        label.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.steps.accept(MainSteps.pageTapped(owner.page))
            }).disposed(by: disposeBag)
    }
}
