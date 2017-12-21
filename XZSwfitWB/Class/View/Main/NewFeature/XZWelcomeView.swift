//
//  XZWelcomeView.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/20.
//  Copyright © 2017年 XZ. All rights reserved.
//  欢迎视图

import UIKit
import SDWebImage

class XZWelcomeView: UIView {
    /// 头像视图
    @IBOutlet weak var imageIcon: UIImageView!
    /// 欢迎语
    @IBOutlet weak var labelTip: UILabel!
    /// 底部约束
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    class func welcomeView() -> XZWelcomeView {
        let nib = UINib(nibName: "XZWelcomeView", bundle: nil)
        // 取 last 值是可选的，取 [0] 就不需要解包了！
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! XZWelcomeView
        
        // 从 xib 加载的视图，默认就是 600 * 600 的
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 提示：initWithCoder 只是刚从 xib 的二进制文件将视图数据加载完成
        // 还没有和代码连线建立起关系，所以，开发时，千万不要在这个方法中处理 UI
        
        print("initWithCoder + \(imageIcon)")
    }
    
    override func awakeFromNib() {
        
        // 1.url
        guard let urlString = XZNetworkManager.shared.userAccount.avatar_large,
            let url = URL.init(string: urlString) else {
            return
        }
        
        // 2.设置图像 - 如果网络图像没有下载完成，先显示占位图像
        // 如果不指定占位图像，之前设置的图像会被清空！
        imageIcon.sd_setImage(with: url, placeholderImage: UIImage.init(named: "avatar_default_big"), options: [], completed: nil)
        
        // 3.FIXME: - 设置圆角
        imageIcon.layer.cornerRadius = imageIcon.bounds.width * 0.5
        imageIcon.layer.masksToBounds = true
        
        print("awakeFromNib + \(imageIcon)")
    }
    
    /// 视图被添加到 window 上，表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // 视图是使用自动布局来设置的，只是设置了约束
        // - 当视图被添加到窗口上时，根据父视图的大小，计算约束值，更新控件位置
        // - layoutIfNeeded 会直接按照当前的约束直接更新控件位置
        // - 执行之后，控件所在位置，就是 xib 中布局的位置
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 200
        
        // 如果控件们的 frame 还没有计算好！所有的约束会一起动画！
        UIView.animate(withDuration: 3.0,   
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
            // 更新约束
            self.layoutIfNeeded()
            
        }) { (_) in
            UIView.animate(withDuration: 3.0, animations: {
//                self.labelTip.alpha = 1
//                self.imageIcon.alpha = 1
            }, completion: { (_) in
                // 动画加载完成，从当前视图移除
                self.removeFromSuperview()
            })
        }
    }

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        backgroundColor = .purple
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}
