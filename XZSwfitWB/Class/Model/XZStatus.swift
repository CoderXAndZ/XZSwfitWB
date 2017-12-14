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
    @objc var id: Int64 = 0
    // 微博信息内容
    @objc var text: String?
    
    // 重写 description 的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
}
