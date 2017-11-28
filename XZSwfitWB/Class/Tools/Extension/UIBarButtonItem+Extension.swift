//
//  UIBarButtonItem+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/25.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(title: String = "",target: AnyObject?, action: Selector, font: CGFloat = 15, isBack: Bool = false) {
        
        let btn = UIButton(title: title,font: font, normalColor: .darkGray, highlightedColor: .orange)
        
        if isBack == true {
            let imgName = "navigationbar_back_withtext"
            
            btn.setImage(UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal), for: UIControlState(rawValue: 0))
            btn.setImage(UIImage(named: imgName + "_highlighted")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
            
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: btn)
    }
    
//    class func xz_barButtonItem(title: String = "",target: AnyObject?,selector: Selector,font: CGFloat = 15, normalColor: UIColor = UIColor.white, highlightedColor: UIColor = UIColor.white, imgName: String = "",selectedImgName: String = "", bgImg: String = "", bgImgHigh: String = "") -> UIBarButtonItem {
//
//        let btn = UIButton.xz_button(title: title, target: target, selector: selector, font: font, normalColor: normalColor, highlightedColor: highlightedColor, imgName: imgName, selectedImgName: selectedImgName, bgImg: bgImg, bgImgHigh: bgImgHigh)
//
//        return UIBarButtonItem.init(customView: btn)
//    }
}
