//
//  UIColor+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/25.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// RGB颜色或随机色
    ///
    /// - isRandom: true 说明是 随机色
    convenience init(redC: CGFloat = CGFloat(arc4random_uniform(256)), greenC: CGFloat = CGFloat(arc4random_uniform(256)), blueC: CGFloat = CGFloat(arc4random_uniform(256)),isRandom: Bool = false) {
        
        let red = CGFloat(arc4random_uniform(256))
        let green = CGFloat(arc4random_uniform(256))
        let blue = CGFloat(arc4random_uniform(256))
        
        if isRandom == true { // 随机色
            self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
        }else {
            self.init(red: redC / 255.0, green: greenC / 255.0, blue: blueC / 255.0, alpha: 1.0)
        }
    }
    
    
   /// 16进制颜色转RGB
   ///
   /// - Parameter hex: 16进制颜色
   /// - Returns: RGB颜色
    convenience init(hex: __uint32_t) {
        let r = __uint8_t((hex & 0xff0000) >> 16)
        let g = __uint8_t((hex & 0x00ff00) >> 8)
        let b = (__uint8_t(hex & 0x0000ff))
        self.init(redC: CGFloat(r), greenC: CGFloat(g), blueC:  CGFloat(b))
    }
    
    //    /// 不输入rgb就是随机色
    //    class func xz_RGBorRandomColor(red: CGFloat = CGFloat(arc4random_uniform(256)), green: CGFloat = CGFloat(arc4random_uniform(256)), blue: CGFloat = CGFloat(arc4random_uniform(256))) -> UIColor {
    //        return UIColor.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    //    }
    //    class func xz_hexColor(hex: __uint32_t) -> UIColor {
    //        let r = __uint8_t((hex & 0xff0000) >> 16)
    //        let g = __uint8_t((hex & 0x00ff00) >> 8)
    //        let b = (__uint8_t(hex & 0x0000ff))
    //        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b))
    //    }
    
    /// 随机颜色
    //    class func xz_randomColor() -> UIColor {
    //        let random =
    //        return UIColor.init(red: random / 255.0, green: random / 255.0, blue: random / 255.0, alpha: 1.0)
    //    }
}
