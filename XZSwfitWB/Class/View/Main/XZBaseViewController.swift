//
//  XZBaseViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2017/11/24.
//  Copyright © 2017年 XZ. All rights reserved.
//  基类

import UIKit

class XZBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        setupUI()
    }

}

// MARK: - 设置界面
extension XZBaseViewController {
    
    @objc func setupUI() {
        view.backgroundColor = UIColor.xz_RGBorRandomColor()
    }
    
}
