import Foundation
class ZCCollectioViewController: BaseViewController {
    private struct Constants {
        static let collctionViewCellIdentifier = "collctionViewCellIdentifier"
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .green
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.collctionViewCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var dataSource = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func setupView() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func createLabel(indexPath: IndexPath) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = dataSource[indexPath.row]
        label.textAlignment = .center
        label.backgroundColor = .gray
        return label
    }
}

extension ZCCollectioViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collctionViewCellIdentifier, for: indexPath)
        let label = createLabel(indexPath: indexPath)
        cell.contentView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
}

extension ZCCollectioViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

