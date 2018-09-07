import Foundation
class BaseMainScrollViewController: UIViewController {
    var imageArray = [String]()
    var continerViewArray = [UIViewController]() {
        didSet {
            refreshContainerViewNames()
        }
    }
    
    private var containerViewNames = [String]()
    
    static let cellIdentifier = "CellIdentifier"
    var canScroll: Bool = true

    private var webViewHeight: CGFloat = 0
    private let imageViewHeight: CGFloat = 300
    
    private lazy var baseMainContainerViewCell: BaseMainContainerViewCell = {
        let view = BaseMainContainerViewCell(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageAutoScrollViewController: BaseImageAutoScrollViewController = {
        let viewController = BaseImageAutoScrollViewController(nibName: nil, bundle: nil)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    private lazy var tableView: BaseTableView = {
        let tableView = BaseTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: BaseMainScrollViewController.cellIdentifier)
        return tableView
    }()
    
    private lazy var segmentView: BaseSegmentView = {
        let segmentView = BaseSegmentView(frame: .zero)
        
        return segmentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewHeight = view.frame.height
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeStatusWithNotification(_:)), name: BaseViewController.BaseViewControllerToTop, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateScrollView(_:)), name: BaseMainContainerViewCell.baseMainContainerViewCellNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateScrollView(_:)), name: PictureAutoScrollView.pictureAutoScrollViewNotification, object: nil)
    }
    
    @objc func changeStatusWithNotification(_ notification: Notification) {
        canScroll = true
        baseMainContainerViewCell.canScroll = false
    }
    
    @objc func updateScrollView(_ notification: Notification) {
        guard case let info as String = notification.userInfo?["canScroll"] else { return }
        tableView.isScrollEnabled = info == "1" ? true : false
    }
    
    private func refreshContainerViewNames() {
        var array = [String]()
        for viewController in continerViewArray {
            if let title = viewController.title {
                array.append(title)
            }
        }
        containerViewNames = array
    }
}

extension BaseMainScrollViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return imageViewHeight
        }
        return webViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension BaseMainScrollViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseMainScrollViewController.cellIdentifier, for: indexPath)
        if indexPath.section == 0, indexPath.row == 0 {
            cell.contentView.addSubview(imageAutoScrollViewController.view)
            imageAutoScrollViewController.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            imageAutoScrollViewController.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            imageAutoScrollViewController.view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
            imageAutoScrollViewController.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
            imageAutoScrollViewController.images = imageArray
        } else {
            cell.contentView.addSubview(baseMainContainerViewCell)
            baseMainContainerViewCell.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            baseMainContainerViewCell.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
            baseMainContainerViewCell.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            baseMainContainerViewCell.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
            baseMainContainerViewCell.dataSource = continerViewArray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            segmentView.updateSegmentView(withDataSource: containerViewNames)
            return segmentView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

extension BaseMainScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= imageViewHeight {
            scrollView.contentOffset = CGPoint(x: 0, y: imageViewHeight)
            if canScroll {
                canScroll = false
                baseMainContainerViewCell.canScroll = true
            }
        } else {
            if !canScroll {
                scrollView.contentOffset = CGPoint(x: 0, y: imageViewHeight)
            }
        }
        scrollView.showsVerticalScrollIndicator = canScroll ? true : false
    }
}

