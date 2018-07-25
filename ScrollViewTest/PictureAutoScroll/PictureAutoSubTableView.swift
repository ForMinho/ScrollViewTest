import Foundation

class PictureAutoSubTableView: UIView {
    static let subTableViewToTop = Notification.Name("subTableViewToTop")
    struct Constants {
        static let tableCellIdentifier = "tableCellIdentifier"
    }
    var canScroll: Bool = false
    var subTableData = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.tableCellIdentifier)
        tableView.tableFooterView = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.fetchMoreData()
        })
        tableView.bounces = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func fetchMoreData() {
        NSLog(" ------- fetchMoreData()")
    }
}

extension PictureAutoSubTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension PictureAutoSubTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeueCell = tableView.dequeueReusableCell(withIdentifier: Constants.tableCellIdentifier, for: indexPath)
        dequeueCell.textLabel?.text = subTableData[indexPath.row]
        return dequeueCell
    }
}

extension PictureAutoSubTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !canScroll {
            scrollView.contentOffset = .zero
        }
        if scrollView.contentOffset.y <= 0 {
            canScroll = false
            scrollView.contentOffset = .zero
            NotificationCenter.default.post(name: PictureAutoSubTableView.subTableViewToTop, object: self)
        }
        tableView.showsVerticalScrollIndicator = canScroll
    }
}
