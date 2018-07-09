import Foundation
class PictureAutoScrollViewController: UIViewController {
    struct Constants {
        static let tableViewCellIdentifier = "tableViewCellIdentifier"
    }
    private lazy var pictureAutoScrollView: PictureAutoScrollView = {
        let view = PictureAutoScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.tableViewCellIdentifier)
        return tableView
    }()
    
    private lazy var subTableView: BaseTableView = {
       let tableView = BaseTableView(frame: .zero, style: .plain)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PictureAutoScrollViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 200
        }
        return view.frame.height - 200
    }
}

extension PictureAutoScrollViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeueCell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellIdentifier, for: indexPath)
        if indexPath.row == 0 {
            dequeueCell.contentView.addSubview(pictureAutoScrollView)
            pictureAutoScrollView.centerXAnchor.constraint(equalTo: dequeueCell.centerXAnchor).isActive = true
            pictureAutoScrollView.centerYAnchor.constraint(equalTo: dequeueCell.centerYAnchor).isActive = true
            pictureAutoScrollView.widthAnchor.constraint(equalTo: dequeueCell.widthAnchor).isActive = true
            pictureAutoScrollView.heightAnchor.constraint(equalTo: dequeueCell.heightAnchor).isActive = true
        } else {
            
        }
        return dequeueCell
    }
}
