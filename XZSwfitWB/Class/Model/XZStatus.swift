//
//  XZStatus.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 XZ. All rights reserved.
//  微博数据模型

import UIKit
import YYModel

class XZStatus: NSObject {
    // Int 类型，在 64 位的机器是 64 位，在 32 位机器就是 32 位
    // 如果不写 Int64 在iPad 2/iPhone 5/5c/4s/4 都无法正常运行
    /// 微博 id
    @objc var id: Int64 = 0
    /// 微博信息内容
    @objc var text: String?
    
    /// 转发数
    @objc var reposts_count: Int = 0
    /// 评论数
    @objc var comments_count: Int = 0
    /// 点赞数
    @objc var attitudes_count: Int = 0
    
    /// 微博的用户 - 注意和服务器返回的 KEY 要一致
    @objc var user: XZUser?
    
    /// 微博配图模型数组  @objc
    @objc var pic_urls: [XZStatusPicture]?
    
    // 重写 description 的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
    
    /// 类函数
    /// 告诉第三方框架 yy_model 如果遇到数组类型的属性，数组中存放的对象是什么类
    /// NSArray 中保存对象的类型通常是 'id' 类型
    /// OC 中的泛型是 Swift 推出后，苹果为了兼容给 OC 增加的
    /// 从运行时角度，仍然不知道数组中应该存放什么类型的对象
    /// - Returns: 数组中存放的对象的类
    @objc class func modelContainerPropertyGenericClass() -> [String: AnyClass]? {
        return ["pic_urls": XZStatusPicture.self]
    }
    
}
