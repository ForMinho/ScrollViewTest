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
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let view = UIPageControl(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        self.images = images
        pageControl.numberOfPages = images.count
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(images.count), height: scrollView.frame.height)
        for index in 0..<images.count {
            let imageView = UIImageView(frame: CGRect(x: scrollView.frame.size.width * CGFloat(index), y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            imageView.image = UIImage(named: images[index])
            imageViews.append(imageView)
            scrollView.addSubview(imageView)
        }
    }
    
    private func moveToImageVeiw(_ index: Int) {
        guard index != pageControl.currentPage else { return }
        pageControl.currentPage = index
        scrollView.scrollRectToVisible(CGRect(x: scrollView.frame.width * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height), animated: true)
    }
}

extension PictureAutoScrollView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beginContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endContentOffsetX = scrollView.contentOffset.x
        
        if endContentOffsetX > beginContentOffsetX && endContentOffsetX - beginContentOffsetX >= scrollView.frame.width / 2 {
            moveToImageVeiw(min(pageControl.currentPage + 1, images.count - 1))
            
        } else if endContentOffsetX < beginContentOffsetX && beginContentOffsetX - endContentOffsetX >= scrollView.frame.width / 2{
            moveToImageVeiw(max(pageControl.currentPage - 1, 0))
        } else {
            
        }
    }
}
