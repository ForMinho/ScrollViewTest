//
//  BaseImageAutoScrollViewController.swift
//  ScrollViewTest
//
//  Created by chenchen on 2018/8/29.
//  Copyright © 2018年 for_minho. All rights reserved.
//

import Foundation
class ImagePageFlowViewController: UIViewController {
    var images = [String]() {
        didSet {
            imagePageFlowView.setImages(forScrollView: images)
        }
    }
    
    private lazy var imagePageFlowView: ImagePageFlowView = {
        let configuration = ImagePageFlowConfiguration(currentIndex: 2, duration: 2.0)
        let view = ImagePageFlowView(frame: .zero, configuration: configuration)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.addSubview(imagePageFlowView)
        imagePageFlowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imagePageFlowView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imagePageFlowView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imagePageFlowView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ImagePageFlowViewController: ImagePageFlowViewDelegate {
    func imagePageFlowViewDidClickedImage(_ imagePageFlowView: ImagePageFlowView, selectedIndex: Int) {
        let OKAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alertController = UIAlertController(title: "select the image", message: "clicked \(selectedIndex)", preferredStyle: .alert)
        alertController.addAction(OKAlert)
        show(alertController, sender: self)
    }
}
