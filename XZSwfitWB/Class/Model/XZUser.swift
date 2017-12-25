//
//  XZUser.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/23.
//  Copyright © 2017年 XZ. All rights reserved.
//  微博用户模型

import UIKit

class XZUser: NSObject {
    // 基本数据类型 & private 不能使用 KVC 设置
    /// 用户id
    @objc var id: Int64 = 0
    /// 用户昵称
    @objc var screen_name: String?
    /// 用户头像地址(中图)，50 * 50 像素
    @objc var profile_image_url: String?
    /// 认证类型：-1 没有认证；0 认证用户；2，3，5 企业认证；220 达人
    @objc var verified_type: Int = 0
    /// 会员等级 0-6
    @objc var mbrank: Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}
