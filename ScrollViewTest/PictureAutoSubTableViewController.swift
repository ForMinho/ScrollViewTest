import Foundation

class PictureAutoSubTableViewController: BaseViewController {
    struct Constants {
        static let tableCellIdentifier = "tableCellIdentifier"
    }
    
    var subTableData = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var footView: MJRefreshAutoNormalFooter = {
        return MJRefreshAutoNormalFooter(refreshingBlock: {
            self.fetchMoreData()
        })
    }()
    
    private(set) lazy var tableView: BaseTableView = {
        let tableView = BaseTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.tableCellIdentifier)
        tableView.tableFooterView = footView
        return tableView
    }()
    
    override func setupView() {
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func fetchMoreData() {
        NSLog(" ------- fetchMoreData()")

        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            var array = [String]()
            for index in 0...5 {
                array.append(String(index) + " ———— subTableData")
            }
            DispatchQueue.main.async {
                self.subTableData.append(contentsOf: array)
                self.footView.endRefreshing()
            }
        })
    }
}

extension PictureAutoSubTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension PictureAutoSubTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeueCell = tableView.dequeueReusableCell(withIdentifier: Constants.tableCellIdentifier, for: indexPath)
        dequeueCell.textLabel?.text = subTableData[indexPath.row]
        return dequeueCell
    }
}
