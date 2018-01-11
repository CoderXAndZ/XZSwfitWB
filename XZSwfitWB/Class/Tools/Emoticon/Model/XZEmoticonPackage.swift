//
//  XZEmoticonPackage.swift
//  XZ-表情包
//
//  Created by admin on 2018/1/9.
//  Copyright © 2018年 XZ. All rights reserved.
//  表情包模型

import UIKit

class XZEmoticonPackage: NSObject {
    /// 表情包的分组名
    @objc var groupName: String?
    
    /// 表情包目录，从目录下加载 info.plist 可以创建表情模型数组
    @objc var directory: String? {
        didSet {
            // 设置目录时，从目录default下加载 info.plist
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: infoPath) as? [[String : String]],
                let models = NSArray.yy_modelArray(with: XZEmoticon.self, json: array) as? [XZEmoticon]
                else {
                    return
            }
            
            // 遍历 models 数组，设置每一个表情符号的目录
            for m in models {
                m.directory = directory
            }
            
            // 设置表情模型数组
            emoticons += models
        }
    }
    
    /// 懒加载的表情模型的空数组
    /// 使用懒加载可以避免后续的解包
    lazy var emoticons = [XZEmoticon]()
    
    override var description: String {
        return yy_modelDescription()
    }
}
