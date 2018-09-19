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
    
    private var lastPosition: CGFloat = 0
    private(set) var currentIndex: Int = 0 {
        didSet {
            guard currentIndex != oldValue else { return }
            segmentView.currentPageChanged(withCurrentInde: currentIndex)
        }
    }
    
    private lazy var segmentView: BaseSegmentView = {
        let view = BaseSegmentView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
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
    
    var containerViewNames = [String]() {
        didSet {
            segmentView.updateSegmentView(withDataSource: containerViewNames)
        }
    }
    
    var canScroll: Bool = false {
        didSet {
            refreshSubViewControllerScroll()
        }
    }
    
    var showSegmentView: Bool = true {
        didSet {
            segmentViewHeightAnchor.constant = showSegmentView ? 50 : 0
        }
    }
    
    private lazy var segmentViewHeightAnchor: NSLayoutConstraint = {
       return self.segmentView.heightAnchor.constraint(equalToConstant: 0)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCurrentSelectedView(withCurrentIndex index: Int) {
        currentIndex = index
        scrollView.scrollRectToVisible(CGRect(x: frame.width * CGFloat(currentIndex), y: 0, width: frame.width, height: frame.height), animated: true)
    }
}

extension BaseMainContainerViewCell {
    private func setupViews() {
        addSubview(segmentView)
        segmentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        segmentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        segmentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        segmentViewHeightAnchor.isActive = true
        
        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: segmentView.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
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
        for viewController in dataSource {
            if let baseViewController = viewController as? BaseViewController {
                baseViewController.canScroll = canScroll
            }
        }
    }
    
    private func refreshCurrentIndex() {
        var index = Int(floor((scrollView.contentOffset.x - scrollView.bounds.width / 2) / scrollView.bounds.width) + 1)
        
        if index < 0 {
            index = 0
        } else if index >= dataSource.count {
            index = dataSource.count - 1
        }
        currentIndex = index
    }
    
    @objc func updateScrollView(_ notification: Notification) {
        guard case let info as String = notification.userInfo?["canScroll"] else { return }
        scrollView.isScrollEnabled = info == "1" ? true : false
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

extension BaseMainContainerViewCell: BaseSegmentViewDelegate {
    func baseSegmentViewDidSelectedSegment(_ baseSegmentView: BaseSegmentView, selectedIndex: Int) {
        updateCurrentSelectedView(withCurrentIndex: selectedIndex)
    }
}
