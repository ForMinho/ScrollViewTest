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
    var showSegmentView: Bool = true {
        didSet {
            baseMainContainerViewCell.showSegmentView = showSegmentView
        }
    }
    
    private var webViewHeight: CGFloat = 0
    private let imageViewHeight: CGFloat = 300
    
    private lazy var baseMainContainerViewCell: BaseMainContainerViewCell = {
        let view = BaseMainContainerViewCell(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showSegmentView = showSegmentView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewHeight = view.safeAreaLayoutGuide.layoutFrame.height
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeStatusWithNotification(_:)), name: BaseViewController.BaseViewControllerToTop, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateScrollView(_:)), name: BaseMainContainerViewCell.baseMainContainerViewCellNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateScrollView(_:)), name: PictureAutoScrollView.pictureAutoScrollViewNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateScrollView(_:)), name: BaseSegmentView.baseSegmentViewScrolledNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        if indexPath.row == 0 {
            return imageViewHeight
        }
        return tableView.frame.height
    }
}

extension BaseMainScrollViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseMainScrollViewController.cellIdentifier, for: indexPath)
        if indexPath.row == 0 {
            cell.contentView.addSubview(imageAutoScrollViewController.view)
            imageAutoScrollViewController.view.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            imageAutoScrollViewController.view.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
            imageAutoScrollViewController.view.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            imageAutoScrollViewController.view.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            imageAutoScrollViewController.images = imageArray
        } else {
            cell.contentView.addSubview(baseMainContainerViewCell)
            baseMainContainerViewCell.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            baseMainContainerViewCell.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
            baseMainContainerViewCell.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            baseMainContainerViewCell.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
            baseMainContainerViewCell.dataSource = continerViewArray
            baseMainContainerViewCell.containerViewNames = containerViewNames
        }
        return cell
    }
}

extension BaseMainScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let commonScrollHeight = imageViewHeight
        if scrollView.contentOffset.y >= commonScrollHeight {
            scrollView.contentOffset = CGPoint(x: 0, y: commonScrollHeight)
            if canScroll {
                canScroll = false
                baseMainContainerViewCell.canScroll = true
            }
        } else {
            if !canScroll {
                scrollView.contentOffset = CGPoint(x: 0, y: commonScrollHeight)
            }
        }
        scrollView.showsVerticalScrollIndicator = canScroll ? true : false
    }
}
