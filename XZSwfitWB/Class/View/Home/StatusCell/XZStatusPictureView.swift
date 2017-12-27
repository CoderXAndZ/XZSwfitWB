//
//  XZStatusPictureView.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

class XZStatusPictureView: UIView {
    
    /// 配图视图的数组
    var urls: [XZStatusPicture]? {
        didSet {
            // 1. 隐藏所有的 imageView
            for v in subviews {
                v.isHidden = true
            }
            // 2. 遍历 urls 数组，顺序设置图像
            var index = 0
            for url in urls ?? [] {
                // 获得对应索引的 imageView
                let iv = subviews[index] as! UIImageView
                
                // 4 张图像处理
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                // 设置图像
                iv.xz_setImage(urlString: url.thumbnail_pic, placeholderImage: UIImage.init(named: "icon_small_kangaroo_loading_1"))
                // 显示图像
                iv.isHidden = false
                
                index += 1
            }
//            print("配图视图的数组 -  \(urls)")
        }
    }
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        setupUI()
    }
}

// MARK: - 设置界面
extension XZStatusPictureView {
    
    // 1.Cell 中所有的控件都是提前准备好
    // 2.设置的时候，根据数组决定是否显示
    // 3.不要动态创建控件
    private func setupUI() {
        // 设置背景颜色
        backgroundColor = superview?.backgroundColor
        
        // 超出边界的内容不显示
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0,
                          y: XZStatusPictureViewOutterMargin,
                          width: XZStatusPictureItemWidth,
                          height: XZStatusPictureItemWidth)
        
        // 循环创建 9 个 imageView
        for i in 0..<(count * count) {
            let iv = UIImageView()
            
//            iv.backgroundColor = .red
            
            // 设置 contentMode
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            // 行 决定 Y
            /**
             0 1 2 / 3 = 0
             3 4 5 / 3 = 1
             7 8 9 / 3 = 2
             */
            let row = CGFloat(i / count)
            // 列 决定 X
            /**
             0 1 2 % 3 = 0 1 2
             3 4 5 % 3 = 0 1 2
             6 7 8 % 3 = 0 1 2
             */
            let col = CGFloat(i % count)
            
            let xOffset = col * (XZStatusPictureItemWidth + XZStatusPictureViewInnerMargin)
            let yOffset = row * (XZStatusPictureItemWidth + XZStatusPictureViewInnerMargin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            
            addSubview(iv)
        }
    }
    
}
