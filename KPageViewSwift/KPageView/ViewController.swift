//
//  ViewController.swift
//  KPageView
//
//  Created by Kratos on 17/4/8.
//  Copyright © 2017年 Kratos. All rights reserved.
//

import UIKit

private let kCollectionViewCellID = "kCollectionViewCellID"

class ViewController: UIViewController {
    
    // MARK: 重写的函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
//        // 1.创建需要的样式
        let style = KPageStyle()
        
        // 2.获取所有的标题
        let titles = ["推荐", "游戏", "热门", "趣玩"]
        
        // 3.创建布局
        let layout = KPageViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.lineSpacing = 10
        layout.itemSpacing = 10
        layout.cols = 4
        layout.rows = 2
        
        // 4.创建KPageView
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: 300)
        let pageView = KPageView(frame: pageFrame, style: style, titles: titles, layout : layout)
        pageView.dataSource = self
        pageView.delegate = self
        pageView.registerCell(UICollectionViewCell.self, identifier: kCollectionViewCellID)
        pageView.backgroundColor = UIColor.orange
        view.addSubview(pageView)

        // 1.创建需要的样式
//        let style = KPageStyle()
//        style.isScrollEnable = true
//        //        style.isShowCoverView = true
//        //        style.isShowBottomLine = true
//        //        style.isScaleEnable = true
//        
//        // 2.获取所有的标题
//        //         let titles = ["推荐", "游戏", "热门", "趣玩", "娱乐"]
//        let titles = ["推荐", "游戏游戏游戏", "热门游戏", "趣玩游", "娱乐", "热门游戏", "趣玩游", "娱乐"]
//        
//        // 3.获取所有的内容控制器
//        var childVcs = [UIViewController]()
//        for _ in 0..<titles.count {
//            let vc = UIViewController()
//            vc.view.backgroundColor = UIColor.randomColor
//            childVcs.append(vc)
//        }
//        
//        // 4.创建KPageView
//        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
//        let pageView = KPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs, parentVc : self)
//        pageView.backgroundColor = UIColor.blue
//        view.addSubview(pageView)
    }
    
}


extension ViewController : KPageViewDataSource {
    func numberOfSectionsInPageView(_ pageView: KPageView) -> Int {
        return 4
    }
    
    func pageView(_ pageView: KPageView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 12
        } else if section == 1 {
            return 30
        } else if section == 2 {
            return 7
        }
        
        return 13
    }
    
    func pageView(_ pageView: KPageView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pageView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellID, for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor
        
        return cell
    }
}


extension ViewController : KPageViewDelegate {
    func pageView(_ pageView: KPageView, didSelectedAtIndexPath indexPath: IndexPath) {
        print(indexPath)
    }
}










