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
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
//        let nib = UINib(nibName: "XZEmoticonCell", bundle: nil)
//
//        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIView!
    
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
    
    func emoticonCellDidSelectedEmoticon(cell: XZEmoticonCell, em: XZEmoticon?) {
        // print(em)
        // 执行闭包，回调选中的表情
        selectedEmoticonCallBack?(em)
    }
    
}
