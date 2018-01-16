//
//  XZComposeViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2018/1/8.
//  Copyright © 2018年 XZ. All rights reserved.
//  撰写微博控制器

import UIKit

class XZComposeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // 监听键盘通知 - UIWindow.h
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardChanged), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 激活键盘
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 关闭键盘
        textView.resignFirstResponder()
    }
    
    // MARK: - 键盘监听方法
    @objc func keyBoardChanged(noti: Notification) {
        print(noti.userInfo)
        
        // 1.目标 rect
        guard let rect = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                return
        }
        
        // 2.设置底部约束的高度
        let offset = view.bounds.height - rect.origin.y

        print("offset ====== \(offset) ====== \(view.bounds.height) ====== \(rect.origin.y)")

        // 3.更新底部约束
        toolbarBottomCons.constant = offset
        
        // 4.动画更新约束：toolBar的上/下移和键盘同步！
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: - 按钮监听方法
    /// 发布微博
    @IBAction func postStatus() {
        
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 文本编辑视图
    @IBOutlet weak var textView: UITextView!
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    
    /// 发布按钮
    @IBOutlet var btnSend: UIButton!
    
    /// 标题按钮 - 换行的热键 opt + enter
    @IBOutlet var labelTitle: UILabel!
    
    /// 工具栏底部约束
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
}

// MARK: - UITextViewDelegate
/**
 通知：一对多，只要有注册的监听者，在注销监听之前，都可以接收到通知！
 代理：一对一，最后设置的代理对象有效！前面设置的代理对象会被覆盖掉。
 
 苹果日常开发中，代理的监听方式是最多的！
 
 - 代理是发生事件时，直接让代理执行协议方法！
    代理的效率更高
    直接的反向传值
 - 通知是发生事件时，将通知发送给通知中心，通知中心再‘广播’通知！
    通知的效率相对要低一些
    如果层次嵌套的非常深，可以使用通知传值
 */
extension XZComposeViewController: UITextViewDelegate {
    
    /// 文本视图文字变化
    func textViewDidChange(_ textView: UITextView) {
        btnSend.isEnabled = textView.hasText
    }
    
}

// MARK: - 设置页面
private extension XZComposeViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        setupNavigationBar()
        
        setupToolbar()
    }
    
    /// 设置导航栏
    func setupNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        // 设置发送按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnSend)
        
        btnSend.isEnabled = false
        
        // 设置标题视图
        navigationItem.titleView = labelTitle
    }
    
    /// 设置工具栏
    func setupToolbar() {
        
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        var items = [UIBarButtonItem]()
        
        // 遍历数组
        for item in itemSettings {
            guard let imageName = item["imageName"] else {
                continue
            }
            
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton()
            
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            
            btn.sizeToFit()
            
            // 追加按钮
            items.append(UIBarButtonItem(customView: btn))
            
            // 追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        /// 删除末尾弹簧
        items.removeLast()
        
        toolBar.items = items
    }
    
}
