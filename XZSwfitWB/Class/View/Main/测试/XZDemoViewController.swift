//
//  XZDemoViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/25.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

class XZDemoViewController: XZBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "第 \(navigationController?.childViewControllers.count ?? 0) 个"
        
    }
    
    // 右侧按钮
    @objc func nextAction() {
       let vc = XZDemoViewController()
       navigationController?.pushViewController(vc, animated: true)
    }
}

extension XZDemoViewController {
    
    override func setupUI() {
        super.setupUI()
        
        view.backgroundColor = UIColor(isRandom:true)
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(nextAction), font: 15)

    }
    
}
