//
//  XZUserAccount.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/15.
//  Copyright © 2017年 XZ. All rights reserved.
//  用户账户信息

import UIKit

/// 用户信息磁盘拼接文件名
private let accountFile: String = "useraccount.json"

class XZUserAccount: NSObject {
    /**
     "access_token" = "2.004jcLBHVga43C200e107f4c00TUIZ";
     "expires_in" = 157679999;
     isRealName = true;
     "remind_in" = 157679999;
     uid = 6430476653;
     */
    /// 访问令牌
    @objc var access_token: String? // = "2.004jcLBHVga43C200e107f4c00TUIZ"
    /// 用户id
    @objc var uid: String?
    /// access_token的生命周期，单位是秒数
    // 开发者5年，每次登陆之后，都是5年；使用者3天，会从第一次登陆递减
    @objc var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    /// 过期日期
    @objc var expiresDate: Date?
    
    // 用户昵称
    @objc var screen_name: String?
    // 用户头像地址(大图)，180 * 180像素
    @objc var avatar_large: String?
    
    override init() {
        super.init()
        // 从磁盘加载保存的文件 -> 字典
        // 1.加载磁盘文件到二进制数据，如果失败直接返回
        
        guard let jsonPath = NSData.getDirPath(appendPath: accountFile),
            let data = NSData(contentsOfFile: jsonPath),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: Any]
        else {
            return
        }
        
        // 2.使用字典设置属性值：注释下面一句就是访客视图了
        // *** 用户是否登录的关键代码
        yy_modelSet(withJSON: dict ?? [:])
        
        // 3.判断 token 是否过期
//        // 测试过期日期
//        expiresDate = Date.init(timeIntervalSinceNow: -3600 * 24)
//        print(expiresDate)
        if expiresDate?.compare(Date()) != .orderedDescending {
            print("账户过期")
            // 清空 token
            access_token = nil
            uid = nil
            // 删除账户文件
            try? FileManager.default.removeItem(atPath: jsonPath)
        }
        
        print("账户正常 \(self)")
    }
    
    override var description: String {
        return yy_modelDescription()
    }
    /**
     1.偏好设置(小)
     2.沙盒 - 归档/plist/'json'
     3.数据库(FMDB/CoreData)
     4.钥匙串访问(小/自动加密 - 需要使用框架 SSKeychain)
     */
    /// 保存用户信息模型
    func saveAccount() {
        // 1.模型转字典
        var dict = (self.yy_modelToJSONObject() as? [String: Any]) ?? [:]
        // 需要删除 expires_in 值，这个不需要存储
        dict.removeValue(forKey: "expires_in")
        
        // 2.字典序列化 data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            return
        }
        
        // 3.写入磁盘
        (data as NSData).writeToDocDirector(appendPath: accountFile)
    }
}
