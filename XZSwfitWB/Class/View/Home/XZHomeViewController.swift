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
        for i in 0..<15 {
            dataLists.insert("第\(i.description)行", at: 0)
        }
        
//        tableView?.reloadData()
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
    override func setupUI() {
        super.setupUI()

        // 设置导航栏按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        // 注册cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}
