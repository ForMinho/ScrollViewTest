//
//  BaseMainContainerViewCell.swift
//  ScrollViewTest
//
//  Created by chenchen on 2018/8/31.
//  Copyright © 2018年 for_minho. All rights reserved.
//

import Foundation
class BaseMainContainerViewCell: UIView {
    static let baseMainContainerViewCellNotification = Notification.Name("baseMainContainerViewCellNotification")
    private(set) var currentIndex: Int = 0
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.isPagingEnabled = true
        view.alwaysBounceHorizontal = true
        view.bounces = false
        view.accessibilityIdentifier = "scrollView"
        return view
    }()
    
    var dataSource = [UIViewController]() {
        didSet {
            updateContainerView()
        }
    }
    
    var canScroll: Bool = false {
        didSet {
            refreshSubViewControllerScroll()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(updateScrollView(_:)), name: BaseViewController.BaseViewControllerScrolled, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func updateContainerView() {
        guard dataSource.count > 0 else { return }
        var preView: UIView = scrollView
        var currentView: UIView = UIView()
        
        for viewController in dataSource {
            currentView = viewController.view
            scrollView.addSubview(currentView)
            currentView.topAnchor.constraint(equalTo: preView.topAnchor).isActive = true
            currentView.bottomAnchor.constraint(equalTo: preView.bottomAnchor).isActive = true
            if preView == scrollView {
                currentView.leadingAnchor.constraint(equalTo: preView.leadingAnchor).isActive = true
            } else {
                currentView.leadingAnchor.constraint(equalTo: preView.trailingAnchor).isActive = true
            }
            
            currentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            currentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            preView = currentView
        }
        currentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    }
    
    private func refreshSubViewControllerScroll() {
//        guard currentIndex < dataSource.count else { return }
//        if let baseViewController = dataSource[currentIndex] as? BaseViewController {
//            baseViewController.canScroll = canScroll
//        }
        
        for viewController in dataSource {
            if let baseViewController = viewController as? BaseViewController {
                baseViewController.canScroll = canScroll
            }
        }
    }
    
    
    @objc func updateScrollView(_ notification: Notification) {
        guard case let info as String = notification.userInfo?["canScroll"] else { return }
        scrollView.isScrollEnabled = info == "1" ? true : false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension BaseMainContainerViewCell {
    private func refreshCurrentIndex() {
        if scrollView.contentOffset.x >= scrollView.bounds.width * 2 {
            currentIndex = currentIndex + 1
        } else if scrollView.contentOffset.x <= scrollView.bounds.width * 0.5 {
            currentIndex = currentIndex - 1
        }
        
        if currentIndex < 0 {
            currentIndex = 0
        } else if currentIndex >= dataSource.count {
            currentIndex = dataSource.count - 1
        }
    }
}

extension BaseMainContainerViewCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: BaseMainContainerViewCell.baseMainContainerViewCellNotification, object: nil, userInfo: ["canScroll": "0"])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)   {
        refreshCurrentIndex()
        NotificationCenter.default.post(name: BaseMainContainerViewCell.baseMainContainerViewCellNotification, object: nil, userInfo: ["canScroll": "1"])
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshCurrentIndex()
    }
    
}
