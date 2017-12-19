//
//  XZNetworkManager.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/11.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit
// 导入框架的文件夹名字
import AFNetworking

// Swfit 的枚举支持任意数据类型
// Switch / enum 在 OC 中都只是支持整数
enum XZHTTPMethod {
    case GET
    case POST
}

// MARK: - 封装AFN，网络管理工具
class XZNetworkManager: AFHTTPSessionManager {
    // 静态区/常量/闭包
    // 在第一次访问时，执行闭包，并且将结果保存在 shared 常量中
//    static let shared = XZNetworkManager() // <== 单例实现
    // 设置请求的属性
    static let shared: XZNetworkManager = {
        // 实例化对象
        let instance = XZNetworkManager()
        // 设置响应反序列化支持的数据类型
      instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        // 返回对象
        return instance
    }()
    
//    // 访问令牌，所有网络请求，都基于此令牌(登录除外)
//    // 为了保护用户安全，token是有时限的，默认用户是三天
//    // 模拟 Token 过期 -> 服务器返回的状态码是 403
//    var accessToken: String? // = "2.004jcLBHVga43C200e107f4c00TUIZ"
//    // 用户微博 id
//    var uid: String? = "2162967619"
    
    // 用户账户的懒加载属性
    lazy var userAccount = XZUserAccount()
    // 用户登录标记[计算型属性]
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    
    // 专门负责 token 的网络请求方法
    func tokenRequest(method:XZHTTPMethod = .GET,URLString: String, parameters: [String: Any]?, completion: @escaping (_ json:Any?, _ isSuccess: Bool)->()) {
        // 处理 token 字典
        // 0> 判断 token 是否为 nil，为 nil 直接返回，程序执行过程中，一般 token 不会为 nil
        guard let token = userAccount.access_token else {
            // 发送通知，提示用户登录
            print("没有token! 需要登录")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: XZUserShouldLoginNotification), object: nil)
            
            completion(nil, false)
            
            return
        }
        
        // 1> 判断 参数字典是否存在，如果为 nil，应该新建一个字典
        var params = parameters
        if params == nil {
            // 实例化字典
            params = [String: Any]()
        }
        
        // 2> 设置参数字典，代码在此处字典一定有值
        params!["access_token"] = token
        
        // 调用 requst 发起真正的网络请求方法
        requst(method: method, URLString: URLString, parameters: params!, completion: completion)
    }
    
    /// 使用一个函数封装 AFN 的 GET / POST 请求
    ///
    /// - Parameters:
    ///   - method:     GET / POST
    ///   - URLString:  URLString
    ///   - parameters: 参数字典
    ///   - completion: 完成回调[json(字典 / 数组),是否成功]
    func requst(method:XZHTTPMethod = .GET,URLString: String, parameters: [String: Any], completion: @escaping (_ json:Any?, _ isSuccess: Bool)->()) {
        
        // 成功回调
        let success = { (task: URLSessionDataTask, json: Any?)->() in
            completion(json, true)
        }
        // 失败回调
        let failure = { (task: URLSessionDataTask?, error: Error)->() in
            // 针对 403 处理用户 token 过期
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token 过期了")
                // 发送通知，提示用户再次登录(本方法不知道被谁调用,谁接受到通知，谁处理！)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: XZUserShouldLoginNotification), object: "bad token")
            }
            print("网络请求错误 \(error)")
            completion(error, false)
        }
        // 进度
        let progress = { (progress: Progress)->() in
            
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
        }else {
            post(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
        }        
    }
}

// MARK: - OAuth相关方法
extension XZNetworkManager {
    
    /// 加载 AccessToken
    ///
    /// - Parameter code: 授权码
    /// - completion:     完成回调[是否成功]
    func loadAccessToken(code: String, completion: @escaping (_ isSuccess: Bool)->()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id":XZAppKey,
                      "client_secret":XZAppSecret,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":XZRedirectURI]
        
        // 发起网络请求
        requst(method: .POST, URLString: urlString, parameters: params) { (json, isSuccess) in
            /**
             "access_token" = "2.004jcLBHVga43C200e107f4c00TUIZ";
             "expires_in" = 157679999;
             isRealName = true;
             "remind_in" = 157679999;
             uid = 6430476653;
             */
            // 如果请求失败，对用户账户数据不会有任何影响
            // 直接用字典设置 userAccount 的属性
            self.userAccount.yy_modelSet(withJSON: (json as? [String: Any] ?? [:]))
            print("OAuth - \(self.userAccount)")
            
            // 加载当前用户信息
            self.loadUserInfo(completion: { (json) in
                
                // 使用用户信息字典设置用户账户信息(昵称和头像地址)
                self.userAccount.yy_modelSet(withJSON: json)
                 print("用户信息 - \(self.userAccount)")
                
                // 保存用户信息模型
                self.userAccount.saveAccount()
                
                // 用户信息加载完成,再进行回调
                completion(isSuccess)
            })
            
            /**
             我觉得 加载当前用户信息 和 加载 AccessToken 可以只留一个！因为 加载当前用户信息 也返回来 AccessToken 数据，所以，只请求用户信息就可以了吧？
             OAuth - <XZSwfitWB.XZUserAccount: 0x60400013a0e0> {
             access_token = "2.004jcLBHVga43C200e107f4c00TUIZ";
             avatar_large = <nil>;
             expiresDate = 2022-12-18 08:36:29 +0000;
             expires_in = 157679999;
             screen_name = <nil>;
             uid = "6430476653"
             }
             
             用户信息 - <XZSwfitWB.XZUserAccount: 0x60400013a0e0> {
             access_token = "2.004jcLBHVga43C200e107f4c00TUIZ";
             avatar_large = "http://tvax1.sinaimg.cn/crop.168.7.250.250.180/0071bCJnly8fmlry614n1j30ci09i74q.jpg";
             expiresDate = 2022-12-18 08:36:29 +0000;
             expires_in = 157679999;
             screen_name = "只是不懂得_";
             uid = "6430476653"
             }
             */
        }
    }
}
