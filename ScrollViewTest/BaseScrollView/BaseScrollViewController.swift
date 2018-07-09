import Foundation
class BaseScrollViewController: UIViewController {
    static let cellIdentifier = "CellIdentifier"
    private var canScroll: Bool = true

    private var webViewHeight: CGFloat = 0
    private let imageViewHeight: CGFloat = 300
    
    private var baseWebView: BaseWebView = {
        let webView = BaseWebView(frame: .zero)
        webView.load(URLRequest(url: URL(string: "https://www.baidu.com")!))
        return webView
    }()
    
    private lazy var tableView: BaseTableView = {
        let tableView = BaseTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: BaseScrollViewController.cellIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewHeight = view.frame.height
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeStatusWithNotification(_:)), name: BaseWebView.BaseWebViewToTop, object: baseWebView)
    }
    
    @objc func changeStatusWithNotification(_ notification: Notification) {
        canScroll = true
        baseWebView.canScroll = false
    }
}

extension BaseScrollViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return imageViewHeight
        }
        return webViewHeight
    }
}

extension BaseScrollViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseScrollViewController.cellIdentifier, for: indexPath)
        if indexPath.row == 0 {
            let imageView = UIImageView(image: UIImage(named: "image0.jpg"))
            imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: imageViewHeight)
            cell.contentView.addSubview(imageView)
        } else {
            cell.contentView.addSubview(baseWebView)
            baseWebView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: webViewHeight)
        }
        return cell
    }
}

extension BaseScrollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSLog("BaseViewController__scrollViewDidScroll:")
        if  !canScroll {
            scrollView.contentOffset = CGPoint(x: 0, y: imageViewHeight)
        }
        if scrollView.contentOffset.y >= imageViewHeight {
            scrollView.contentOffset = CGPoint(x: 0, y: imageViewHeight)
            canScroll = false
            baseWebView.canScroll = true
        }
    }
}

