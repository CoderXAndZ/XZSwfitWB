//
//  XZEmoticonTipView.swift
//  XZSwfitWB
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 XZ. All rights reserved.
//  表情选择提示视图

import UIKit
import pop

class XZEmoticonTipView: UIImageView {
    
    /// 之前选择的表情
    private var preEmoticon: XZEmoticon?
    
    /// 提示视图的表情模型
    var  emoticon: XZEmoticon? {
        didSet {
            
            // 判断表情是否变化
            if emoticon == preEmoticon  {
                return
            }
            
            // 记录当前的表情
            preEmoticon = emoticon
            
            // 设置表情数据
            tipButton.setTitle(emoticon?.emoji, for: [])
            tipButton.setImage(emoticon?.image, for: [])
            
            // 表情的动画 - 弹力动画的结束时间是根据速度自动计算的，不需要也不能指定 duration
            let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim?.fromValue = 30
            anim?.toValue = 8
            
            anim?.springBounciness = 20
            anim?.springSpeed = 20
            
            tipButton.layer.pop_add(anim, forKey: nil)
            
//            print("设置表情...")
        }
    }
    
    // MARK: - 私有控件
    private lazy var tipButton = UIButton()
    
    // MARK: - 构造函数
    init() {
        
        let bundle = XZEmoticonManager.shared.bundle
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        // [[UIImageView alloc] initWithImage: image] => 会根据图像大小设置图像视图的大小!
        super.init(image: image)
        
        // 设置锚点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        // 添加按钮
        tipButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        tipButton.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        tipButton.center.x = bounds.width * 0.5
        
//        tipButton.setTitle("😂", for: [])
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
