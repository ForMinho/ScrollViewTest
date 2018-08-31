//
//  BaseImageAutoScrollViewController.swift
//  ScrollViewTest
//
//  Created by chenchen on 2018/8/29.
//  Copyright © 2018年 for_minho. All rights reserved.
//

import Foundation
class BaseImageAutoScrollViewController: UIViewController {
    var images = [String]() {
        didSet {
            autoScrollView.setImages(forScrollView: images)
        }
    }
    
    private lazy var autoScrollView: PictureAutoScrollView = {
        let view = PictureAutoScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.addSubview(autoScrollView)
        autoScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        autoScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        autoScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        autoScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
