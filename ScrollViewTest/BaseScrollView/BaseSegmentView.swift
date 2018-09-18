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
    static let baseSegmentViewScrolledNotification = Notification.Name("baseSegmentViewScrolledNotification")
    private struct Constants {
        static let titleButtonWidth: CGFloat = 150
    }
    
    private(set) var currentIndex: Int = 0
    {
        didSet {
            guard currentIndex != oldValue else { return }
            updateSegmentViewAfterCurrentIndexChanged()
        }
    }
    
    weak var delegate: BaseSegmentViewDelegate?
    var dataSource = [String]()
    private lazy var buttonsArray = [UIButton]()
    
    private lazy var selectedUnderLineView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var selectedUnderLineLeadingAnchor: NSLayoutConstraint = {
        return selectedUnderLineView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor)
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var topDividerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var bottomDividerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func currentPageChanged(withCurrentInde index: Int) {
        guard index < dataSource.count else { return }
        currentIndex = index
        resetAllButtons()
        let button = buttonsArray[index]
        button.isSelected = true
    }
    
    func updateSegmentView(withDataSource source: [String]) {
        guard source.count > 0 else { return }
        dataSource = source
        for title in dataSource {
            createTitleButton(title)
        }
        currentPageChanged(withCurrentInde: currentIndex)
        updateSegmentViewAfterCurrentIndexChanged()
    }
}

extension BaseSegmentView {
    private func setupViews() {
        addSubview(topDividerView)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(selectedUnderLineView)
        addSubview(bottomDividerView)
        
        topDividerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topDividerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topDividerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: heightAnchor, constant: -2).isActive = true
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        bottomDividerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomDividerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomDividerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        selectedUnderLineView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        selectedUnderLineView.widthAnchor.constraint(equalToConstant: Constants.titleButtonWidth).isActive = true
        selectedUnderLineView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        selectedUnderLineLeadingAnchor.isActive = true
    }
    
    private func createTitleButton(_ title: String) {
        let titleButton = UIButton(type: .custom)
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        titleButton.setTitle(title, for: .normal)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.setTitleColor(.red, for: .selected)
        titleButton.addTarget(self, action: #selector(titleButtonPressed(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(titleButton)
        
        //frame
        titleButton.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        titleButton.widthAnchor.constraint(equalToConstant: Constants.titleButtonWidth).isActive = true
        
        buttonsArray.append(titleButton)
    }
    
    @objc private func titleButtonPressed(_ sender: UIButton) {
        resetAllButtons()
        currentIndex = findTitleButtonInde(sender) ?? 0
        sender.isSelected = true
        delegate?.baseSegmentViewDidSelectedSegment(self, selectedIndex: currentIndex)
    }
    
    private func resetAllButtons() {
        for button in buttonsArray {
            button.isSelected = false
        }
    }
    
    private func findTitleButtonInde(_ button: UIButton) -> Int? {
        var index: Int?
        index = buttonsArray.index(where: {$0 == button})
        return index
    }
    
    private func updateSegmentViewAfterCurrentIndexChanged() {
        scrollView.scrollRectToVisible(CGRect(x: Constants.titleButtonWidth * CGFloat(currentIndex), y: 0, width: Constants.titleButtonWidth, height: scrollView.frame.width), animated: true)
        UIView.animate(withDuration: 0.25, animations: {
            self.selectedUnderLineLeadingAnchor.constant = CGFloat(self.currentIndex) * Constants.titleButtonWidth
        })
    }
}

extension BaseSegmentView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: BaseSegmentView.baseSegmentViewScrolledNotification, object: nil, userInfo: ["canScroll": "0"])
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        NotificationCenter.default.post(name: BaseSegmentView.baseSegmentViewScrolledNotification, object: nil, userInfo: ["canScroll": "1"])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: BaseSegmentView.baseSegmentViewScrolledNotification, object: nil, userInfo: ["canScroll": "1"])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
