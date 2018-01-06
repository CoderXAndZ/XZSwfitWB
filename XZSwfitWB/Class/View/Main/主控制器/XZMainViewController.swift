//
//  XZMainViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/24.
//  Copyright © 2017年 XZ. All rights reserved.
//  tabBar

import UIKit
import SVProgressHUD

class XZMainViewController: UITabBarController {
    // 定时器
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建子控制器
        setupChildControllers()
        // 创建 + 按钮
        setupComposeButton()
        //
        setupTimer()
        
        // 设置新特性视图
        setupNewFeatureViews()
        
        // 设置代理
        delegate = self
        // 注册登录通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: XZUserShouldLoginNotification), object: nil)
    }
    
    deinit {
        // 销毁时钟
        timer?.invalidate()
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 设置横竖屏 portrait 竖屏 landscape 横屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - 监听方法
    @objc private func userLogin(n:Notification) {
        print("用户登录通知 \(n)")
        
        var when = DispatchTime.now()
        
        // 判断 n.object 是否有值 -> 如果有值(token 过期)，提示用户重新登录
        if n.object != nil {
            // 设置指示器渐变样式
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录已经超时，需要重新登录")
            // 修改延迟时间
            when = DispatchTime.now() + 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            // 指示器样式还原
            SVProgressHUD.setDefaultMaskType(.clear)
            // 展现登录控制器 - 通常会和 UINavigationController 连用，方便返回
            // FIXME: - 当修改了 token 之后，弹出授权登录页面，不登陆就返回，首页 页面 下拉的问题！！！暂未修改
            let nav = UINavigationController.init(rootViewController: XZOAuthViewController())
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    // MARK: - 按钮 '+' 的点击事件 -> 撰写微博
    // FIXME: 没有实现
    @objc private func btnComposeClick() {
        print("我是中间 '+' 按钮")
        // FIXME: 0> 判断是否登录
        // 1> 实例化视图
        let vCompose = XZComposeTypeView.composeTypeView()
        
        // 2> 显示视图
        vCompose.show()
        
//        // 测试设备横屏
//        let vc = UIViewController()
//        vc.view.backgroundColor = UIColor(isRandom:true)
//        let nav = UINavigationController.init(rootViewController: vc)
//        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - 私有控件：'+' 按钮
    private var btnCompose: UIButton = UIButton(imgName: "tabbar_compose_icon_add",bgImg: "tabbar_compose_button")
}

// MARK: - 新特性视图处理
extension XZMainViewController {
    // 设置新特性视图
    private func setupNewFeatureViews() {
        // 0. 判断是否登录
        if !XZNetworkManager.shared.userLogon {
            return
        }
        // 1.如果更新，显示新特性，否则显示欢迎
        let v = isNewVersion ? XZNewFeatureView.newFeatureView() : XZWelcomeView.welcomeView()
        // 2.添加视图
        // v.frame = view.bounds
        view.addSubview(v)
    }
    
    // extensions 中可以有计算型属性，不会占用存储空间
    /// 构造函数： 给属性分配空间
    private var isNewVersion: Bool {
        // 1.取当前的版本号 1.0.2
        let currentVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        print("当前版本 - \(currentVersion)")
        
        // 2.取保存在 ‘Document(iTunes备份)[最理想保存在用户偏好]’目录中的之前的版本号 ‘1.0.2’
        let path = NSData.getDirPath(appendPath: "version") ?? ""
        let sandboxVersion = (try? String.init(contentsOfFile: path)) ?? ""
        print("沙盒版本 - \(sandboxVersion)")
        
        // 3.将当前的版本号保存在沙盒
        try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        // 4.返回两个版本号‘是否一致’
        return currentVersion != sandboxVersion
        // 测试新特性
//        return currentVersion == sandboxVersion
    }
    
    /**
     版本号
     - 在 App Store 每次升级应用程序，版本号都需要增加，不能递减
     
     - 组成 主版本号.次版本号.修订版本号
     - 主版本号：意味着大的修改，使用者也需要做大的适应
     - 次版本号：意味着小的修改，某些函数和方法的使用或参数有变化
     - 修订版本号：框架/程序内部 bug 的修订，不会对使用者造成任何的影响
     */
}

// MARK: - UITabBarControllerDelegate
extension XZMainViewController: UITabBarControllerDelegate {
    
    /// 将要选择 TabBar
    ///
    /// - Parameters:
    ///   - tabBarController: tabBarController
    ///   - viewController:   目标控制器
    ///   - Returns:          是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // 点击 首页 tabBar 滚动到顶部并且加载数据
        // 1> 获取控制器在数组中的索引
        let idx = childViewControllers.index(of: viewController)
        // 2> 判断当前索引是首页，同时 idx 也是首页， 重复点击首页的按钮
        if selectedIndex == 0 && idx == selectedIndex {
            
            // 3> 让表格滚动到顶部
            // a) 获取到控制器
            let nav = childViewControllers[0]
            let vc = nav.childViewControllers[0] as! XZBaseViewController
            // b) 滚动到顶部
            vc.tableView?.setContentOffset(CGPoint.init(x: 0, y: -64), animated: true)
            // 4> 刷新数据 - 增加延迟，是保证表格先滚动到顶部再刷新
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                vc.loadData()
            })
            
            // 5> 清除 tabItem/app 的 badgeNumber
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        // 判断目标控制器是否是 UIViewController
        return !viewController.isMember(of: UIViewController.self)
    }
}

// MARK: - 时钟相关方法
extension XZMainViewController {
    // 定义时钟
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    /// 时钟触发方法
    @objc private func updateTimer() {
        // 时钟开着的原因：1、不怎么耗费性能；2、登录之后不需要再回来处理时钟了
        // 如果没有登录，不执行时钟触发方法
        if !XZNetworkManager.shared.userLogon {
            return
        }
        // 未读消息数
        XZNetworkManager.shared.unreadcount { (count) in
            print("监测到有\(count)条新微博")
            // 设置 首页 tabBarItem 的 badgeNumber
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
        }
    }
    
}

// MARK: - 设置界面
extension XZMainViewController {
    // 设置 '+' 按钮
    private func setupComposeButton() {
        tabBar.addSubview(btnCompose)
        
        // 计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
        // 将向内缩进的宽度
//        let width = tabBar.bounds.width / count - 1
        let width = tabBar.bounds.width / count
        
        // CGRectInset 正数向内缩进，负数向外扩展 dy为负的话是像上去
        btnCompose.frame = tabBar.bounds.insetBy(dx: width * 2, dy: 0)
        
        // 点击事件
        btnCompose.addTarget(self, action: #selector(btnComposeClick), for: .touchUpInside)
        
    }

    // 设置所有的子控制器
    private func setupChildControllers() {
        
        // 0.获取沙盒 json 路径
//        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        
        let jsonPath = NSData.getDirPath(appendPath: "main.json") ?? ""

        // 1.加载data
        var data = NSData(contentsOfFile: jsonPath)
        // 判断 data 是否有内容，如果没有，说明本地沙盒没有文件
        if data == nil {
            // 从 Bundle 中加载配置的 json
            let path = Bundle.main.path(forResource: "main", ofType: "json")
            data = NSData(contentsOfFile: path!)
        }
        
        // data 一定会有一个内容，反序列化
        // 反序列化转换成数组
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: Any]]
            else {
            return
        }
  
        var arrayVc = [UIViewController]()
        
        for i in 0..<array!.count {
            let dic = array![i]
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
