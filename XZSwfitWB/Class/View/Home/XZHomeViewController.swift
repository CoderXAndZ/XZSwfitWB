//
//  XZHomeViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/24.
//  Copyright © 2017年 XZ. All rights reserved.
//  首页

import UIKit

/// 原创微博可重用 cell id
private let normalCellId = "XZStatusNormalCell"
/// 被转发微博可重用 cell id
private let retweetedCellId = "XZStatusRetweetedCell"

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
        // 0.取出视图模型
        let vModel = listViewModel.statusList[indexPath.row]
        let cellId = (vModel.status.retweeted_status != nil) ? retweetedCellId : normalCellId
        
        // 1.取cell - 本身会调用代理方法(如果有)
        // 如果没有，找到 cell,按照自动布局的规则，从上向下计算，找到向下的约束，从而计算动态行高
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! XZStatusCell
        
        // 2.设置cell
        cell.viewModel = vModel
        
        // 3. 返回cell
        return cell
    }
    
    /// 父类必须实现代理方法，子类才能够重写，Swfit 3.0 才是如此，2.0 不需要
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 1.根据 indexPath 获取视图模型
        let vm = listViewModel.statusList[indexPath.row]
        // 返回计算好的行高
        return vm.rowHeight
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
        tableView?.register(UINib.init(nibName: "XZStatusNormalCell", bundle: nil), forCellReuseIdentifier: normalCellId)
        tableView?.register(UINib.init(nibName: "XZStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        // tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        // 设置行高
        // 取消自动行高
//        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        // 取消分隔线
        tableView?.separatorStyle = .none
        
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
