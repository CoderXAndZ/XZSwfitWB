//
//  UIImage+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/18.
//  Copyright © 2017年 XZ. All rights reserved.
//  异步裁切来绘制圆角图形

import UIKit

extension UIImage {
    
    /// 根据当前图像，和指定的尺寸，生成圆角图像并且返回
    ///
    /// - Parameters:
    ///   - size:       图片的大小
    ///   - fillColor:  填充颜色
    ///   - completion: 回调[圆角图像]
    func cornerImage(size: CGSize, fillColor: UIColor = .white, completion:@escaping (_ image: UIImage)->()) {
        DispatchQueue.global().async {
            // 看程序执行耗时
            let start: TimeInterval = CACurrentMediaTime()
            // 1.利用绘图，建立上下文
            UIGraphicsBeginImageContextWithOptions(size, true, 0)
            let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
            
            // 2.设置被裁切的部分的填充颜色
            fillColor.setFill()
            UIRectFill(rect)
            
            // 3.利用 贝塞尔路径 实现 裁切 效果
            let path = UIBezierPath.init(ovalIn: rect)
            path.addClip()
            
            // 4.绘制图像
            self.draw(in: rect)
            
            // 5.取得结果
            let result = UIGraphicsGetImageFromCurrentImageContext()
            
            // 6.关闭上下文
            UIGraphicsEndImageContext()
            
            print("耗时 - \(CACurrentMediaTime() - start)")
            
            // 7.使用回调，返回结果
            DispatchQueue.main.async(execute: {
                guard let result = result else {
                    return
                }
                completion(result)
            })
        }
    }
}
