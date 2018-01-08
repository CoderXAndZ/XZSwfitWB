//
//  XZComposeViewController.swift
//  XZSwfitWB
//
//  Created by admin on 2018/1/8.
//  Copyright © 2018年 XZ. All rights reserved.
//  撰写微博控制器

import UIKit

class XZComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(isRandom: true)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", target: self, action: #selector(close))
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

}
