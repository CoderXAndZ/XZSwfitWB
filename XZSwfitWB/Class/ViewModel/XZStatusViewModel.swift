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
    
    /// 如果是被转发微博，原创微博一定没有图
    @objc var picURLs: [XZStatusPicture]? {
        // 如果有被转发的微博，返回被转发微博的配图
        // 如果没有被转发的微博，返回原创微博的配图
        // 如果都没有，返回 nil
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    /// 被转发微博的文字
    @objc var retweetedText: String?
    
    /// 行高
    @objc var rowHeight: CGFloat = 0
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    init(model: XZStatus) {
        self.status = model
        
//        print("微博模型 - \(model.pic_urls)")
        
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
        
        // 计算配图视图的大小 - 有原创的就计算原创的，有被转发的就计算转发的
        pictureViewSize = calPictureViewSize(count: picURLs?.count)
        
        // 设置被转发微博的文字
        let scName = status.retweeted_status?.user?.screen_name ?? ""
        let retText = status.retweeted_status?.text ?? ""
        retweetedText = String.init(format: "@%@😁\n%@", scName,retText)
        
        // 计算行高
        updateRowHeight()
    }
    
    /// 根据当前的视图模型的内容计算行高
    func updateRowHeight() {
        // 原创微博：顶部分隔(12) + 间隔(12) + 图像的高度(34) + 间距(12) + 正文高度(需要计算) + 配图视图高度(计算) + 间距(12) + 底部视图高度(35)
        // 转发微博：顶部分隔(12) + 间隔(12) + 图像的高度(34) + 间距(12) + 正文高度(需要计算) + 间距(12) + 间距(12) + 转发文本高度(需要计算) + 配图视图高度(计算) + 间距(12) + 底部视图高度(35)
        
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        var height: CGFloat = 0
        
        let viewSize = CGSize(width: XZStatusPictureViewWidth, height: CGFloat(MAXFLOAT))
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweeted = UIFont.systemFont(ofSize: 14)
        
        // 1.计算顶部位置
        height = 2 * margin + iconHeight + margin
        // 2.正文高度
        if let text = status.text {
            /**
             1>预期尺寸，宽度限定，高度尽量大
             2>选项，换行文本，统一使用 usesLineFragmentOrigin
             3>attributes:指定字体字典
             */
            
            height += (text as NSString).boundingRect(with: viewSize,
                                                      options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: originalFont], context: nil).height
        }
        
        // 3.判断是否是转发微博
        if status.retweeted_status != nil {
            height += 2 * margin
            // 转发文本的高度 - 一定用 retweeted，拼接了 @用户名 + 微博文字
            if let textRet = retweetedText {
                height += (textRet as NSString).boundingRect(with: viewSize,
                                                             options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : originalFont], context: nil).height
            }
        }
        
        // 4.配图视图
        height += pictureViewSize.height
        
        height += margin
        
        // 5.底部工具栏
        height += toolbarHeight
        
        // 6.使用属性记录
        rowHeight = height
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
    
    /// 使用单张图像，更新配图视图的大小
    ///
    /// - Parameter image: 网络缓存的单张图像
    func updateSingleImageSize(image: UIImage) {
        
        var size = image.size
        
        // 注意，尺寸需要增加顶部的 12 个点，便于布局
        size.height += XZStatusPictureViewOutterMargin
        
        // 重新设置配图视图大小
        pictureViewSize = size
        
        // 更新行高
        updateRowHeight()
        print("图片是 - \(image) 大小：\(pictureViewSize)")
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
