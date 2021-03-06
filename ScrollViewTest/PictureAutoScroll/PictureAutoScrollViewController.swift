import Foundation
class PictureAutoScrollViewController: UIViewController {
    struct Constants {
        static let mainTableViewCellIdentifier = "mainTableViewCellIdentifier"
        static let subTableViewCellIdentifier = "subTableViewCellIdentifier"
    }
    
    private var canScroll: Bool = true
    
    private lazy var pictureAutoScrollView: PictureAutoScrollView = {
        let view = PictureAutoScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainTableView: BaseTableView = {
        let tableView = BaseTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.mainTableViewCellIdentifier)
        tableView.register(SubTableViewCell.self, forCellReuseIdentifier: Constants.subTableViewCellIdentifier)
        return tableView
    }()
    
    private lazy var collectionViewController: BaseCollectioViewController = {
        let viewController = BaseCollectioViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    private lazy var subTableViewController: PictureAutoSubTableViewController = {
        let tableViewController = PictureAutoSubTableViewController()
        tableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return tableViewController
    }()
    
    private lazy var subTableData: [String] = {
        var array = [String]()
        for index in 0...25 {
            array.append(String(index) + " ———— subTableData")
        }
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(mainTableView)
        if #available(iOS 11.0, *) {
            mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            mainTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
    
    @objc func changeStatusWithNotification(_ notification: Notification) {
        canScroll = true
        subTableViewController.canScroll = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var autoScrollViewArray = [String]()
        for index in 0...3 {
            autoScrollViewArray.append("image"+String(index)+".jpg")
        }
        pictureAutoScrollView.setImages(forScrollView: autoScrollViewArray)

        mainTableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
    }
}

extension PictureAutoScrollViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 200
        }
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.layoutFrame.height
        }
        return view.frame.height
    }
}

extension PictureAutoScrollViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let dequeueCell = tableView.dequeueReusableCell(withIdentifier: Constants.mainTableViewCellIdentifier, for: indexPath)
            dequeueCell.contentView.addSubview(pictureAutoScrollView)
            pictureAutoScrollView.topAnchor.constraint(equalTo: dequeueCell.topAnchor).isActive = true
            pictureAutoScrollView.bottomAnchor.constraint(equalTo: dequeueCell.bottomAnchor).isActive = true
            pictureAutoScrollView.leadingAnchor.constraint(equalTo: dequeueCell.leadingAnchor).isActive = true
            pictureAutoScrollView.trailingAnchor.constraint(equalTo: dequeueCell.trailingAnchor).isActive = true

            pictureAutoScrollView.widthAnchor.constraint(equalToConstant: dequeueCell.frame.width).isActive = true
            pictureAutoScrollView.heightAnchor.constraint(equalToConstant: dequeueCell.frame.height).isActive = true
            return dequeueCell
        } else {
            let dequeueCell = tableView.dequeueReusableCell(withIdentifier: Constants.subTableViewCellIdentifier, for: indexPath)
            dequeueCell.contentView.addSubview(collectionViewController.view)
            collectionViewController.view.trailingAnchor.constraint(equalTo: dequeueCell.trailingAnchor).isActive = true
            collectionViewController.view.leadingAnchor.constraint(equalTo: dequeueCell.leadingAnchor).isActive = true
            collectionViewController.view.topAnchor.constraint(equalTo: dequeueCell.topAnchor).isActive = true
            collectionViewController.view.bottomAnchor.constraint(equalTo: dequeueCell.bottomAnchor).isActive = true
            collectionViewController.view.widthAnchor.constraint(equalTo: dequeueCell.widthAnchor).isActive = true
            collectionViewController.view.heightAnchor.constraint(equalTo: dequeueCell.heightAnchor).isActive = true
            subTableViewController.subTableData = subTableData
//            collectionViewController.dataSource = [subTableView]
            return dequeueCell
        }
    }
}

extension PictureAutoScrollViewController: UIScrollViewDelegate {
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomY: CGFloat = mainTableView.rectForRow(at: IndexPath(row: 1, section: 0)).origin.y
        NSLog("bottomY = \(bottomY)")
        if scrollView.contentOffset.y >= bottomY {
            scrollView.contentOffset = CGPoint(x: 0, y: bottomY)
            if canScroll {
                canScroll = false
                subTableViewController.canScroll = true
            }
        } else {
            if !canScroll {
                scrollView.contentOffset = CGPoint(x: 0, y: bottomY)
            }
        }
        
        mainTableView.showsVerticalScrollIndicator = canScroll
    }
}
