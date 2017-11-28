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

        // 隐藏系统自带的 navigationBar
        navigationBar.isHidden = true
    }

    /// 重写 push 方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        // 如果不是栈底控制器才需要隐藏，根控制器不需要处理
        if childViewControllers.count > 0 {
            // 隐藏底部的 tabBar
            viewController.hidesBottomBarWhenPushed = true
            
            // 判断控制器的类型
            if let vc = viewController as? XZBaseViewController {
                
                var title = "返回"
                // 只有一个子控制器的时候，显示栈底控制器的标题
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.title ?? "返回"
                }
                // 取出自定义的 navItem，设置左侧按钮作为返回按钮
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title,target: self, action: #selector(backAction), isBack: true)
            }
            
        }
        
        super.pushViewController(viewController, animated: true)
        
    }
    
    /// 返回上层控制器
    @objc func backAction() {
        popViewController(animated: true)
    }
    
}

