//
//  XZStatusCell.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/23.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

class XZStatusCell: UITableViewCell {
    
    /// 微博视图模型
    var viewModel: XZStatusViewModel? {
        didSet {
            /// 微博文本
            labelContent.text = viewModel?.status.text
            
            /// 姓名
            labelName.text = viewModel?.status.user?.screen_name
            
            /// 设置会员图标 - 直接获取属性，不需要计算
            imgMemberIcon.image = viewModel?.memberIcon
            
            /// 认证图标
            imgVipIcon.image = viewModel?.vipIcon
            
            /// 用户头像
            imgIcon.xz_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage.init(named: "avatar_default_big"), isAvatar: true)
            
            /// 底部栏
            toolBar.viewModel = viewModel
            
            // 配图视图模型
            pictureView.viewModel = viewModel
            
            // 设置被转发微博的文字
            labelRetweeted?.text = viewModel?.retweetedText
            
            /// 测试修改配图视图的高度
            //  pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            
            // 设置配图视图的 URL 数据
            // 测试 4 张图像
//            if viewModel?.status.pic_urls?.count ?? 0 > 4 {
//                // 修改数组 -> 将末尾的数据全部删除
//                guard var picURLs = viewModel?.status.pic_urls else {
//                    return
//                }
//                picURLs.removeSubrange((picURLs.startIndex + 4)..<picURLs.endIndex)
//                pictureView.urls = picURLs
//            }else {
           // 设置配图 - 被转发和原创
//           pictureView.urls = viewModel?.picURLs
//            }
        }
    }
    
    /// 头像
    @IBOutlet weak var imgIcon: UIImageView!
    /// 会员图标
    @IBOutlet weak var imgMemberIcon: UIImageView!
    /// 来源
    @IBOutlet weak var labelSource: UILabel!
    /// 时间
    @IBOutlet weak var labelTime: UILabel!
    /// 微博名
    @IBOutlet weak var labelName: UILabel!
    /// 微博正文
    @IBOutlet weak var labelContent: UILabel!
    /// 会员认证图标
    @IBOutlet weak var imgVipIcon: UIImageView!
    /// 底部栏
    @IBOutlet weak var toolBar: XZStatusToolBar!
    /// 配图视图
    @IBOutlet weak var pictureView: XZStatusPictureView!
    /// 被转发微博的标签 - 原创微博没有此空间，一定要用 ‘?’
    @IBOutlet weak var labelRetweeted: UILabel?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // 取消选中
        self.selectionStyle = .none
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // 离屏渲染 - 异步检测
        layer.drawsAsynchronously = true
        // 栅格化 - 异步绘制之后，会生成一张独立的图像，cell在屏幕上滚动的时候，本质上滚动的是这张图片
        // cell优化，要尽量减少图层的数量，相当于就只有一层！
        // 停止滚动之后，可以接收监听
        layer.shouldRasterize = true
        
        // 使用 '栅格化' 必须指定分辨率
        layer.rasterizationScale = UIScreen.main.scale
    }
}
