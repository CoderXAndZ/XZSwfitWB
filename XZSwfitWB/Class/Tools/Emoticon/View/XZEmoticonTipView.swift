//
//  XZEmoticonTipView.swift
//  XZSwfitWB
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 XZ. All rights reserved.
//  表情选择提示视图

import UIKit

class XZEmoticonTipView: UIImageView {
    
    init() {
        
        let bundle = XZEmoticonManager.shared.bundle
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        // [[UIImageView alloc] initWithImage: image] => 会根据图像大小设置图像视图的大小!
        super.init(image: image)
        
        // 设置锚点
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
