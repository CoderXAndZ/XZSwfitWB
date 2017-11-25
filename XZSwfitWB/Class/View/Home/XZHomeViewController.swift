//
//  XZHomeViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/24.
//  Copyright © 2017年 XZ. All rights reserved.
//  首页

import UIKit

class XZHomeViewController: XZBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        setupUI()
    }
    
    // MARK: - ‘好友’ 点击
    @objc func showFriends() {
        let vc = XZDemoViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - 设置页面
extension XZHomeViewController {
    
    // 重写父类方法
    override func setupUI() {
        super.setupUI()

        // 设置导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", style: .plain, target: self, action: #selector(showFriends))
    }
}
