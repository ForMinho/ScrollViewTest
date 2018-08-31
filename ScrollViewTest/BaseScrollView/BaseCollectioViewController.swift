import Foundation
class BaseCollectioViewController: UIViewController {
    static let baseCollectioViewControllerNotification = Notification.Name("baseCollectioViewControllerNotification")
    
    weak var superViewController: UIViewController?
    private struct Constants {
        static let collctionViewCellIdentifier = "collctionViewCellIdentifier"
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.collctionViewCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    var dataSource = [UIViewController]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var canScroll: Bool = false {
        didSet {
           refreshSubViewControllerScroll()
        }
    }
    
    private func refreshSubViewControllerScroll() {
        for viewController in dataSource {
            if let baseViewController = viewController as? BaseViewController {
                baseViewController.canScroll = canScroll
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension BaseCollectioViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collctionViewCellIdentifier, for: indexPath)
        let viewController = dataSource[indexPath.row]
        cell.addSubview(viewController.view)
        viewController.view.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        viewController.view.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        viewController.view.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
}

extension BaseCollectioViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension BaseCollectioViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: BaseCollectioViewController.baseCollectioViewControllerNotification, object: nil, userInfo: ["canScroll": "0"])
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        NotificationCenter.default.post(name: BaseCollectioViewController.baseCollectioViewControllerNotification, object: nil, userInfo: ["canScroll": "1"])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
