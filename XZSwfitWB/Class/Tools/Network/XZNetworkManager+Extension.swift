//
//  XZNetworkManager+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 XZ. All rights reserved.
//  网络请求方法封装

import Foundation

// MARK: - 封装网络请求方法
extension XZNetworkManager {
    
    /// 加载微博数据字典数组
    ///
    /// - Parameters:
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博）,默认为0
    ///   - max_id: 返回ID小于或等于max_id的微博，默认为0
    ///   - completion: 完成回调[list: 微博字典数组/是否成功]
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: Any]]?, _ isSuccess: Bool)->()) {
        
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // Swift 中 Int 可以转换成 AnyObject，但是 Int64 不行
        let params = ["since_id": "\(since_id)",
                      "max_id":"\(max_id > 0 ? max_id - 1 : 0)"
                     ]
        
        tokenRequest(URLString: urlStr, parameters: params) { (json, isSuccess) in
            
            // 从 json 中获取 statuses 字典数组
            // 如果 as? 失败， result = nil
            // let result = json?["statuses"] as? [[String: Any]]
            // 服务器返回的字典数组，就是按照时间的倒叙排序的
            let result = (json as AnyObject)["statuses"] as? [[String: Any]]
            
            completion(result, isSuccess)
        }
    }
    
    /// 返回微博的未读数量 - 定时刷新，不需要提示是否失败！
    func unreadcount(completion: @escaping (_ count: Int)->()) {
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let params = ["uid": uid]
        
        tokenRequest(URLString: urlString, parameters: params) { (json, isSuccess) in
            
            let dict = json as? [String: Any]
            let count = dict?["status"] as? Int
            
            completion(count ?? 0)
        }
    }
}
