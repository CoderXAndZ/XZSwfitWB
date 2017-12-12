//
//  XZNetworkManager+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 XZ. All rights reserved.
//

import Foundation

// MARK: - 封装网络请求方法
extension XZNetworkManager {
    
    
    /// 加载微博数据字典数组
    ///
    /// - Parameter completion: 完成回调[list: 微博字典数组/是否成功]
    func statusList(completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool)->()) {
        
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        tokenRequest(URLString: urlStr, parameters: nil) { (json, isSuccess) in
            
            // 从 json 中获取 statuses 字典数组
            // 如果 as? 失败， result = nil
//            let result = json?["statuses"] as? [[String: Any]]
            let result = (json as AnyObject)["statuses"] as? [[String: Any]]
            completion(result, isSuccess)
        }
    }
}
