import Foundation

class StartViewController: UIViewController {
   
    private struct Constants {
        static let tableCellIdentifier = "BaseTableViewCellIdentifier"
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self , forCellReuseIdentifier: Constants.tableCellIdentifier)
        return tableView
    }()
    
    private lazy var tableViewContents = ["基础滚动", "视频滚动", "图片滚动", "复合式滚动"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "StartViewController"
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension StartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension StartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableCellIdentifier, for: indexPath)
        cell.textLabel?.text = tableViewContents[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        switch row {
        case 0:
            let viewController = BaseScrollViewController()
            viewController.title = tableViewContents[row]
            navigationController?.pushViewController(viewController, animated: true)
        case 2:
            let viewController = PictureAutoScrollViewController()
            viewController.title = tableViewContents[row]
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}
