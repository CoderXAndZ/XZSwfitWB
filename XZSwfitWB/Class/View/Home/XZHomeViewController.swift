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
    
    private lazy var dataLists = [String]()
    
    override func loadData() {
        
        // 用 网络工具 加载微博数据
        XZNetworkManager.shared.statusList { (list, isSuccess) in
            // 字典转模型，绑定表格数据
            print("\(list)")
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

extension XZHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = dataLists[indexPath.row]
        
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
    }

}
