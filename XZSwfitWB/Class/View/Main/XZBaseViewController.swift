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
    /// 用户登录标记
    var userLogon = false
    /// 表格视图 - 如果用户不登陆，就不创建
    var tableView: UITableView?
    /// 刷新控件
    var refreshControl: UIRefreshControl?
    // 上拉加载标记
    var isPullUp = false
    
    /// 懒加载:自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect.init(x: 0, y: 20, width: UIScreen.main.xz_width, height: 44))
    
    /// 自定义的导航条目
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // print(UIScreen.main.xz_width,UIScreen.main.xz_height)
        
        //
        setupUI()
        // 加载数据
        loadData()
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
    
}

// MARK: - 设置界面
extension XZBaseViewController {
    
    @objc func setupUI() {
        view.backgroundColor = .white
        
        // 取消自动缩进!!! - 如果隐藏了导航栏，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
        // 设置导航条
        setupNavigationBar()
        
        // 通过登录状态切换视图 - 设置表格视图 : 设置访问视图
        userLogon ? setupTableView() : setupVisitorView()
    }
    
    /// 设置表格视图
    private func setupTableView() {
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
        // 设置刷新控件
        // 1>实例化刷新控件
        refreshControl = UIRefreshControl()
        // 2>添加到表格视图
        tableView?.addSubview(refreshControl!)
        // 3>添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    /// 设置访客视图
    private func setupVisitorView() {
        let visitorView = XZVisitorView(frame: view.bounds)
//        visitorView.backgroundColor = UIColor.init(isRandom: true)
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
    }
    
    /// 设置导航条
    private func setupNavigationBar() {
        // 设置 navBar 的背景渲染颜色
        navigationBar.barTintColor = UIColor(hex: 0xF6F6F6)
        // 设置 navBar 的 barButton 文字渲染颜色
        navigationBar.tintColor = .orange
        
        // 添加导航条
        view.addSubview(navigationBar)
        // 将 item 设置给 bar
        navigationBar.items = [navItem]
        // 设置标题颜色
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
    }
    
}


