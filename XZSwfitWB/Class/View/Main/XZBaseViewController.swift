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
    
    /// tableView
    var tableView: UITableView?
    
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
    
    func loadData() {
        
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
    
}

// MARK: - 设置界面
extension XZBaseViewController {
    
    @objc func setupUI() {
        view.backgroundColor = UIColor(isRandom: true)
        
        // 设置导航条
        setupNavigationBar()
        // 设置tableView
        setupTableView()
    }
    
    /// 设置tableView
    private func setupTableView() {
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
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


