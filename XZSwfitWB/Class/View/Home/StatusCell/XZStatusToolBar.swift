//
//  XZStatusToolBar.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

class XZStatusToolBar: UIView {
    
    var viewModel: XZStatusViewModel? {
        didSet {
            // 转发
            btnRetweeted.setTitle("\(viewModel?.retweetedStr ?? "转发")", for: [])
            // 评论
            btnComment.setTitle("\(viewModel?.commentStr ?? "评论")", for: [])
            // 赞
            btnLike.setTitle("\(viewModel?.likeStr ?? "赞")", for: [])
        }
    }
    
    /// 转发
    @IBOutlet weak var btnRetweeted: UIButton!
    /// 评论
    @IBOutlet weak var btnComment: UIButton!
    /// 点赞
    @IBOutlet weak var btnLike: UIButton!

}
