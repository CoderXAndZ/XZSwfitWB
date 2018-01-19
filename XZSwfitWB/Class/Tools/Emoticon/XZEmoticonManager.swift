//
//  XZEmoticonManager.swift
//  XZ-表情包
//
//  Created by admin on 2018/1/9.
//  Copyright © 2018年 XZ. All rights reserved.
//  表情管理器

import UIKit

class XZEmoticonManager {
    // 为了便于表情的复用，创建单例，只加载一次表情数据
    /// 表情管理器单例
    static let shared = XZEmoticonManager()
    
    /// 表情包的懒加载数组
    lazy var packages = [XZEmoticonPackage]()
    
    /// 表情素材的 bundle
    lazy var bundle: Bundle = {
        let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil)
        
        return Bundle(path: path!)!
    }()
    
    /// 构造函数，如果在 init 之前添加 private 修饰符，可以要求调用者必须通过 shared 访问对象
    /// 锁住单例，避免重复创建：OC 要重写 allocWithZone 方法
    private init() {
        loadPackages()
    }
}

// MARK: - 表情字符串处理
extension XZEmoticonManager {
    
    /// 将给定的字符串转换成属性文本
    ///
    /// 关键点：要按照匹配结果倒叙替换属性文本！
    ///
    /// - Parameter stting: 完整的字符串
    /// - Returns: 属性文本
    func emoticonString(string: String, font: UIFont) -> NSAttributedString {
        // NSAttributedString 是不可变的
        let attrString = NSMutableAttributedString(string: string)
        
        // 1.建立正则表达式，过滤所有的表情文字
        // [] () 都是表达式的关键字，如果要参与匹配，需要转义
        let pattern = "\\[(.*?)\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrString
        }
        
        // 2.匹配所有项
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attrString.length))
        
        // 3.遍历所有匹配结果
        for m in matches.reversed() {
            let range = m.range(at: 0)
            
            print(range.location, range.length)
            
            let subStr = (attrString.string as NSString).substring(with: range)
            
            // 1>使用 subStr 查找对应的表情符号
            if let em = XZEmoticonManager.shared.findEmoticon(string: subStr){
                
                // 2>使用表情符号中的属性文本，替换原有的属性文本的内容
                attrString.replaceCharacters(in: range, with: em.imageText(font: font))
            }
        }
        
        // 4. *** 统一设置一遍字符串的属性,除了需要设置字体，还需要设置'颜色'!
        attrString.addAttributes([NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : UIColor.darkGray],
                                 range: NSRange(location: 0, length: attrString.length))
        
        return attrString
    }
    
    /// 根据 string '[爱你]' 在所有的表情符号中查找对应的表情模型对象
    ///
    /// - 如果找到，返回表情模型
    /// - 否则，返回 nil
    func findEmoticon(string: String) -> XZEmoticon? {
        // 1.遍历表情包
        // OC 中过滤数组使用 [谓词]
        // Swift 中更简单
        for p in packages {
            
            // 2.在表情数组中过滤 string
            // 方法1
            let result = p.emoticons.filter({ (em) -> Bool in
                return em.chs == string
            })
//            // 方法2 - 尾随闭包
//            let result = p.emoticons.filter(){ (em) -> Bool in
//                return em.chs == string
//            }
//            // 方法3 - 如果闭包中只有一句，并且是返回
//            // 1>闭包格式定义可以省略
//            // 2>参数省略之后，使用 $0,$1... 一次替代原有的参数
//            let result = p.emoticons.filter(){
//                return $0.chs == string
//            }
            
            // 方法4 - 如果闭包中只有一句，并且是返回
            // 1>闭包格式定义可以省略
            // 2>参数省略之后，使用 $0,$1... 一次替代原有的参数
            // 3>return 也可以省略
//            let result = p.emoticons.filter(){
//                $0.chs == string
//            }
            
            // 3.判断结果数组的数量
            if result.count == 1 {
                return result[0]
            }
        }
        
        return nil
    }
}

// MARK: - 表情包数据处理
extension XZEmoticonManager {
    
    func loadPackages() {
        // 读取 emoticon.plist
        // 只要按照 Bundle 默认的目录结构设定，就可以直接读取 Resources 目录下的文件
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
              let bundle = Bundle(path: path),
              let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
              let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
              let models = NSArray.yy_modelArray(with: XZEmoticonPackage.self, json: array) as? [XZEmoticonPackage]
            else {
            return
        }
        
        // 设置表情包数据
        // 使用 += 不需要再次给 package 分配空间，直接追加数据
        packages += models
        
        print(array)
    }
    
}





