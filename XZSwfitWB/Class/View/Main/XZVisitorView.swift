//
//  XZVisitorView.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/5.
//  Copyright © 2017年 XZ. All rights reserved.
//

import UIKit

class XZVisitorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置页面
extension XZVisitorView {
    
    func setupUI() {
        backgroundColor = .white
    }
    
}
