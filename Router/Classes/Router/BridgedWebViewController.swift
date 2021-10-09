//
//  BridgedWebViewController.swift
//  RouterDemo
//
//  Created by buff on 2021/9/23.
//

import UIKit
import WebKit

class BridgedWebViewController: UIViewController {
    
    open var webView: WKWebView!
    
    open var webViewCornerRadius: CGFloat = 0
    
    open var webViewHeight: CGFloat = UIScreen.main.bounds.size.height

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


extension BridgedWebViewController {
    var url: String? {
        get {
            return ""
        }
    }
    
    var userAgent: String {
        get {
            return ""
        }
    }
}

extension BridgedWebViewController {
    open func load(html: String) {
        
    }
    
    open func load(urlStr: String) {
        
    }
    
    open func load(content: String) {
        
    }
    
    open func reload(url: URL) {
        
    }
}
