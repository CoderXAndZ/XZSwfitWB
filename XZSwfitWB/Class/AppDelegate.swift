//
//  AppDelegate.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/24.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 1.创建window
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        
        // 2.设置根控制器
        window?.rootViewController = XZMainViewController()
        
        // 3.让window可见
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        
        return true
    }
}

extension AppDelegate {
    /// 从服务器加载app的设置信息
    func loadAppInfo() {
        // 1.模拟异步
        DispatchQueue.global().async {
            // 1> url
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            // 2> data
            let data = NSData(contentsOf: url!)
            // 3> 写入磁盘
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            // 直接保存在沙盒，等待下一次程序启动使用
            data?.write(toFile: jsonPath, atomically: true)
            
            print("加载完毕 \(jsonPath)")
        }
    }
}

