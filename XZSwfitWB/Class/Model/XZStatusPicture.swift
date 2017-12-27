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
    @objc var thumbnail_pic: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
//    static func modelContainerPropertyGenericClass() -> [String: AnyObject]? {
//        return [
//            "pic_urls": XZStatusPicture.self
//        ]
//    }
}
