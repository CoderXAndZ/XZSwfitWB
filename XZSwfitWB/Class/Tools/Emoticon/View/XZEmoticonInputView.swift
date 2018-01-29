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

extension XZEmoticonInputView: XZEmoticonToolbarDelegate {
    
    func emoticonToolbarDidSelectedItemIndex(toolbar: XZEmoticonToolbar, index: Int) {
        // 让 collectionView 发生滚动 -> 每一个分组的第0页
        let indexPath = IndexPath(item: 0, section: index)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        // 设置分组按钮的选中状态
        toolbar.selectedIndex = index
    }
    
}

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
