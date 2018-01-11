//
//  XZTitleButton.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/19.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

// FIXME: titleButton这里好像有些不太对，虽然显示是正确的，但是，看层次图不太对呢，好像是 navBar 就不太对
class XZTitleButton: UIButton {
    
    /// 重载构造函数
    ///
    /// - Parameter title: title
    /// 如果是nil，就显示首页；如果不为 nil,显示 title 和箭头图像
    init(title: String?) {
        super.init(frame: CGRect())
        
        // 1> 判断 title 是否为 nil
        if title == nil {
            setTitle("首页", for: [])
        } else {
           // 如果 title 和 imageView 靠的太近，可以在 title 后面加一个空格
           // setTitle(title! + " ", for: [])
            setTitle(title!, for: [])
            
            // 设置图像
            setImage(UIImage.init(named: "navigationbar_arrow_down"), for: [])
            setImage(UIImage.init(named:"navigationbar_arrow_up"), for: .selected)
        }

        // 2> 设置字体和颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(.darkGray, for: [])
        
        // 3> 设置大小
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 判断 label 和 imageView 是否同时存在
        guard let titleLabel = titleLabel,
              let imageView = imageView
        else {
            return
        }
        
        print("布局 -- \(titleLabel) \(imageView)")
        
        // OC 中不允许直接修改结构体内部的值，Swift 中可以直接修改
        // 将 label 的 x 向左移动 imageView 的宽度
        titleLabel.frame.origin.x = 0
        // 将 imageView 的 x 向右移动 label 的宽度
        imageView.frame.origin.x = titleLabel.bounds.width
        
        // 由于 Xcode 8.2 之后，layoutSubviews 方法被多次调用，导致下面代码不可用
//        // 将 label 的 x 向左移动 imageView 的宽度
//        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
//        // 将 imageView 的 x 向右移动 label 的宽度
//        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
    }
    
}
