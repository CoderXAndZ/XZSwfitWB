//
//  XZComposeTypeView.swift
//  XZSwfitWB
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 XZ. All rights reserved.
//  撰写微博类型视图

import UIKit

class XZComposeTypeView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// 按钮数据数组
    let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "XZComposeViewController"],
                       ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                       ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                       ["imageName": "tabbar_compose_lbs", "title": "签到"],
                       ["imageName": "tabbar_compose_review", "title": "点评"],
                       ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                       ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                       ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                       ["imageName": "tabbar_compose_music", "title": "音乐"],
                       ["imageName": "tabbar_compose_shooting", "title": "拍摄"]
    ]
    
    class func composeTypeView() -> XZComposeTypeView {
        
        let nib = UINib(nibName: "XZComposeTypeView", bundle: nil)
        // 从 xib 加载完成视图，就会调用 awakeFromNib
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! XZComposeTypeView
        // XIB 加载默认 600 * 600
        view.frame = UIScreen.main.bounds
        
        view.setupUI()
        
        return view
    }
    
    /// 显示当前视图
    func show() {
        // 1> 将当前视图添加到 根视图控制器的 view
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        // 2> 添加到视图
        vc.view.addSubview(self)
    }
    
    // MARK: - 监听方法
    @objc func clickComposeButton() {
        print("点我了")
    }
    
    /// 点击更多按钮
    @objc private func clickMore() {
        print("点击更多")
        // 1>将 scrollView 滚动到第二页
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    /// 关闭视图
    @IBAction func close() {
        removeFromSuperview()
    }
    
}

// private 让 extension 中所有的方法都是私有
private extension XZComposeTypeView {
    
    func setupUI() {
        /**
         思路：在 scrollView 上添加两个视图，实现左右切换
         第一个视图中的6个按钮的布局，分两次循环：
            第一次循环添加控件到视图；
            第二次布局是给控件添加frame
         */
        
        // 0.强行更新布局
        layoutIfNeeded()
        
        // 1.向 scrollView 添加视图
        let rect = scrollView.bounds
        let width = rect.width
        
        for i in 0..<2 {
             let view = UIView(frame: rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            // 2.向视图添加按钮
            addButton(view: view, idx: i * 6)
            // 3.将视图添加到scrollView
            scrollView.addSubview(view)
        }
       
        // 4.设置 scrollView
        scrollView.contentSize = CGSize(width: width * 2.0, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        // 禁止滚动
        scrollView.isScrollEnabled = false
    }
    
    /// 向 view 中添加按钮，按钮的数组索引从 idx 开始
    func addButton(view: UIView, idx: Int) {
        let count = 6
        // 从 idx 开始，添加 6 个按钮
        for i in idx..<(idx + count) {
            if i >= buttonsInfo.count {
                break
            }
            
            // 0> 从数组字典中获取图像名称和 title
            let dict = buttonsInfo[i]
            
            guard let imageName = dict["imageName"],
                  let title = dict["title"] else {
                continue
            }
            
            // 1> 创建按钮
            let btn = XZComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            // 2> 将 btn 添加到视图
            view.addSubview(btn)
            
            // 3> 添加按钮的监听方法
            if let actionName = dict["actionName"] { // "更多"
                // OC 中使用 NSSelectorFromString(@"clickMore")
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }else { // 其他按钮
                print("其他按钮点击事件")
            }
        }
        
        // 遍历视图的子视图，布局按钮
        // 准备常量
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (view.bounds.width - 3 * btnSize.width) / 4.0
        for (i, btn) in view.subviews.enumerated() {
            let y = (i > 2) ? (view.bounds.height - btnSize.height) : 0
            let col = CGFloat(i % 3)
            let x = (col + 1) * margin + col * btnSize.width
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
        
    }
}
