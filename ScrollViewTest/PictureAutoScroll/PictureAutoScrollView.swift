import Foundation

class PictureAutoScrollView: UIView {
    private var images = [String]()
    private var currentIndex: Int = 0
    var duration: Double = 2.0
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = UIColor.gray
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.addSubview(previousImageView)
        scrollView.addSubview(currentImageView)
        scrollView.addSubview(nextImageView)
        
        previousImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        previousImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        previousImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        previousImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0).isActive = true
        previousImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 0).isActive = true
        
        currentImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        currentImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        currentImageView.leadingAnchor.constraint(equalTo: previousImageView.trailingAnchor).isActive = true
        currentImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        currentImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        nextImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        nextImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        nextImageView.leadingAnchor.constraint(equalTo: currentImageView.trailingAnchor).isActive = true
        nextImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        nextImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        nextImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        return scrollView
    }()
    
    private lazy var previousImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = UIColor.black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var currentImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nextImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let view = UIPageControl(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var autoScrollTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        addSubview(pageControl)
        scrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        pageControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImages(forScrollView images: [String]) {
        guard images.count > 0 else { return }
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        self.images = images
        
        if images.count <= 1 {
            scrollView.isScrollEnabled = false
        } else {
            initStartTImer()
        }
        refreshCurrentImageView()
    }

}

extension PictureAutoScrollView {
    private func refreshCurrentIndex() {
        if scrollView.contentOffset.x >= scrollView.bounds.width * 2 {
            currentIndex = currentIndex + 1
        } else if scrollView.contentOffset.x <= scrollView.bounds.width * 0.5 {
            currentIndex = currentIndex - 1
        }
        
        if currentIndex < 0 {
            currentIndex = images.count - 1
        } else if currentIndex >= images.count {
            currentIndex = 0
        }
    }
    
    private func refreshCurrentImageView() {
        loadImageView(currentImageView, imageName: images[currentIndex])
        
        let previousIndex = currentIndex - 1 < 0 ? images.count - 1 : currentIndex - 1
        loadImageView(previousImageView, imageName: images[previousIndex])
        
        let nextIndex = currentIndex + 1 >= images.count ? 0 : currentIndex + 1
        loadImageView(nextImageView, imageName: images[nextIndex])
        
        scrollView.contentOffset = CGPoint(x: scrollView.frame.width, y: 0)
    }
    
    private func loadImageView(_ imageView: UIImageView, imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
}

extension PictureAutoScrollView {
    @objc private func autoScrollTimerAction(_ timer: Timer) {
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * 2, y: 0), animated: true)
    }
    
    private func initStartTImer() {
        invalidateTimer()
        autoScrollTimer = Timer.init(timeInterval: duration, target: self, selector: #selector(autoScrollTimerAction(_:)), userInfo: nil, repeats: true)
        if let autoScrollTimer = autoScrollTimer {
            RunLoop.current.add(autoScrollTimer, forMode: .commonModes)
        }
    }
    
    private func invalidateTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
}

extension PictureAutoScrollView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        refreshCurrentIndex()
        if currentIndex != pageControl.currentPage {
            pageControl.currentPage = currentIndex
            refreshCurrentImageView()
        }
        initStartTImer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        refreshCurrentIndex()
        if currentIndex != pageControl.currentPage {
            pageControl.currentPage = currentIndex
            refreshCurrentImageView()
        }
    }
}
