//
//  XZVisitorView.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/5.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

class XZVisitorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 私有控件
    // 圈
    private lazy var imgIcon = UIImageView(image: UIImage.init(named: "visitordiscover_feed_image_smallicon"))
    // 小房子图片
    private lazy var imgHouse = UIImageView(image: UIImage.init(named: "visitordiscover_feed_image_house"))
    // 提示标签
    private lazy var labelTip = UILabel(text: "关注一些人，回这里看看有什么惊喜", color: .darkGray, fontSize: 14)
    // 注册按钮
    private lazy var btnRegister = UIButton(title: "注册", font: 16, normalColor: .orange, highlightedColor: .black, bgImg: "common_button_white_disable")
    // 登录按钮
    private lazy var btnLogin = UIButton(title: "登录", font: 16, normalColor: .darkGray, highlightedColor: .black, bgImg: "common_button_white_disable")
}

// MARK: - 设置页面
extension XZVisitorView {
    
    func setupUI() {
        backgroundColor = .white
        // 1.添加到视图
        self.addSubview(imgIcon)
        self.addSubview(imgHouse)
        self.addSubview(labelTip)
        self.addSubview(btnRegister)
        self.addSubview(btnLogin)
        
        // 2.取消自动布局
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 3.给图片添加自动布局
        // 1>圈
        self.addConstraint(NSLayoutConstraint.init(item: imgIcon,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: imgIcon,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0))
        // 2> 小房子
        self.addConstraint(NSLayoutConstraint.init(item: imgHouse,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: imgHouse,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0))
        // 3> 登录
        self.addConstraint(NSLayoutConstraint.init(item: btnRegister,
                                                   attribute: .right,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: -30))
        self.addConstraint(NSLayoutConstraint.init(item: btnRegister,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: imgIcon,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 30))
        self.addConstraint(NSLayoutConstraint.init(item: btnRegister,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1,
                                                   constant: 100))
        self.addConstraint(NSLayoutConstraint.init(item: btnRegister,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1,
                                                   constant: 35))
        // 登录
        self.addConstraint(NSLayoutConstraint.init(item: btnLogin,
                                                   attribute: .left,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 30))
        self.addConstraint(NSLayoutConstraint.init(item: btnLogin,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: btnRegister,
                                                   attribute: .top,
                                                   multiplier: 1,
                                                   constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: btnLogin,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: btnRegister,
                                                   attribute: .width,
                                                   multiplier: 1,
                                                   constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: btnLogin,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: btnRegister,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 0))
        // 提示
        self.addConstraint(NSLayoutConstraint.init(item: labelTip,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: btnLogin,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 20))
        self.addConstraint(NSLayoutConstraint.init(item: labelTip,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0))
       
    }
    
}
