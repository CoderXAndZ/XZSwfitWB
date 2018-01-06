//
//  XZComposeTypeButton.swift
//  XZSwfitWB
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 XZ. All rights reserved.
//

import UIKit

// UIControl 内置了 touchupInside 事件响应
class XZComposeTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 使用图像名称/标题创建按钮，按钮布局从 xib 加载
    class func composeTypeButton(imageName: String, title: String) -> XZComposeTypeButton {
        let nib = UINib(nibName: "XZComposeTypeButton", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! XZComposeTypeButton
        
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        
        return btn
    }
}
