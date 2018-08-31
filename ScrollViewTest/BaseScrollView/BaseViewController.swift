//
//  BaseWebViewController.swift
//  ScrollViewTest
//
//  Created by chenchen on 2018/8/29.
//  Copyright © 2018年 for_minho. All rights reserved.
//

import Foundation
class BaseViewController: UIViewController {
    var canScroll: Bool = false
    static let BaseViewControllerToTop = Notification.Name("BaseViewControllerToTop")
    static let BaseViewControllerScrolled = Notification.Name("BaseViewControllerScrolled")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    func setupView() {
    }
}

extension BaseViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.alwaysBounceVertical = true
        NotificationCenter.default.post(name: BaseViewController.BaseViewControllerScrolled, object: nil, userInfo: ["canScroll": "0"])
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.alwaysBounceVertical = true
        NotificationCenter.default.post(name: BaseViewController.BaseViewControllerScrolled, object: nil, userInfo: ["canScroll": "1"])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !canScroll {
            scrollView.contentOffset = .zero
        }
        if scrollView.contentOffset.y <= 0 {
            canScroll = false
            scrollView.contentOffset = .zero
            NotificationCenter.default.post(name: BaseViewController.BaseViewControllerToTop, object: self)
        }
        scrollView.showsVerticalScrollIndicator = canScroll ? true : false
    }
}