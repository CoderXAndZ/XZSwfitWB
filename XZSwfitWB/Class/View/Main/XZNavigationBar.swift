//
//  XZNavigationBar.swift
//  XZSwfitWB
//
//  Created by admin on 2018/1/30.
//  Copyright © 2018年 XZ. All rights reserved.
//

import UIKit

class XZNavigationBar: UINavigationBar {
    /// 自定义的导航条目
    lazy var navItem = UINavigationItem()
    
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.xz_width, height: 64))
        // 1>设置 navBar 的背景渲染颜色
        barTintColor = UIColor(hex: 0xF6F6F6)
        // 2>设置 navBar 的 title 颜色
        titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        // 3>设置 navBar 的 BarButtonItem 文字渲染颜色
        tintColor = .orange
        
        // 将 item 设置给 bar
        items = [navItem]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 自定义的导航条适配
    override func layoutSubviews() {
        guard let clsNameNew = NSClassFromString("_UIBarBackground"),
            let clsNameOld = NSClassFromString("_UINavigationBarContentView")
            else {
                return
        }
        
        for subV in subviews {
            
            if #available(iOS 11.0, *) {
                
                if subV.isKind(of: clsNameNew) {
                    frame.size.height = 64
                    
                    if UIScreen.main.xz_height == 812 { // iphoneX
                        frame.origin.y = 24
                    }
                }
                
                if subV.isKind(of: clsNameOld) {
                    frame.origin.y = 20
                    
                    if UIScreen.main.xz_height == 812 { // iphoneX
                        frame.origin.y = 44
                    }
                }
            }
        }
    }
}
