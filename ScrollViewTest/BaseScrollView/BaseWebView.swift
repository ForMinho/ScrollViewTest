import Foundation
import WebKit

class BaseWebView: WKWebView {
    static let BaseWebViewToTop = Notification.Name("BaseWebViewToTop")
    var canScroll: Bool = false

    init(frame: CGRect) {
        super.init(frame: frame, configuration: WKWebViewConfiguration())
        scrollView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseWebView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSLog("BaseWebView__scrollViewDidScroll:")
        if !canScroll {
            scrollView.contentOffset = .zero
        }
        if scrollView.contentOffset.y <= 0 {
            canScroll = false
            scrollView.contentOffset = .zero
            NotificationCenter.default.post(name: BaseWebView.BaseWebViewToTop, object: self)
        }
    }
}

