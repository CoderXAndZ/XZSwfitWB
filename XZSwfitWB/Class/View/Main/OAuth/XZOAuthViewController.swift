//
//  XZOAuthViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/14.
//  Copyright © 2017年 XZ. All rights reserved.
//  OAuth 授权页面

import UIKit

// 通过 webView 加载新浪微博授权页面控制器
class XZOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        // 注意：要加背景色
        view.backgroundColor = .white
        
        // 设置导航栏
        title = "登录新浪微博"
        // 导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(closedLoginView), isBack: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFilled))
        
        // 设置代理
        webView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=2162967619&redirect_uri=http://baidu.com"
        // 1> URL 确定要访问的资源
        guard let url = URL.init(string: urlString) else {
            return
        }
        // 2> 建立请求
        let request = URLRequest.init(url: url)
        // 3> 加载请求
        webView.loadRequest(request)
    }
    
    // MARK: - 监听方法
    @objc private func closedLoginView() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 自动填充 - webview 的注入，直接通过 js 修改 ‘本地浏览器中’ 缓存的页面内容
    /// 点击登录按钮，执行 submit() 将本地数据提交给服务器！
    @objc private func autoFilled() {
        // 准备 js
        let js = "document.getElementById('userId').value = '17615818324';" + "document.getElementById('passwd').value = 'xx86779490@';"
        // 让 webview 执行 js
        webView.stringByEvaluatingJavaScript(from: js)
    }
}

extension XZOAuthViewController: UIWebViewDelegate {
    
    /// webview 将要加载请求
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - request: 要加载的请求
    ///   - navigationType: 导航类型
    /// - Returns: 是否加载 request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.思路：如果请求地址包含 http:baidu.com 不加载页面 / 否则加载页面
        print("加载请求  ---- \(request.url?.absoluteString ?? "")")
        // 2.从 http:baidu.com 回调地址中截取 ‘code=’ 后面的字符串
        // 如果有，授权成功，否则，授权失败
        
        return true
    }
}
