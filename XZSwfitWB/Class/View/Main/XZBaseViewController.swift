//
//  XZBaseViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/24.
//  Copyright © 2017年 XZ. All rights reserved.
//  基类

import UIKit

// 所有主控制器的基类控制器
class XZBaseViewController: UIViewController {
//    /// 用户登录标记
//    var userLogon = true
    /// 表格视图 - 如果用户不登陆，就不创建
    var tableView: UITableView?
    /// 刷新控件
    var refreshControl: XZRefreshControl?
    // 上拉加载标记
    var isPullUp = false
    // 访客视图的信息字典 [imageName / message]
    var visitorInfo:[String: String]?
    
    /// 懒加载:自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.xz_width, height: 64))
    
    /// 自定义的导航条目
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        setupUI()
        // 用户不登陆，不需要加载数据
        XZNetworkManager.shared.userLogon ? loadData() : ()
        // 注册登录成功的通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: XZUserLoginSuccessedNotification), object: nil)
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func loadData() {
        // 如果子类不实现任何方法，默认关闭刷新控件
        refreshControl?.endRefreshing()
    }
    
    /// 重写 title 的didSet
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    // MARK: - 访客视图的注册/登录按钮添加点击事件
    /// 登录
    @objc func loginAction() {
        print("用户登录")
        // 发送通知
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: XZUserShouldLoginNotification), object: nil)
    }
    /// 注册
    @objc func registerAction() {
        print("用户注册")
    }
}

// MARK: - 访客视图监听方法
extension XZBaseViewController {
    // 登录成功处理
    @objc private func loginSuccess(n: Notification) {
        print("登录成功 \(n)")
        // 登录前左边是注册，右边是登录
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        // 更新UI -> 将访客视图替换为表格视图
        // 需要重新设置 view
        view = nil
        // 在访问 view 的 getter时，如果 view == nil 会再次 调用 loadView -> ViewDidLoad
        // 需要注销通知 -> 重新执行 viewDidLoad 会再次注册！避免通知被重复注册
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 设置tableView的数据源和代理
extension XZBaseViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // 在显示最后一行的时候，往上拉加载
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 当前row
        let row = indexPath.row
        // 最后一个section
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        // 最后一个section的 最后一行
        let count = tableView.numberOfRows(inSection: section) - 1
        
        // 最后一行 且 不是在上提加载
        if count == row && !isPullUp  {
            isPullUp = true
            loadData()
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 10
//    }
    
}

// MARK: - 设置界面
extension XZBaseViewController {
    
   private func setupUI() {
        view.backgroundColor = .white
        
        // 取消自动缩进!!! - 如果隐藏了导航栏，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
        // 设置导航条
        setupNavigationBar()
        
        // 通过登录状态切换视图 - 设置表格视图 : 设置访问视图
        XZNetworkManager.shared.userLogon ? setupTableView() : setupVisitorView()
    }
    
    /// 设置表格视图
    // 子类重写此方法，因为子类不需要关心用户登录之前的逻辑
    @objc func setupTableView() {
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        // 设置数据源&代理 -> 目的：子类直接实现数据源方法
        tableView?.dataSource = self
        tableView?.delegate = self
        
        // 设置内容缩进 OC navigationBar.bounds.size.height
        // top: navigationBar.bounds.height
        // bottom: tabBarController?.tabBar.bounds.height ?? 49
        tableView?.contentInset = UIEdgeInsets(top: 20,
                                               left: 0,
                                               bottom: 0,
                                               right: 0)
        // 修改右侧指示器的缩进 - 强行解包是为了拿到一个必有的 inset
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        // 设置刷新控件
        // 1>实例化刷新控件
        refreshControl = XZRefreshControl()
        // 2>添加到表格视图
        tableView?.addSubview(refreshControl!)
        // 3>添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    /// 设置访客视图
    private func setupVisitorView() {
        let visitorView = XZVisitorView(frame: view.bounds)
        // 1.设置访客视图信息
        visitorView.visitorInfoDict = visitorInfo
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        // 2.添加访客视图注册/登录按钮的监听方法
        visitorView.btnLogin.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        visitorView.btnRegister.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        
        // 3.设置导航条按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerAction))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(loginAction))
        
    }
    
    /// 设置导航条
    private func setupNavigationBar() {
        
        if UIScreen.main.xz_height == 812 { // iPhoneX
            navigationBar = UINavigationBar(frame: CGRect.init(x: 0, y: 20, width: UIScreen.main.xz_width, height: 64))
        }
        
        // 1>设置 navBar 的背景渲染颜色
        navigationBar.barTintColor = UIColor(hex: 0xF6F6F6)
        // 2>设置 navBar 的 title 颜色
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        // 3>设置 navBar 的 BarButtonItem 文字渲染颜色
        navigationBar.tintColor = .orange
        
        // 添加导航条
        view.addSubview(navigationBar)
        // 将 item 设置给 bar
        navigationBar.items = [navItem]
        
    }
    
}


