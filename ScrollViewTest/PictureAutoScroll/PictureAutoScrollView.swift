import Foundation

class PictureAutoScrollView: UIView {
    private var images = [String]()
    private var imageViews = [UIImageView]()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
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
        
        pageControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -30).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImages(forScrollView images: [String]) {
        self.images = images
        pageControl.numberOfPages = images.count
        for index in 0..<images.count {
            let imageView = UIImageView(frame: .zero)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: images[index])
            imageViews.append(imageView)
            scrollView.addSubview(imageView)
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: scrollView.frame.width * CGFloat(index + 1)).isActive = true
            imageView.trailingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: scrollView.frame.width).isActive = true
        }
    }
}

extension PictureAutoScrollView: UIScrollViewDelegate {
    
}
