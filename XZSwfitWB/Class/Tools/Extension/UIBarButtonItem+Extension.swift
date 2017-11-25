//
//  UIBarButtonItem+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/25.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func xz_barButtonItem(title: String = "",font: CGFloat = 15, normalColor: UIColor = UIColor.white, highlightedColor: UIColor = UIColor.white, imgName: String = "",selectedImgName: String = "", bgImg: String = "", bgImgHigh: String = "") -> UIBarButtonItem {
        
        let btn = UIButton.xz_button(title: title,normalColor: normalColor, highlightedColor: highlightedColor)
        
        return UIBarButtonItem.init(customView: btn)
    }
}
