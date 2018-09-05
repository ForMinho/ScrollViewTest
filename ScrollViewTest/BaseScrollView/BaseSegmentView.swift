//
//  BaseSegmentView.swift
//  ScrollViewTest
//
//  Created by chenchen on 2018/9/5.
//  Copyright © 2018年 for_minho. All rights reserved.
//

import Foundation

protocol BaseSegmentViewDelegate: class {
    func baseSegmentViewDidSelectedSegment(_ baseSegmentView: BaseSegmentView, selectedIndex: Int)
}

class BaseSegmentView: UIView {
    private struct Constants {
        static let titleButtonWidth: CGFloat = 50
    }
    
    private(set) var currentIndex: Int = 0
    
    private var dataSource = [String]()
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .red
        
        addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func updateSegmentView(withDataSource dataSource: [String]) {
        guard dataSource.count > 0 else { return }
        var preTitleButton: UIButton?
        var currentTitleButton = UIButton()
        for title in dataSource {
            currentTitleButton = createTitleButton(title)
            if let preTitleButton = preTitleButton {
                currentTitleButton.leadingAnchor.constraint(equalTo: preTitleButton.trailingAnchor).isActive = true
            } else {
                currentTitleButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            }
            preTitleButton = currentTitleButton
        }
        currentTitleButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    }
    
    private func createTitleButton(_ title: String) -> UIButton {
        let titleButton = UIButton(type: .custom)
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        titleButton.setTitle(title, for: .normal)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.setTitleColor(.red, for: .selected)
        titleButton.addTarget(self, action: #selector(titleButtonPressed(_:)), for: .touchUpInside)
        scrollView.addSubview(titleButton)
        
        titleButton.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        titleButton.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        titleButton.widthAnchor.constraint(equalToConstant: Constants.titleButtonWidth).isActive = true
        titleButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        return titleButton
    }
    
    @objc private func titleButtonPressed(_ sender: UIButton) {
        
    }
}

extension BaseSegmentView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
