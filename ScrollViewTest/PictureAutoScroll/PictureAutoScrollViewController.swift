import Foundation
class PictureAutoScrollViewController: UIViewController {
    struct Constants {
        static let mainTableViewCellIdentifier = "mainTableViewCellIdentifier"
        static let subTableViewCellIdentifier = "subTableViewCellIdentifier"
    }
    private lazy var pictureAutoScrollView: PictureAutoScrollView = {
        let view = PictureAutoScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.mainTableViewCellIdentifier)
        return tableView
    }()
    
    private lazy var subTableView: BaseTableView = {
        let tableView = BaseTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.subTableViewCellIdentifier)
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
        view.addSubview(mainTableView)
        if #available(iOS 11.0, *) {
            mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
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
        if tableView.isEqual(mainTableView) {
            if indexPath.row == 0{
                return 200
            }
            return view.frame.height - 200
        }
        return 44
    }
}

extension PictureAutoScrollViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(mainTableView) {
            return 2
        }
        return subTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEqual(mainTableView) {
            let dequeueCell = tableView.dequeueReusableCell(withIdentifier: Constants.mainTableViewCellIdentifier, for: indexPath)
            if indexPath.row == 0 {
                dequeueCell.contentView.addSubview(pictureAutoScrollView)
                pictureAutoScrollView.centerXAnchor.constraint(equalTo: dequeueCell.centerXAnchor).isActive = true
                pictureAutoScrollView.centerYAnchor.constraint(equalTo: dequeueCell.centerYAnchor).isActive = true
                pictureAutoScrollView.widthAnchor.constraint(equalToConstant: dequeueCell.frame.width).isActive = true
                pictureAutoScrollView.heightAnchor.constraint(equalToConstant: dequeueCell.frame.height).isActive = true
            } else {
                dequeueCell.contentView.addSubview(subTableView)
                subTableView.trailingAnchor.constraint(equalTo: dequeueCell.trailingAnchor).isActive = true
                subTableView.leadingAnchor.constraint(equalTo: dequeueCell.leadingAnchor).isActive = true
                subTableView.topAnchor.constraint(equalTo: dequeueCell.topAnchor).isActive = true
                subTableView.bottomAnchor.constraint(equalTo: dequeueCell.bottomAnchor).isActive = true
            }
            return dequeueCell
        }
        let subTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.subTableViewCellIdentifier, for: indexPath)
        subTableViewCell.textLabel?.text = subTableData[indexPath.row]
        return subTableViewCell
    }
}
