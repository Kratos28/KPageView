//
//  KContentView.swift
//  KPageView
//
//  Created by Kratos on 17/4/8.
//  Copyright © 2017年 Kratos. All rights reserved.
//

import UIKit

protocol KContentViewDelegate : class {
    func contentView(_ contentView : KContentView, inIndex : Int)
    func contentView(_ contentView : KContentView, sourceIndex : Int, targetIndex : Int, progress : CGFloat)
}

private let kContentCellID = "kContentCellID"

class KContentView: UIView {
    
    // MARK: 定义属性
    weak var delegate : KContentViewDelegate?
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isForbidDelegate : Bool = false
    
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal;
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        return collectionView
    }()
    
    // MARK: 构造函数
    init(frame: CGRect, childVcs : [UIViewController], parentVc : UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
        
    }

}


extension KContentView {
    fileprivate func setupUI() {
     
        // 1.添加collectionView
        addSubview(collectionView)
        // 2.将所有的子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc.addChildViewController(childVc)
        }
    }
}


extension KContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        // 2.给cell设置内容
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}


extension KContentView : UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionViewDidEndScroll()
        }
    }
    
    func collectionViewDidEndScroll() {
        // 1.获取位置
        let inIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        // 2.通知代理
        delegate?.contentView(self, inIndex: inIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 1.判断是否需要执行后续的代码
        if scrollView.contentOffset.x == startOffsetX || isForbidDelegate {
            return
        }
        
        // 2.定义需要的参数
        var progress : CGFloat = 0
        var targetIndex = 0;
        var sourceIndex = 0;
        
        progress = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.bounds.width) / scrollView.bounds.width;

        if progress == 0
        {
            return;
        }
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width);
        
        // 3.判断用户是左滑动还是右滑动
        if collectionView.contentOffset.x > startOffsetX { // 左滑动
            sourceIndex = index
            targetIndex = index + 1
            if targetIndex > childVcs.count - 1
            {
                    return;
            }
        } else { // 右滑动
            sourceIndex = index + 1;
            targetIndex = index;
            progress = 1 - progress;
            if  targetIndex < 0 {
                return;
            }
        }

        
        // 4.通知代理
        delegate?.contentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
}


extension KContentView : KTitleViewDelegate {
    func titleView(_ titleView: KTitleView, currentIndex: Int) {
        // 0.设置isForbidDelegate属性为true
        isForbidDelegate = true
        
        // 1.根据currentIndex获取indexPath
        let indexPath = IndexPath(item: currentIndex, section: 0)
        
        // 2.滚动到正确的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}










