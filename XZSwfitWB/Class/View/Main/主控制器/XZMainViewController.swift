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

        // 创建子控制器
        setupChildControllers()
        // 创建 + 按钮
        setupComposeButton()
    }
    
    /// 设置横竖屏 portrait 竖屏 landscape 横屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - 按钮 '+' 的点击事件
    // FIXME: 没有实现
    @objc private func btnComposeClick() {
        print("我是中间 '+' 按钮")
        
        // 测试设备横屏
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor(isRandom:true)
        let nav = UINavigationController.init(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - 私有控件：'+' 按钮
    private var btnCompose: UIButton = UIButton(imgName: "tabbar_compose_icon_add",bgImg: "tabbar_compose_button")
}


// MARK: - 设置界面
extension XZMainViewController {
    // 设置 '+' 按钮
    private func setupComposeButton() {
        tabBar.addSubview(btnCompose)
        
        // 计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
        //
        let width = tabBar.bounds.width / count - 1
        
        // CGRectInset 正数向内缩进，负数向外扩展 dy为负的话是像上去
        btnCompose.frame = tabBar.bounds.insetBy(dx: width * 2, dy: 0)
        
        // 点击事件
        btnCompose.addTarget(self, action: #selector(btnComposeClick), for: .touchUpInside)
        
    }

    // 设置所有的子控制器
    private func setupChildControllers() {
        let array = [
            ["clsName":"XZHomeViewController","title":"首页","imgName":"home","visitorInfo":["imageName":"","message":""]],
            ["clsName":"XZMessageViewController","title":"消息","imgName":"message_center","visitorInfo":["imageName":"visitordiscover_image_message","message":"登录后，别人评论你的微博，发给你的消息，都会在这里收到通知"]],
            ["clsName":"UIViewController"],
            ["clsName":"XZDiscoverViewController","title":"发现","imgName":"discover","visitorInfo":["imageName":"visitordiscover_image_message","message":"登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过"]],
            ["clsName":"XZProfileViewController","title":"我的","imgName":"profile","visitorInfo":["imageName":"visitordiscover_image_profile","message":"登录后，你的微博、相册、个人资料会显示在这里，展示给别人"]]
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
    private func controller(dict:[String:Any]) -> UIViewController {
        
        // 1.取得字典的值
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imgName = dict["imgName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? XZBaseViewController.Type,
        let visitorDict = dict["visitorInfo"] as? [String: String]
            else {
            return UIViewController()
        }
        
        // 2.创建视图控制器
        let vc = cls.init()
        
        // 设置访客视图字典
        vc.visitorInfo = visitorDict
        
        // 3.给子控制器设置值
        vc.title = title
        vc.tabBarItem.image = UIImage.init(named: "tabbar_" + imgName)
        vc.tabBarItem.selectedImage = UIImage.init(named:  "tabbar_" + imgName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        // 实例化导航控制器的时候，会调用 push 方法将 rootVc 压栈
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
