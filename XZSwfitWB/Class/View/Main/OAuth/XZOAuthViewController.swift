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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - 监听方法
    @objc private func closedLoginView() {
        dismiss(animated: true, completion: nil)
    }
    
}
