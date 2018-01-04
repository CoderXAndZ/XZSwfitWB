//
//  XZStatusPictureView.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

class XZStatusPictureView: UIView {
    
    var viewModel: XZStatusViewModel? {
        didSet {
            calcViewSize()
            // 设置 urls
            urls = viewModel?.picURLs
            
//            // 转发的是灰色的背景
//            if viewModel?.status.retweeted_status != nil {
//                backgroundColor = UIColor(hex: 0xE3E3E3)
//            }else {
//                backgroundColor = superview?.backgroundColor
//            }
        }
    }
    
    // 根据配图模型的配图视图大小，调整显示内容
    private func calcViewSize() {
        // 处理宽度
        // 1>单图，根据配图视图的大小，修改 subviews[0] 的宽高
        if viewModel?.picURLs?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            // a) 获取第0个图像视图
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y: XZStatusPictureViewOutterMargin,
                             width: viewSize.width,
                             height: viewSize.height - XZStatusPictureViewOutterMargin)
//            backgroundColor = UIColor(hex: 0xe3e3e3)
        }else {
            // 2>多图(无图)，恢复 subview[0] 的宽高，保证九宫格布局的完整
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y: XZStatusPictureViewOutterMargin,
                             width: XZStatusPictureItemWidth,
                             height: XZStatusPictureItemWidth)
        }
        // 修改高度约束
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    /// 配图视图的数组
    private var urls: [XZStatusPicture]? {
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
        
        print("配图视图父视图 --- \(superview)")
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
