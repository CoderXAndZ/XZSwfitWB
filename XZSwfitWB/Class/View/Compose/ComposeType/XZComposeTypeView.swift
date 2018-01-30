//
//  XZComposeTypeView.swift
//  XZSwfitWB
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 XZ. All rights reserved.
//  撰写微博类型视图

import UIKit
import pop

class XZComposeTypeView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    /// 关闭按钮的约束 centerX
    @IBOutlet weak var btnClosedCenterXCons: NSLayoutConstraint!
    /// 返回上一页按钮的约束 centerX
    @IBOutlet weak var btnReturnCenterXCons: NSLayoutConstraint!
    /// 返回上一页按钮
    @IBOutlet weak var btnReturn: UIButton!
    
    private var completionBlock: ((_ clsName: String?)->())?
    
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
    /// OC 中的 block 如果当前方法，不能执行，通常使用属性记录，在需要的时候执行
    func show(completion: @escaping (_ clsName: String?)->()) {
        // 0>记录闭包
        completionBlock = completion
        
        // 1> 将当前视图添加到 根视图控制器的 view
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        // 2> 添加到视图
        vc.view.addSubview(self)
        
        // 3> 开始动画
        showCurrentView()
    }
    
    // MARK: - 监听方法
    @objc func clickComposeButton(selectedButton: XZComposeTypeButton) {
        print("点我了 \(selectedButton)")
        
        // 1.判断当前显示的视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let view = scrollView.subviews[page]
        
        // 2.遍历当前视图
        // - 选中的按钮放大
        // - 未选中的按钮缩小
        for (i, btn) in view.subviews.enumerated() {
            // 1>缩放动画
            let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            
            // x,y 在系统中使用 CGPoint 表示，如果要转换成 id,需要使用 'NSValue' 包装
            let scale = (selectedButton == btn) ? 2 : 0.2
            
            scaleAnim.toValue = NSValue.init(cgPoint: CGPoint(x: scale, y: scale))
            
            scaleAnim.duration = 0.25
            
            btn.pop_add(scaleAnim, forKey: nil)
            
            // 2>渐变动画 - 动画组
            let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.25
            
            btn.pop_add(alphaAnim, forKey: nil)
            
            // 3>添加动画监听
            if i == 0 {
                alphaAnim.completionBlock = { _, _ in
                    // 需要执行回调
                    print("完成回调展现控制器")
                    // 执行完成回调
                    self.completionBlock?(selectedButton.clsName)
                }
            }
        }
    }
    
    /// 点击更多按钮
    @objc private func clickMore() {
        print("点击更多")
        // 1>将 scrollView 滚动到第二页
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        // 2>处理底部按钮，让两个按钮分开
        btnReturn.isHidden = false
        
        let margin = scrollView.bounds.width / 6
        
        btnClosedCenterXCons.constant += margin
        btnReturnCenterXCons.constant -= margin
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
        
    }
    
    /// 返回上一页
    @IBAction func clickReturn() {
        // 1.将滚动视图滚动到第 1 页
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        btnClosedCenterXCons.constant = 0
        btnReturnCenterXCons.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            
            self.btnReturn.alpha = 0
        }) { (_) in
            // 2.让两个按钮合并
            self.btnReturn.isHidden = true
            
            self.btnReturn.alpha = 1
        }
    }
    
    /// 关闭视图
    @IBAction func close() {
//        removeFromSuperview()
        hiddenButtons()
    }
    
}

// private 让 extension 中所有的方法都是私有
private extension XZComposeTypeView {
    // MARK: - 消除动画
    /// 隐藏按钮动画
    private func hiddenButtons() {
        // 1.根据 contenOffset 判断当前显示的子视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let view = scrollView.subviews[page]
        
        // 2.遍历 view 的所有按钮
        for (i, btn) in view.subviews.enumerated().reversed() {
            // 1>创建动画
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            // 2>设置动画属性
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + 350
            
            // 设置时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(view.subviews.count - i) * 0.025
            
            // 3>添加动画
            btn.layer.pop_add(anim, forKey: nil)
            
            // 4>监听 第0个按钮(是最后一个执行的) 的动画，
            if i == 0 {
                anim.completionBlock = { _, _ in
                    self.hiddenCurrentView()
                }
            }
        }
    }
    
    /// 隐藏当前视图
    private func hiddenCurrentView() {
        // 1> 创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        // 2>设置动画属性
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.1 // 0.25
        
        // 3> 添加到视图
        pop_add(anim, forKey: nil)
        
        // 4> 添加完成监听方法
        anim.completionBlock = { _, _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - 显示部分的动画
    /// 动画显示当前视图
    private func showCurrentView() {
        // 1>创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.25
        
        // 2>添加到视图
        pop_add(anim, forKey: nil)
        
        // 3>添加按钮的动画
        showButtons()
    }
    
    /// 弹力显示所有的按钮
    private func showButtons() {
        // 1.获取 scrollView 的子视图的第 0 个视图
        let view = scrollView.subviews[0]
        
        // 2.遍历 view 中的所有按钮
        for (i, btn) in view.subviews.enumerated() {
            // 1>创建动画
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            // 2>设置动画属性
            anim.fromValue = btn.center.y + 350
            anim.toValue = btn.center.y
            
            // 弹力系数，取值范围 0 ~ 20，数值越大，弹性越大，默认数值为4
            anim.springBounciness = 8
            // 弹力速度，取值范围 0 ~ 20，数值越大，速度越大，默认数值为12
            anim.springSpeed = 8
            
            // 设置动画启动时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            // 3>添加动画
            btn.pop_add(anim, forKey: nil)
        }
    }
    
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
                btn.addTarget(self, action: #selector(clickComposeButton), for: .touchUpInside)
            }
            
            // 4>设置要展现的类名 - 注意不需要任何的判断，有了就设置，没有就不设置
            btn.clsName = dict["clsName"]
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
