//
//  XZHomeViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/24.
//  Copyright © 2017年 XZ. All rights reserved.
//  首页

import UIKit

// 全局的变量
private let cellId = "cellId"

class XZHomeViewController: XZBaseViewController {
    // 列表视图模型
    private lazy var listViewModel = XZStatusListViewModel()
    
    override func loadData() {
        
        // 加载微博数据
        listViewModel.loadStatus(pullup: self.isPullUp) { (isSuccess, shouldRefresh) in
            print("加载数据结束")
            // 结束刷新
            self.refreshControl?.endRefreshing()
            // 恢复上拉刷新标记
            self.isPullUp = false
            
            // 刷新表格
            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
      
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//
//            if self.isPullUp { // 上拉加载
//                for i in 0..<20 {
//                    self.dataLists.append("上拉 - \(i)")
//                }
//            }else { // 下拉刷新
//                self.dataLists.removeAll()
//                for i in 0..<20 {
//                    self.dataLists.insert(i.description, at: 0)
//                }
//            }
//
//            // 结束刷新
//            self.refreshControl?.endRefreshing()
//            // 恢复上拉刷新标记
//            self.isPullUp = false
//            // 刷新表格
//            self.tableView?.reloadData()
//        }
        print("刷新结束")
    }
    
    // MARK: - ‘好友’ 点击
    @objc func showFriends() {
        let vc = XZDemoViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 表格数据源方法，具体的数据源方法实现，不需要super
extension XZHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("\(listViewModel.statusList.count) ?? 000000000")
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = listViewModel.statusList[indexPath.row].text
        
        return cell
    }
    
}

// MARK: - 设置页面
extension XZHomeViewController {
    // 重写父类方法
    override func setupTableView() {
        super.setupTableView()
        
        // 设置导航栏按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        // 注册cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupNavTitle()
    }
    
    /// 设置导航栏标题
    private func setupNavTitle() {
        let title = XZNetworkManager.shared.userAccount.screen_name
        
        let btnTitle = XZTitleButton(title: title)
        
        navItem.titleView = btnTitle
        
        //
        btnTitle.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
    }
    
    @objc private func clickTitleButton(btn: UIButton) {
        // 设置选中状态
        btn.isSelected = !btn.isSelected
    }
    
}
