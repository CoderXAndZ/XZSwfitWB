//
//  UIScreen+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/27.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

extension UIScreen {
    
    // 计算型属性
    public var xz_width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    public var xz_height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    public var xz_scale: CGFloat {
        return UIScreen.main.scale
    }
    
    
    
//    class func xz_width() -> CGFloat {
//        return UIScreen.main.bounds.size.width
//    }
//
//    class func xz_height() -> CGFloat {
//        return UIScreen.main.bounds.size.height
//    }
//
//    class func xz_scale() -> CGFloat {
//        return UIScreen.main.scale
//    }
    
}
