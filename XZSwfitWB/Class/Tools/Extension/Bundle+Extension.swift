//
//  Bundle+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/25.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

extension Bundle {
    
    // 计算型属性
    ///  返回当前工程的命名空间
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}
