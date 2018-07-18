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
        return tableView
    }()
    
    private lazy var subTableView: PictureAutoSubTableView = {
        let tableView = PictureAutoSubTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var subTableData: [String] = {
        var array = [String]()
        for index in 0...20 {
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeStatusWithNotification(_:)), name: PictureAutoSubTableView.subTableViewToTop, object: subTableView)
    }
    
    @objc func changeStatusWithNotification(_ notification: Notification) {
        canScroll = true
        subTableView.canScroll = false
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
        let dequeueCell = tableView.dequeueReusableCell(withIdentifier: Constants.mainTableViewCellIdentifier, for: indexPath)
        if indexPath.row == 0 {
            dequeueCell.contentView.addSubview(pictureAutoScrollView)
            pictureAutoScrollView.topAnchor.constraint(equalTo: dequeueCell.topAnchor).isActive = true
            pictureAutoScrollView.bottomAnchor.constraint(equalTo: dequeueCell.bottomAnchor).isActive = true
            pictureAutoScrollView.leadingAnchor.constraint(equalTo: dequeueCell.leadingAnchor).isActive = true
            pictureAutoScrollView.trailingAnchor.constraint(equalTo: dequeueCell.trailingAnchor).isActive = true

            pictureAutoScrollView.widthAnchor.constraint(equalToConstant: dequeueCell.frame.width).isActive = true
            pictureAutoScrollView.heightAnchor.constraint(equalToConstant: dequeueCell.frame.height).isActive = true
        } else {
            dequeueCell.contentView.addSubview(subTableView)
            subTableView.trailingAnchor.constraint(equalTo: dequeueCell.trailingAnchor).isActive = true
            subTableView.leadingAnchor.constraint(equalTo: dequeueCell.leadingAnchor).isActive = true
            subTableView.topAnchor.constraint(equalTo: dequeueCell.topAnchor).isActive = true
            subTableView.bottomAnchor.constraint(equalTo: dequeueCell.bottomAnchor).isActive = true
            subTableView.widthAnchor.constraint(equalTo: dequeueCell.widthAnchor).isActive = true
            subTableView.heightAnchor.constraint(equalTo: dequeueCell.heightAnchor).isActive = true
            subTableView.subTableData = subTableData
        }
        return dequeueCell
    }
}

extension PictureAutoScrollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 200 {
            scrollView.contentOffset = CGPoint(x: 0, y: 200)
            if canScroll {
                canScroll = false
                subTableView.canScroll = true
            }
        } else {
            if !canScroll {
                scrollView.contentOffset = CGPoint(x: 0, y: 200)
            }
        }
    }
}
