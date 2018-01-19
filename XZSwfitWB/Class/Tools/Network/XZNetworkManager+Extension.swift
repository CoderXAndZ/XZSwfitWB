//
//  XZNetworkManager+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 XZ. All rights reserved.
//  网络请求方法封装

import UIKit

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

// MARK: - 发布微博
extension XZNetworkManager {
    
    /// 发布微博
    ///
    /// - Parameters:
    ///   - text:       要发布的文本，必须做URLencode，不超过140个字
    ///   - image:      要上传的图片，为 nil 时，发布纯文本微博
    ///   - completion: 完成回调
    func postStatus(text: String, image: UIImage?,completion: @escaping (_ result: [String: Any]?, _ isSuccess: Bool)->()) -> () {
        // 1. url
        var urlString: String
        
        // 根据是否有图像，选择不同的接口地址
        if image == nil {
            urlString = "https://api.weibo.cn/2/statuses/send?networktype=wifi&uicode=10000017&moduleID=704&wb_version=3550&c=android&i=46b690f&s=589c0701&ft=0&ua=Xiaomi-HM%20NOTE%201S__weibo__8.1.0__android__android4.4.2&wm=5091_0008&aid=01AhLTnSn6dnjt5rePhkNiJ7UT2tf1Z5wY6woqzNDy7fiicO4.&ext=network%3Awifi&v_f=2&v_p=57&from=1081095010&gsid=_2A253ZfBBDeRxGeBK6FIV9yjKzj-IHXVSMwSJrDV6PUJbkdANLVPEkWpNR8aDzIaxtuDLChlm0cYW8KG-fxaz-0gg&lang=zh_CN&skin=default&oldwm=5091_0008&sflag=1&check_id=1516345668526"
        }else {
            urlString = "https://api.weibo.cn/2/statuses/send?networktype=wifi&uicode=10000017&moduleID=704&wb_version=3550&c=android&i=46b690f&s=589c0701&ft=0&ua=Xiaomi-HM%20NOTE%201S__weibo__8.1.0__android__android4.4.2&wm=5091_0008&aid=01AhLTnSn6dnjt5rePhkNiJ7UT2tf1Z5wY6woqzNDy7fiicO4.&ext=effectname%3Anull%7Cnetwork%3Awifi&v_f=2&v_p=57&from=1081095010&gsid=_2A253ZfBBDeRxGeBK6FIV9yjKzj-IHXVSMwSJrDV6PUJbkdANLVPEkWpNR8aDzIaxtuDLChlm0cYW8KG-fxaz-0gg&lang=zh_CN&skin=default&oldwm=5091_0008&sflag=1&check_id=1516345727817"
        }
        
        // 2.参数字典 ==== 图片的还需要加参数
        let params = ["content": text]
        
        // 3.如果图像不为空，需要设置 name 和 data
        var name: String?
        var data: Data?
        
        if image != nil {
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        
        // 3.发起网络请求
        tokenRequest(method: .POST, URLString: urlString, parameters: params, name: name, data: data) { (json, isSuccess) in
            completion(json as? [String : Any], isSuccess)
        }
    }
    
}

// MARK: - 用户信息
extension XZNetworkManager {
    // 加载当前用户信息 - 用户登陆后立即执行
    func loadUserInfo(completion: @escaping (_ dict: [String: Any])->()) {
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let params = ["uid": uid]
        // 发起网络请求
        tokenRequest(URLString: urlString, parameters: params) { (json, isSuccess) in
            print("加载当前用户信息 - \(isSuccess)")
            // 完成回调
            completion((json as? [String : Any]) ?? [:])
        }
    }
}
