//
//  XZMainViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/24.
//  Copyright © 2017年 XZ. All rights reserved.
//  tabBar

import UIKit

class XZMainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        setupChildControllers()
        //
        
    }
    
    
    
}

// MARK: - 设置界面
extension XZMainViewController {
    
    // 设置所有的子控制器
    private func setupChildControllers() {
        let array = [["clsName":"XZHomeViewController","title":"首页","imgName":"home"],
                   ["clsName":"XZMessageViewController","title":"消息","imgName":"message_center"],
                   ["clsName":"XZDiscoverViewController","title":"发现","imgName":"discover"],
                   ["clsName":"XZProfileViewController","title":"我的","imgName":"profile"]
                  ]
        
        var arrayVc = [UIViewController]()
        
        for i in 0..<array.count {
            let dic = array[i]
            let vc = controller(dict: dic)
            
            arrayVc.append(vc)
        }
        
        viewControllers = arrayVc
    }
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: [clsName,clsName,imgName]
    /// - Returns: 子控制器
    private func controller(dict:[String:String]) -> UIViewController {
        
        // 1.取得字典的值
        guard let clsName = dict["clsName"],
        let title = dict["title"],
        let imgName = dict["imgName"],
        let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
            else {
            return UIViewController()
        }
        
        // 2.创建视图控制器
        let vc = cls.init()
        
        // 3.给子控制器设置值
        vc.title = title
        vc.tabBarItem.image = UIImage.init(named: "tabbar_" + imgName)
        vc.tabBarItem.selectedImage = UIImage.init(named:  "tabbar_" + imgName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        let nav = XZNavigationController.init(rootViewController: vc)
        
        // 4.设置 tabbar 的标题字体(大小)
        vc.tabBarItem.setTitleTextAttributes(
            [NSAttributedStringKey.foregroundColor: UIColor.orange], for: .highlighted)
        // 系统默认是 12 号字，修改字体大小，要设置 Normal 的字体大小
        vc.tabBarItem.setTitleTextAttributes(
            [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)],for: .normal)
        
        return nav
    }
    
}
