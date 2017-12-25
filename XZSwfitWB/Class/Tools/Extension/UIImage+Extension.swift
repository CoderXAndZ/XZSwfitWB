//
//  UIImage+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/18.
//  Copyright © 2017年 XZ. All rights reserved.
//  异步裁切来绘制圆角图形

import UIKit

extension UIImage {
    
    
    /// 将给定的图像进行拉伸，并且返回'新'的图像
    ///
    /// - Parameters:
    ///   - size:      指定大小
    ///   - fillColor: 填充颜色
    /// - Returns:     UIImage
    func xz_cornerImage(size: CGSize?, fillColor: UIColor = .white, lineColor: UIColor = .lightGray) -> UIImage? {
        // 看程序执行耗时
        let start: TimeInterval = CACurrentMediaTime()
        
        var size = size
        
        if size == nil || size?.width == 0 {
            size = CGSize(width: 34, height: 34)
        }
            
        let rect = CGRect(origin: CGPoint(), size: size!)
            
        // 1.利用绘图，建立上下文 - 内存中开辟一个地址，跟屏幕无关!
        /**
        参数：
            1> size: 绘图的尺寸
            2> 不透明：false / true
            3> scale：屏幕分辨率，生成的图片默认使用 1.0 的分辨率，图像质量不好;可以指定 0 ，会选择当前设备的屏幕分辨率
        */
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
            
        // 2.设置被裁切的部分的填充颜色
        fillColor.setFill()
        UIRectFill(rect)
        
        // 3.利用 贝塞尔路径 实现 裁切 效果
        // 1>实例化一个圆形的路径
        let path = UIBezierPath.init(ovalIn: rect)
        // 2>进行路径裁切 - 后续的绘图，都会出现在圆形路径内部，外部的全部干掉
        path.addClip()
        
        // 4.绘图 drawInRect 就是在指定区域内拉伸屏幕
        draw(in: rect)
    
        // 5.绘制内切的圆形
        let ovalPath = UIBezierPath.init(ovalIn: rect)
        ovalPath.lineWidth = 2
        lineColor.setStroke()
        ovalPath.stroke()
//        UIColor.darkGray.setStroke()
//        path.lineWidth = 2
//        path.stroke()
        
        // 6.取得结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 7.关闭上下文
        UIGraphicsEndImageContext()
        
        // 8.返回结果
        return result
        // FIXME: 查看是否耗时
        print("耗时 - \(CACurrentMediaTime() - start)")
        
        }
}
