//
//  UIImageView+Extension.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/23.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// 隔离 SDWebImage 设置图像函数
    ///
    /// - Parameters:
    ///   - urlString:        urlString
    ///   - placeholderImage: 占位图像
    ///   - isAvatar:         是否头像
    func xz_setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        
        // 处理 URL
        guard let urlString = urlString,
            let url = URL.init(string: urlString) else {
            // 设置占位图像
            image = placeholderImage
                
            return
        }
        
        // 可选项只是用在 Swift，OC 有的时候用 ! 同样可以传入 nil
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { [weak self] (image, error, _, _) in
           
            // 完成回调 - 判断是否是头像
            if isAvatar {
                self?.image = image?.xz_cornerImage(size: self?.bounds.size)
            }
            if error != nil {
                print("图像设置失败 - \(String(describing: error))")
            }
        }
    }
}
