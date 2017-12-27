//
//  XZStatusViewModel.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/23.
//  Copyright © 2017年 XZ. All rights reserved.
//  单条微博的视图模型

import UIKit

class XZStatusViewModel: CustomStringConvertible {
    /// 微博模型
    @objc var status: XZStatus
    
    /// 会员图标 - 存储型属性(用内存换 CPU)
    @objc var memberIcon: UIImage?
    /// 认证类型：-1 没有认证；0 认证用户；2，3，5 企业认证；220 达人
    @objc var vipIcon: UIImage?
    /// 转发文字
    @objc var retweetedStr: String?
    /// 评论文字
    @objc var commentStr: String?
    /// 点赞文字
    @objc var likeStr: String?
    
    /// 配图视图大小
    @objc var pictureViewSize = CGSize()
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    init(model: XZStatus) {
        self.status = model
        
        print("微博模型 - \(model.pic_urls)")
        
        // 直接计算出会员图标/会员等级 0-6
        let mbrank = model.user?.mbrank ?? 1
        if  mbrank > 0 && mbrank < 7 {
            let imgName = "common_icon_membership_level\(mbrank)"
            memberIcon = UIImage.init(named: imgName)
        }
        
        // 认证图标
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage.init(named: "avatar_vip")
        case 2,3,5:
            vipIcon = UIImage.init(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage.init(named: "avatar_grassroot")
        default:
            break
        }
        
        // 设置底部计数字符串
        // 测试超过一万的数字
//        model.reposts_count = Int(arc4random_uniform(100000))
        retweetedStr = countString(count: model.reposts_count, defaultStr: "转发")
        commentStr = countString(count: model.comments_count, defaultStr: "评论")
        likeStr = countString(count: model.attitudes_count, defaultStr: "赞")
        
        // 计算配图视图的大小
        pictureViewSize = calPictureViewSize(count: model.pic_urls?.count)
    }
    
    /// 计算指定数量的图片对应的配图视图的大小
    ///
    /// - Parameter count: 配图视图的数量
    /// - Returns:         配图视图的大小
    private func calPictureViewSize(count: Int?) -> CGSize {
        
        if count == 0 || count == nil {
            return CGSize()
        }
        
        // 1. 计算配图视图的宽高
        // 2.计算高度
        // 1> 根据 count 知道行数 1 ~ 9
        /**
          1 2 3 = 0 1 2 / 3 = 0 + 1 = 1
          4 5 6 = 3 4 5 / 3 = 1 + 1 = 2
          7 8 9 = 6 7 8 / 3 = 2 + 1 = 3
         */
        let row = CGFloat((count! - 1) / 3 + 1)
        // 2> 根据行数算高度
        let height = XZStatusPictureViewOutterMargin + row * XZStatusPictureItemWidth + (row - 1) * XZStatusPictureViewInnerMargin
        
        return CGSize(width: XZStatusPictureViewWidth, height: height)
    }
    
    /// 给定义一个数字，返回对应的描述结果
    ///
    /// - Parameters:
    ///   - count:      数量
    ///   - defaultStr: 默认标题，转发/评论/赞
    /// - Returns:      描述结果
    /**
     如果count == 0，显示默认标题
     如果 count 超过 10000，显示 x.xx 万
     如果 count < 10000,显示实际数字
     */
    private func countString(count: Int, defaultStr: String) -> String {
        if count == 0 {
            return defaultStr
        }
        
        if count < 10000 {
            return count.description
        }
        
        return String.init(format: "%.02f 万", Double(count) / 10000)
    }
    
    /**
     如果没有任何父类，并希望在开发时调试，输出调试信息，需要
     1.遵守 CustomStringConvertible
     2.实现 description 计算型属性
     
     关于表格的性能优化
      - 尽量少计算，所有需要的素材提前计算好！
      - 控件不要设置圆角半径，所有图像渲染的属性，都要注意！
      - 不要动态创建控件，所有需要的控件，都要提前创建好，在显示的时候，根据数据隐藏 / 显示！
      - Cell 中控件的层次越少越好，数量越少越好！
      - 要测量，不要猜测！
     */
    var description: String {
        return status.description
    }
}
