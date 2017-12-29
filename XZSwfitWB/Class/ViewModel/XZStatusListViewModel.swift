//
//  XZStatusListViewModel.swift
//  XZSwfitWB
//
//  Created by admin on 2017/12/13.
//  Copyright © 2017年 XZ. All rights reserved.
//  微博数据列表视图模型

import Foundation
import SDWebImage

/**
 父类的选择
 -如果类只需要使用 ‘KVC’ 或者字典转模型框架设置对象值，类就需要继承自 NSObject
 -如果类只是包装一些代码逻辑(写了一些函数)，可以不用任何父类，好处：更加轻量级
 -提示：如果用 OC 写，一律继承自 NSObject 即可
 
 使命：负责微博的数据处理
 1.字典转模型
 2.下拉 / 上拉 刷新数据处理
 */

// 对于测试用户(应用程序还没有提交给新浪微博审核)每天的刷新量是有限的！
// 超出上限，token 会被锁定一段时间
// 上拉刷新最大尝试次数
private let maxPullupTryTimes = 3

class XZStatusListViewModel {
    // 微博模型数组懒加载
    lazy var statusList = [XZStatusViewModel]()
    // 上拉刷新错误次数
    private var pullupErrorTimes = 0
    
    /// 加载微博列表
    ///
    /// - Parameters:
    ///   - pullup:     是否上拉加载标记
    ///   - completion: 完成回调[网络请求是否成功，是否刷新表格]
    func loadStatus(pullup: Bool = false,completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        // 判断是否是上拉加载，同时检查刷新错误
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true,false)
            return
        }
        
        // 取出微博数组中第一条微博的 id
        let since_id = pullup ? 0 : statusList.first?.status.id ?? 0
        // 上拉加载，取出微博数组中最后一条微博的 id
        let max_id = !pullup ? 0 : statusList.last?.status.id ?? 0
        
        // 用 网络工具 加载微博数据
        XZNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            // 0.判断网络请求是否成功
            if !isSuccess {
                completion(false, false)
                return
            }
            
            // 1.字典转模型，绑定表格数据(所有第三方框架都支持嵌套的字典转模型!)
            // 1> 定义结果可变数组
            var array = [XZStatusViewModel]()
            // 2> 遍历服务器返回的字典数组，字典转模型
            for dict in list ?? [] {
                print("图片数据 --- \(dict["pic_urls"])")
                
//                var array = [XZStatusPicture]()
//                array = dict["pic_urls"] as? [XZStatusPicture]
//                print("array ---- \(array)")
//                let dic = dict["pic_urls"] as? [XZStatusPicture]
                
                // a) 创建微博模型 - 如果创建模型失败，继续后续的遍历
                let status = XZStatus()
                
                status.yy_modelSet(with: dict)
                
//                status.pic_urls = dic
                
//                status.pic_urls = dict["pic_urls"] as? [XZStatusPicture]
                
//                print("字典转模型 --- \(status.pic_urls)")
                
                // b) 将 视图模型 添加到数组
                let viewModel = XZStatusViewModel(model: status)

                array.append(viewModel)
            }
//            guard let array = NSArray.yy_modelArray(with: XZStatus.self, json: list ?? []) as? [XZStatus] else {
//                completion(isSuccess,false)
//                return
//            }
            print("刷新到 \(array.count) 条数据 \(array)")
            // 2.拼接数据
            if pullup { // 上拉加载
                // 结束后将结果拼接在数组的末尾
                self.statusList += array
            }else { // 下拉刷新
                // 将结果数据品加载数组前面
                self.statusList = array + self.statusList
            }
            
            // 3.完成回调
            // 判断上拉刷新的数据量
            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            }else {
                // 4.真正有数据的回调!
                self.cacheSingleImage(list: array, finished: completion)
//                completion(isSuccess, true)
            }
        }
    }
    
    /// 缓存本次下载微博数据数组中单张图像
    /// - 应该缓存完单张图像，并且修改过配图视图大小之后，再回调，才能够保证表格等比例显示单张图像！
    ///
    /// - Parameter list: 本次下载的视图模型数组
    private func cacheSingleImage(list: [XZStatusViewModel], finished: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        // 调度组
        let group = DispatchGroup()
        
        // 记录数据长度
        var length = 0
        
        // 遍历数组，查找微博数据中有单张图像的，进行缓存
        // 遍历完成，视图模型的数组完成，所有配图的 url 就可以知道！
        for vm in list {
            // 1> 判断图像数量
            if vm.picURLs?.count != 1 {
                continue
            }
            // 2>代码执行到此，数组中有且仅有一张图片
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                let url = URL.init(string: pic) else {
                continue
            }
            
            print("要缓存的 URL 是 \(url)")
            // 3>下载图像
            /**
              a)downloadImage 是 SDWebImage 的核心方法
              b)图像下载完成之后，会自动保存在沙盒中，文件路径是 url 的 md5
              c)如果沙盒中已经存在缓存的图像，后续使用 SD 通过 URL 加载图像，都会加载本地沙盒的图像
              d)不会发起网络请求，同时，回调方法，同样会调用！
              e)方法还是同样的方法，调用还是同样的调用，不过内部不会再次发起网络请求！
             */
            // 注意：如果要缓存的图像累计很大，要找后台要接口！
            
            // A> 入组
            group.enter()
        SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _) in
                // 将图像转换成二进制数据
                if let image = image,
                    let data = UIImagePNGRepresentation(image) {
                    
                    // NSData 是 length 属性
                    length += data.count
                    
                    // 图像缓存成功，更新配图视图的大小
                    vm.updateSingleImageSize(image: image)
                }
                print("缓存的图像是 \(image)")
            
                // B)出组 - 放在回调的最后一句
                group.leave()
            })
        }
        
        // C>监听调度组情况
        group.notify(queue: DispatchQueue.main) {
            print("图像缓存完成 \(length / 1024) K")
            // 执行闭包回调
            finished(true, true)
        }
    }
}
