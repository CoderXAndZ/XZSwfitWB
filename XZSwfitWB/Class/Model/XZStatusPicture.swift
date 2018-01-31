//
//  XZStatusPicture.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 XZ. All rights reserved.
//  微博配图模型

import UIKit

class XZStatusPicture: NSObject {
    
    /// 缩略图地址
    @objc var thumbnail_pic: String? {
        didSet {
            //  // 设置中等尺寸图片
            //  middlePic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
            
            // 设置大尺寸图片
            largePic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
            
            // 更改缩略图地址: /thumbnail/ -> /wap720/ 或 /wap360/
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    /// 大尺寸图片
    @objc var largePic: String?
    
//    /// 中等尺寸图片
//    var middlePic: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
//    static func modelContainerPropertyGenericClass() -> [String: AnyObject]? {
//        return [
//            "pic_urls": XZStatusPicture.self
//        ]
//    }
}
