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
    convenience init(title: String = "", font: CGFloat = 15, normalColor: UIColor = .white, highlightedColor: UIColor = .white, imgName: String = "",selectedImgName: String = "",bgImg: String = "") {
        
        self.init()
        
        if title.characters.count > 0 {
            self.setTitle(title, for: .normal)
            self.setTitleColor(normalColor, for: .normal)
            self.setTitleColor(highlightedColor, for: .highlighted)
        }
        
        if imgName.characters.count > 0 {
            self.setImage(UIImage.init(named: imgName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        if selectedImgName.characters.count > 0 {
            self.setImage(UIImage.init(named: selectedImgName)?.withRenderingMode(.alwaysOriginal), for: .selected)
        }
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: font)

        self.setBackgroundImage(UIImage.init(named: bgImg), for: .normal)
//        self.setBackgroundImage(UIImage.init(named: bgImgHigh), for: .highlighted)
        
        self.sizeToFit()
    }
    
//    class func xz_button(title: String = "",target: Any?,selector: Selector,font: CGFloat = 15, normalColor: UIColor = UIColor.white, highlightedColor: UIColor = UIColor.white, imgName: String = "",selectedImgName: String = "",state: UIControlState = .selected, bgImg: String = "", bgImgHigh: String = "") -> UIButton {
//
//        let btn = UIButton()
//
////        if let title = title {
//            btn.setTitle(title, for: .normal)
////        }
//
//        btn.setTitleColor(normalColor, for: .normal)
//        btn.setTitleColor(highlightedColor, for: .highlighted)
//
//        btn.setImage(UIImage.init(named: imgName), for: .normal)
//        btn.setImage(UIImage.init(named: selectedImgName), for: .selected)
//
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: font)
//
//        btn.setBackgroundImage(UIImage.init(named: bgImg), for: .normal)
//        btn.setBackgroundImage(UIImage.init(named: bgImgHigh), for: .highlighted)
//
//        btn.addTarget(target, action: selector, for: .touchUpInside)
//
//        btn.sizeToFit()
//
//        return btn
//    }
    
}
