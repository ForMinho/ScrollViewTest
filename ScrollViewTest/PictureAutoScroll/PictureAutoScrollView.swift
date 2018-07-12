import Foundation

class PictureAutoScrollView: UIView {
    private var images = [String]()
    private var imageViews = [UIImageView]()
    private var beginContentOffsetX: CGFloat = 0
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = UIColor.gray
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
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
        var images = images
        pageControl.numberOfPages = images.count
        if let firstImage = images.first, let lastImage = images.last {
            images.insert(lastImage, at: 0)
            images.insert(firstImage, at: images.count)
        }
       
        self.images = images

        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(images.count), height: scrollView.frame.height)
        for index in 0..<images.count {
            let imageView = UIImageView(frame: CGRect(x: scrollView.frame.size.width * CGFloat(index), y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            imageView.image = UIImage(named: images[index])
            imageViews.append(imageView)
            scrollView.addSubview(imageView)
        }
        pageControl.currentPage = 0
        scrollView.scrollRectToVisible(CGRect(x: scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height), animated: false)
        initStartTImer()
    }
    
    private func moveToImageVeiw(_ index: Int, animated: Bool = false) {
        var currnetPage = index
        if index == -1 {
            currnetPage = pageControl.numberOfPages - 1
            scrollView.contentOffset = CGPoint(x: scrollView.frame.width * CGFloat(pageControl.numberOfPages), y: 0)
        } else if index == pageControl.numberOfPages {
            currnetPage = 0
            scrollView.contentOffset = CGPoint(x: scrollView.frame.width, y: 0)
        }
        scrollView.scrollRectToVisible(CGRect(x: scrollView.frame.width * CGFloat(currnetPage + 1), y: 0, width: scrollView.frame.width, height: scrollView.frame.height), animated: true)
        pageControl.currentPage = currnetPage
    }
}

extension PictureAutoScrollView {
    @objc private func autoScrollTimerAction(_ timer: Timer) {
//        scrollView.scrollRectToVisible(CGRect(x: scrollView.frame.width * CGFloat(pageControl.currentPage + 1), y: 0, width: scrollView.frame.width, height: scrollView.frame.height), animated: true)

        moveToImageVeiw(pageControl.currentPage + 1)
    }
    
    private func initStartTImer() {
        invalidateTimer()
        autoScrollTimer = Timer.init(timeInterval: 1.5, target: self, selector: #selector(autoScrollTimerAction(_:)), userInfo: nil, repeats: true)
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
        beginContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endContentOffsetX = scrollView.contentOffset.x
        
        if endContentOffsetX > beginContentOffsetX && endContentOffsetX - beginContentOffsetX >= scrollView.frame.width / 2 {
            moveToImageVeiw(min(pageControl.currentPage + 1, images.count))

        } else if endContentOffsetX < beginContentOffsetX && beginContentOffsetX - endContentOffsetX >= scrollView.frame.width / 2{
            moveToImageVeiw(max(pageControl.currentPage - 1, -1))
        } else {

        }
        
        initStartTImer()
    }
}
