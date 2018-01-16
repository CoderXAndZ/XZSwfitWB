//
//  XZComposeTextView.swift
//  XZSwfitWB
//
//  Created by admin on 2018/1/16.
//  Copyright © 2018年 XZ. All rights reserved.
//  撰写微博的文本视图

import UIKit

class XZComposeTextView: UITextView {
    
    /// 占位标签
    private lazy var placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        setupUI()
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 监听方法
    @objc private func textChanged(noti: Notification) {
        // 如果有文本，不显示占位标签，否则显示
        placeholderLabel.isHidden = self.hasText
    }
}

private extension XZComposeTextView {
    
    func setupUI() {
        // 0.注册通知
        /**
            - 通知是一对多，如果其他控件监听当前文本视图的通知，不会影响
            - 但是如果使用代理，其他控件就无法使用代理监听通知！
         */
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        
        // 1.设置占位标签
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        
        placeholderLabel.sizeToFit()
        
        addSubview(placeholderLabel)
    }
    
}
