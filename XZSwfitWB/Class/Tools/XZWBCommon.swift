//
//  XZWBCommon.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/14.
//  Copyright © 2017年 XZ. All rights reserved.
//  类似于 pch

import Foundation

// MARK: - 应用程序信息
/// 应用程序 ID
let XZAppKey = "2162967619"
/// 应用程序加密信息(开发者可以申请修改)
let XZAppSecret = "e0b59fdea47020725e0491f1b86ce13a"
/// 回调地址 - 登录完成调转的 URL，参数以 get 形式拼接
let XZRedirectURI = "http://baidu.com"

// redirect_uri: http://baidu.com

// MARK: - 全局通知定义
/// 用户需要登录通知
let XZUserShouldLoginNotification = "UserShouldLoginNotification"
/// 用户登录成功通知
let XZUserLoginSuccessedNotification = "UserLoginSuccessedNotification"

