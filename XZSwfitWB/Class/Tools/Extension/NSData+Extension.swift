//
//  NSData+Extension.swift
//  XZSwfitWB
//
//  Created by XZ on 2017/12/16.
//  Copyright © 2017年 XZ. All rights reserved.
//

import Foundation

extension NSData {

    /// 将数据写入磁盘
    ///
    /// - Parameter appendPath: 拼接的路径
    func writeToDocDirector(appendPath: String) {
        
//        // 1.获取磁盘路径
//        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        // 2.拼接路径
//        let jsonPath = (docDir as NSString).appendingPathComponent(appendPath)
        
//        print("沙盒地址 \(jsonPath)")
        // 3.写入沙盒
        self.write(toFile: NSData.getDirPath(appendPath: appendPath) ?? "", atomically: true)
    }
    // FIXME: 磁盘路径可能不存在嘛？
    class func getDirPath(appendPath: String) -> String? {
        // 1.获取磁盘路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        // 2.拼接路径
        let jsonPath = (docDir as NSString).appendingPathComponent(appendPath)
        
        print("沙盒地址 \(jsonPath)")
        
        return jsonPath
    }
}
