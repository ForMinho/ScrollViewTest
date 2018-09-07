//
//  ZCWebViewController.swift
//  ScrollViewTest
//
//  Created by chenchen on 2018/8/29.
//  Copyright © 2018年 for_minho. All rights reserved.
//

import Foundation
import WebKit

class ZCWebViewController: BaseViewController {
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.delegate = self
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: "https://github.com/indulgeIn/YBMultistageScrollView")!))
//        setupView()
    }
    
    override func setupView() {
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
