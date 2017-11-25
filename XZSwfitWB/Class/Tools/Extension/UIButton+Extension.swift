//
//  UIButton+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/25.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// 创建button
    class func xz_button(title: String = "",font: CGFloat = 15, normalColor: UIColor = UIColor.white, highlightedColor: UIColor = UIColor.white, imgName: String = "",selectedImgName: String = "", bgImg: String = "", bgImgHigh: String = "") -> UIButton {
        
        let btn = UIButton()
        
//        if let title = title {
            btn.setTitle(title, for: .normal)
//        }
        
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(highlightedColor, for: .highlighted)
        
        btn.setImage(UIImage.init(named: imgName), for: .normal)
        btn.setImage(UIImage.init(named: selectedImgName), for: .selected)
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: font)
        
        btn.setBackgroundImage(UIImage.init(named: bgImg), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: bgImgHigh), for: .highlighted)
        
//        btn.addTarget(target, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
        
        btn.sizeToFit()
        
        return btn
    }
    
}
