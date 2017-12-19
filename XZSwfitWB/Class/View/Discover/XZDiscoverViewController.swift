//
//  XZDiscoverViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/24.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

class XZDiscoverViewController: XZBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 测试修改 token
//        XZNetworkManager.shared.userAccount.access_token = nil
        // 模拟 token 过期
//        XZNetworkManager.shared.userAccount.access_token = "hello token"
        
        print("修改了 token")
    }

}
