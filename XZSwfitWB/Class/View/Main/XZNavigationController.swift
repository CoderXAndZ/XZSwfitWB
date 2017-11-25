//
//  XZNavigationController.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/24.
//  Copyright © 2017年 XZ. All rights reserved.
//  navigationController

import UIKit

class XZNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        
    }

    /// 重写 push 方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        // 如果不是栈底控制器才需要隐藏，根控制器不需要处理
        if childViewControllers.count > 0 {
            // 隐藏底部的 tabBar
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: true)
        
    }
    
}

