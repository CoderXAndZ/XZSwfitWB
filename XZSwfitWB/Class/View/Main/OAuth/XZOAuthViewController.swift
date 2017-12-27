//
//  XZOAuthViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/14.
//  Copyright © 2017年 XZ. All rights reserved.
//  OAuth 授权页面

import UIKit
import SVProgressHUD

// 通过 webView 加载新浪微博授权页面控制器
class XZOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        // 注意：要加背景色
        view.backgroundColor = .white
        // 取消滚动视图 - 新浪微博服务器，返回的授权页面默认就是手机全屏
        webView.scrollView.isScrollEnabled = false
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
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(XZAppKey)&redirect_uri=\(XZRedirectURI)"
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
    // 关闭控制器
    @objc private func closedLoginView() {
        SVProgressHUD.dismiss()
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
    /// - Returns: 是否加载 request：YES 允许加载，NO 不允许加载
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.思路：如果请求地址包含 http:baidu.com 不加载页面 / 否则加载页面
        // request.url?.absoluteString.hasPrefix(XZRedirectURI) 返回的是可选项 true/false/nil
        if request.url?.absoluteString.hasPrefix(XZRedirectURI) == false {
            return true
        }
        print("加载请求  ---- \(request.url?.absoluteString ?? "")")
        // query 就是 URL 中 '?' 后面的所有部分
        print("加载请求  ---- \(request.url?.query ?? "")")
        // 2.从 http:baidu.com 回调地址的 ‘查询字符串’ 中查找 ‘code=’
        // 如果有，授权成功，否则，授权失败
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            closedLoginView()
            return false
        }
        // 3.从 query 字符串中取出授权码
        // 代码走到此处，url 中一定有 查询字符串，并且 包含 'code='
        // code=76ad3067c1d57029efd81d7243515a7c
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
//        let query = request.url?.query
//        let sIdx = "code=".endIndex
//        let eIdx = query?.endIndex
//        let code = query?[sIdx..<(eIdx ?? sIdx)]
        print("授权码 - \(code)")
        
        // 4.使用授权码获取[换取] AccessToken
        XZNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            } else {
//                SVProgressHUD.showInfo(withStatus: "登录成功")
                // 跳转 '界面' 通过通知发送登录成功消息
                // 1> 发送通知 - 不关心有没有监听者
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: XZUserLoginSuccessedNotification), object: nil)
                // 2> 跳转界面
                self.closedLoginView()
            }
        }
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
