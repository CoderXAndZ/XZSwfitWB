//
//  XZWebViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2018/1/11.
//  Copyright © 2018年 XZ. All rights reserved.
//  网页控制器

import UIKit
import SVProgressHUD

class XZWebViewController: XZBaseViewController {
    
    private lazy var webView = UIWebView(frame: UIScreen.main.bounds)

    /// 要加载的 UTL 字符串
    var urlString: String? {
        didSet {
            guard let urlString = urlString,
                let url = URL.init(string: urlString)
                else {
                return
            }
            
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}

extension XZWebViewController: UIWebViewDelegate {
    
//    func webViewDidStartLoad(_ webView: UIWebView) {
//        SVProgressHUD.show()
//    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
        
        guard let webTitle = webView.stringByEvaluatingJavaScript(from: "document.title") else {
            return
        }
        
        // 设置标题
        navItem.title = webTitle
    }
    
}

extension XZWebViewController {
    
    override func setupTableView() {
        // 设置标题
        navItem.title = "正在加载..."
        
        // 设置 webView
        view.insertSubview(webView, belowSubview: navigationBar)
        
        webView.backgroundColor = .white
        
        webView.delegate = self
        
        // 设置 contentInset
        webView.scrollView.contentInset.top = navigationBar.bounds.height - 44
        
//        webView.scrollView.contentOffset.y = 44
        
        // 显示加载中
        SVProgressHUD.show()
    }
    
}
