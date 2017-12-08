//
//  UILabel+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/6.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(text: String = "", color: UIColor = .black, fontSize: CGFloat = 15, lineNum: Int = 1) {
        
        self.init()
        
        self.text = text
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.numberOfLines = lineNum
    }
    
}
