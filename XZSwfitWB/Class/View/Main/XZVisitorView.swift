//
//  XZVisitorView.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/5.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

class XZVisitorView: UIView {
    // 访客视图的信息字典 [imageName / message]
    // 如果是首页 imageName == ""
    var visitorInfoDict:[String: String]? {
        didSet {
            // 1> 取字典信息
            guard let imgName = visitorInfoDict?["imageName"],
                  let message = visitorInfoDict?["message"]
                else {
                return
            }
            // 2> 设置头像，首页不需要设置
            if imgName == "" {
                // 首页旋转动画
                startAnimation()
                return
            }
            // 3> 设置消息
            labelTip.text = message
            imgHouse.image = UIImage.init(named: imgName)
            // 在首页之外的页面不需要遮罩/圈
            imgMask.isHidden = true
            imgIcon.isHidden = true
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    /// 首页访客视图旋转动画
    private func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 15
        
        // 设置动画完成不删除，如果 imgIcon 被释放，动画会一起销毁！
        // 在设置连续播放的动画非常有用！
        anim.isRemovedOnCompletion = false
        
        // 将动画添加到图层
        imgIcon.layer.add(anim, forKey: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 私有控件
    // 圈
    private lazy var imgIcon = UIImageView(image: UIImage.init(named: "visitordiscover_feed_image_smallicon"))
    // 遮罩:切片图
    private lazy var imgMask = UIImageView(image: UIImage.init(named: "visitordiscover_feed_mask_smallicon"))
    // 小房子图片
    private lazy var imgHouse = UIImageView(image: UIImage.init(named: "visitordiscover_feed_image_house"))
    // 提示标签
    private lazy var labelTip = UILabel(text: "关注一些人，回这里看看有什么惊喜", color: .darkGray, fontSize: 14, lineNum: 0)
    // 注册按钮
    private lazy var btnRegister = UIButton(title: "注册", font: 16, normalColor: .orange, highlightedColor: .black, bgImg: "common_button_white_disable")
    // 登录按钮
    private lazy var btnLogin = UIButton(title: "登录", font: 16, normalColor: .darkGray, highlightedColor: .black, bgImg: "common_button_white_disable")
}

// MARK: - 设置页面
extension XZVisitorView {
    
    func setupUI() {
        backgroundColor = UIColor(hex: 0xEDEDED)
        // 1.添加到视图
        addSubview(imgIcon)
        addSubview(imgMask)
        addSubview(imgHouse)
        addSubview(labelTip)
        addSubview(btnRegister)
        addSubview(btnLogin)
        
        labelTip.textAlignment = .center
        
        // 2.取消自动布局
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 3.给图片添加自动布局
        // 1>圈
        addConstraint(NSLayoutConstraint.init(item: imgIcon,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0))
        addConstraint(NSLayoutConstraint.init(item: imgIcon,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0))
        // 2> 小房子
        addConstraint(NSLayoutConstraint.init(item: imgHouse,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0))
        addConstraint(NSLayoutConstraint.init(item: imgHouse,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0))
        // 提示
        addConstraint(NSLayoutConstraint.init(item: labelTip,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: imgIcon,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 20))
        addConstraint(NSLayoutConstraint.init(item: labelTip,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0))
        addConstraint(NSLayoutConstraint.init(item: labelTip,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: 280))
        // 3> 注册
        addConstraint(NSLayoutConstraint.init(item: btnRegister,
                                                   attribute: .right,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: -30))
        addConstraint(NSLayoutConstraint.init(item: btnRegister,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: labelTip,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 30))
        addConstraint(NSLayoutConstraint.init(item: btnRegister,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1,
                                                   constant: 100))
        addConstraint(NSLayoutConstraint.init(item: btnRegister,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1,
                                                   constant: 35))
        // 登录
        addConstraint(NSLayoutConstraint.init(item: btnLogin,
                                                   attribute: .left,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 30))
        addConstraint(NSLayoutConstraint.init(item: btnLogin,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: btnRegister,
                                                   attribute: .top,
                                                   multiplier: 1,
                                                   constant: 0))
        addConstraint(NSLayoutConstraint.init(item: btnLogin,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: btnRegister,
                                                   attribute: .width,
                                                   multiplier: 1,
                                                   constant: 0))
        addConstraint(NSLayoutConstraint.init(item: btnLogin,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: btnRegister,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 0))
        // 遮罩
        // views: 定义 VFL 中的控件名称和实际名称映射关系
        // metrics: 定义 VFL 中 () 指定的常数映射关系
        let views = ["imgMask": imgMask, "btnRegister": btnRegister] as [String : Any]
        let metrics = ["spacing": -35]
        // imgMask设置水平方向距离左边界和右边界都是0
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[imgMask]-0-|",
                                                       options: [],
                                                       metrics: nil,
                                                       views: views))
        // imgMask设置竖直方向距离上边界0、底部和btnRegister的top向下35,
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[imgMask]-(spacing)-[btnRegister]",
                                                      options: [],
                                                      metrics: metrics,
                                                      views: views))
        
    }
    
}
