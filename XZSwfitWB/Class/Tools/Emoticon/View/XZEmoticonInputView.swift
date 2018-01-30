//
//  XZEmoticonInputView.swift
//  XZ_键盘
//
//  Created by admin on 2018/1/17.
//  Copyright © 2018年 XZ. All rights reserved.
//  表情输入视图

import UIKit

/// 可重用的标识符
private let cellId = "cellId"

class XZEmoticonInputView: UIView {
    
    /// 选中表情回调闭包属性
    private var selectedEmoticonCallBack: ((_ emoticon: XZEmoticon?)->())?
    
    /// 加载并返回输入视图
    class func inputView(selectedEmoticon: @escaping (_ emoticon: XZEmoticon?)->()) -> XZEmoticonInputView {
        let nib = UINib(nibName: "XZEmoticonInputView", bundle: nil)
        
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! XZEmoticonInputView
        
        // 记录闭包
        view.selectedEmoticonCallBack = selectedEmoticon
        
        return view
    }
    
    override func awakeFromNib() {
        // 注册可重用 cell
        collectionView.register(XZEmoticonCell.self, forCellWithReuseIdentifier: cellId)
        
        // 设置工具栏代理
        toolbar.delegate = self
        
        // 2> 设置分页控件的图片
        let bundle = XZEmoticonManager.shared.bundle
        guard let normalImage = UIImage(named: "compose_keyboard_dot_normal", in: bundle, compatibleWith: nil),
            let selectedIamge = UIImage(named: "compose_keyboard_dot_selected", in: bundle, compatibleWith: nil)
            else {
                return
        }
        
        // 使用填充图片设置颜色
        //        pageControl.pageIndicatorTintColor = UIColor(patternImage: normalImage)
        //        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: selectedIamge)
        
        // 使用 KVC 设置私有成员属性
        pageControl.setValue(normalImage, forKey: "_pageImage")
        pageControl.setValue(selectedIamge, forKey: "_currentPageImage")
        
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
//        let nib = UINib(nibName: "XZEmoticonCell", bundle: nil)
//
//        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    /// 工具栏
    @IBOutlet weak var toolbar: XZEmoticonToolbar!
    /// 分页控件
    @IBOutlet weak var pageControl: UIPageControl!
}

// MARK: - XZEmoticonToolbarDelegate
extension XZEmoticonInputView: XZEmoticonToolbarDelegate {
    
    func emoticonToolbarDidSelectedItemIndex(toolbar: XZEmoticonToolbar, index: Int) {
        // 让 collectionView 发生滚动 -> 每一个分组的第0页
        let indexPath = IndexPath(item: 0, section: index)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        // 设置分组按钮的选中状态
        toolbar.selectedIndex = index
    }
    
}

// MARK: - UICollectionViewDelegate
extension XZEmoticonInputView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.获取中心点
        var center = scrollView.center
        center.x += scrollView.contentOffset.x
        
        // 2.获取当前显示的 cell 的 indexPath
        let paths = collectionView.indexPathsForVisibleItems
        
        // 3.判断中心点在哪一个 indexPath 上，在哪一个页面上
        var targetIndexPath: IndexPath?
        
        for indexPath in paths {
            // 1> 根据 indexPath 获得 cell
            let cell = collectionView.cellForItem(at: indexPath)
            
            // 2> 判断中心点位置
            if cell?.frame.contains(center) == true {
                targetIndexPath = indexPath
                
                break
            }
        }
        
        guard let targatIdxPath = targetIndexPath else {
            return
        }
        
        // 4.判断是否找到目标的 indexPath
        // indexPath.section => 对应的就是分组
        toolbar.selectedIndex = targatIdxPath.section
        
        // 5.设置分页控件
        // 1>总页数，不同的分组，页数不一样
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: targatIdxPath.section)
        pageControl.currentPage = targatIdxPath.item
        
    }
}

// MARK: - UICollectionViewDataSource
extension XZEmoticonInputView: UICollectionViewDataSource {
    // 分组数量 - 返回表情包数量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return XZEmoticonManager.shared.packages.count
    }
    
    // 返回每个分组中的表情'页'的数量
    // 每个分组的表情包中 表情页面的数量 emoticons 数组 / 20
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return XZEmoticonManager.shared.packages[section].numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.取 cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! XZEmoticonCell
        
        // 2.设置 cell
        cell.emoticons = XZEmoticonManager.shared.packages[indexPath.section].emoticon(page: indexPath.item)
//        // 2.设置 cell
//        cell.label.text = "\(indexPath.section) - \(indexPath.item)"
        
        // 设置代理 - 不适合用闭包
        cell.delegate = self
        
        // 3.返回 cell
        return cell
    }
}

// MARK: - XZEmoticonCellDelegate
extension XZEmoticonInputView: XZEmoticonCellDelegate {
    
    /// 选中的表情回调
    ///
    /// - Parameters:
    ///   - cell: 分页 cell
    ///   - em:   选中的表情，删除键为 nil
    func emoticonCellDidSelectedEmoticon(cell: XZEmoticonCell, em: XZEmoticon?) {
        // print(em)
        // 执行闭包，回调选中的表情
        selectedEmoticonCallBack?(em)
        
        // 添加最近使用的表情
        guard let em = em else {
            return
        }
        
        // 如果当前 collectionView 就是最近的分组，不添加最近使用的表情
        let indexPath = collectionView.indexPathsForVisibleItems[0]
        if indexPath.section == 0 {
            return
        }
        
        // 添加最近使用的表情
        XZEmoticonManager.shared.recentEmoticon(em: em)
        
        // 刷新数据 - 第 0 组
        var indexSet = IndexSet()
        indexSet.insert(0)
        
        collectionView.reloadSections(indexSet)
    }
    
}
