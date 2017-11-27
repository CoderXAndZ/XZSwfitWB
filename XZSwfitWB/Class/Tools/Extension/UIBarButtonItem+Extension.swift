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
        
        let btn = UIButton(title: title, target: target, selector: action, font: font, normalColor: .darkGray, highlightedColor: .orange)
        
        if isBack == true {
            let imgName = "navigationbar_back_withtext"
            
            btn.setImage(UIImage(named: imgName), for: UIControlState(rawValue: 0))
            btn.setImage(UIImage(named: imgName + "_highlighted"), for: .highlighted)
            
            btn.sizeToFit()
        }
        
        self.init(customView: btn)
    }
    
//    class func xz_barButtonItem(title: String = "",target: AnyObject?,selector: Selector,font: CGFloat = 15, normalColor: UIColor = UIColor.white, highlightedColor: UIColor = UIColor.white, imgName: String = "",selectedImgName: String = "", bgImg: String = "", bgImgHigh: String = "") -> UIBarButtonItem {
//
//        let btn = UIButton.xz_button(title: title, target: target, selector: selector, font: font, normalColor: normalColor, highlightedColor: highlightedColor, imgName: imgName, selectedImgName: selectedImgName, bgImg: bgImg, bgImgHigh: bgImgHigh)
//
//        return UIBarButtonItem.init(customView: btn)
//    }
}
