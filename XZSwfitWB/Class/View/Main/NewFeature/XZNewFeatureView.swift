//
//  XZNewFeatureView.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/20.
//  Copyright © 2017年 XZ. All rights reserved.
//  新特性视图

import UIKit

class XZNewFeatureView: UIView {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var btnEnter: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// 进入微博
    @IBAction func enterStatus(_ sender: Any) {
        removeFromSuperview()
    }
    
    class func newFeatureView() -> XZNewFeatureView {
        let nib = UINib.init(nibName: "XZNewFeatureView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! XZNewFeatureView
        
        // 从 xib 加载的视图，默认就是 600 * 600 的
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    // 从 xib 加载完成调用
    override func awakeFromNib() {
        // 如果使用自动布局设置的界面，从 xib 加载的视图，默认就是 600 * 600 大小
        // 添加 4 个图像视图
        let count = 4
        let rect = UIScreen.main.bounds
        
        for i in 0..<count {
            
            let imgName = "new_feature_\(i + 1)"
            let iv = UIImageView.init(image: UIImage.init(named: imgName))
            
            // 设置大小
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            
            scrollView.addSubview(iv)
        }
        
        // 指定 scrollView 的属性
        // 注意:count + 1 的效果更好
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.delegate = self
        
        // 隐藏按钮
        btnEnter.isHidden = true
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        backgroundColor = .orange
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}

extension XZNewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 1.滚动到最后一屏，让视图删除
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        // 页数
        let count = scrollView.subviews.count
        
        // 2.判断是否最后一页
        if page == count {
            print("欢迎欢迎，")
            removeFromSuperview()
        }
        
        // 3.如果是倒数第 2 页，显示按钮
        btnEnter.isHidden = (page != count - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 1.一旦滚动隐藏按钮
        btnEnter.isHidden = true
        
        // 2.计算当前的偏移量
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        // 3.设置分页控件
        pageControl.currentPage = page
        
        // 4.分页控件的隐藏
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
}



