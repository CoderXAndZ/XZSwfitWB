//
//  XZEmoticonLayout.swift
//  XZ_键盘
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 XZ. All rights reserved.
//  表情集合视图的布局

import UIKit

class XZEmoticonLayout: UICollectionViewFlowLayout {
    
    /// prepare 就是 OC 中的 prepareLayout
    override func prepare() {
        super.prepare()
        
        // 在此方法中，collectionView 的大小已经确定
        guard let collectionView = collectionView else {
            return
        }
        
        itemSize = collectionView.bounds.size
        
//        minimumLineSpacing = 0
//        minimumInteritemSpacing = 0
//
//        // 设定滚动方向
//        // 水平方向滚动，cell 垂直方向布局
//        // 垂直方向滚动，cell 水平方向布局
//        scrollDirection = .horizontal
    }
    
    
}
