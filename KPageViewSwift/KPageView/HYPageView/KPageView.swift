//
//  KPageView.swift
//  KPageView
//
//  Created by Kratos on 17/4/8.
//  Copyright © 2017年 Kratos. All rights reserved.
//

import UIKit

protocol KPageViewDataSource : class {
    func numberOfSectionsInPageView(_ pageView : KPageView) -> Int
    func pageView(_ pageView : KPageView, numberOfItemsInSection section: Int) -> Int
    func pageView(_ pageView : KPageView, cellForItemAtIndexPath indexPath : IndexPath) -> UICollectionViewCell
}

@objc protocol KPageViewDelegate : class {
    @objc optional func pageView(_ pageView : KPageView, didSelectedAtIndexPath indexPath : IndexPath)
}

class KPageView: UIView {
    // 在swift中, 如果子类有自定义构造函数, 或者重新父类的构造函数, 那么必须实现父类中使用required修饰的构造函数
    weak var dataSource : KPageViewDataSource?
    weak var delegate : KPageViewDelegate?
    
    // MARK: 定义属性
    fileprivate var style : KPageStyle
    fileprivate var titles : [String]
    fileprivate var childVcs : [UIViewController]!
    fileprivate var parentVc : UIViewController!
    fileprivate var layout : KPageViewLayout!
    
    fileprivate var collectionView : UICollectionView!
    fileprivate var pageControl : UIPageControl!
    fileprivate lazy var currentSection : Int = 0
    
    fileprivate lazy var titleView : KTitleView = {
        let titleFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.style.titleHeight)
        let titleView = KTitleView(frame: titleFrame, style: self.style, titles: self.titles)
        titleView.backgroundColor = UIColor.blue
        return titleView
    }()
    
    // MARK: 构造函数
    init(frame: CGRect, style : KPageStyle, titles : [String], childVcs : [UIViewController], parentVc : UIViewController) {
        // 在super.init()之前, 需要保证所有的属性有被初始化
        // self.不能省略: 在函数中, 如果和成员属性产生歧义
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setupContentUI()
    }
    
    init(frame: CGRect, style : KPageStyle, titles : [String], layout : KPageViewLayout) {
        self.style = style
        self.titles = titles
        self.layout = layout
        super.init(frame: frame)
        setupCollectionUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK:- 初始化UI界面
extension KPageView {
    // MARK: 初始化控制器的UI
    fileprivate func setupContentUI() {
        
        self.addSubview(titleView)
        
        // 1.创建KContentView
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = KContentView(frame: contentFrame, childVcs: childVcs, parentVc : parentVc) as KContentView
        contentView.backgroundColor = UIColor.randomColor
        addSubview(contentView)
        
        // 2.让KTitleView&KContentView进行交互
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
    
    // MARK: 初始化collectionView的UI
    fileprivate func setupCollectionUI() {
        // 1.添加titleView
        self.addSubview(titleView)
        
        // 2.添加collectionView
        let collectionFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight - style.pageControlHeight)
        
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        // 3.添加UIPageControl
        let pageControlFrame = CGRect(x: 0, y: collectionView.frame.maxY, width: bounds.width, height: style.pageControlHeight)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        addSubview(pageControl)
        pageControl.isEnabled = false
        
        // 4.监听titleView的点击
        titleView.delegate = self
    }
}


// MARK:- UICollectionView的数据源
extension KPageView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSectionsInPageView(self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemCount = dataSource?.pageView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageView(self, cellForItemAtIndexPath: indexPath)
    }
}

extension KPageView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageView?(self, didSelectedAtIndexPath: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionViewDidEndScroll()
        }
    }
    
    func collectionViewDidEndScroll() {
        // 1.获取当前显示页中的某一个cell的indexPath
        let point = CGPoint(x: layout.sectionInset.left + collectionView.contentOffset.x, y: layout.sectionInset.top)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        
        // 2.如果发现组(section)发生了改变, 那么重新设置pageControl的numberOfPages
        if indexPath.section != currentSection {
            // 2.1.改变pageControl的numberOfPages
            let itemCount = dataSource?.pageView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.rows * layout.cols) + 1
            
            // 2.2.记录最新的currentSection
            currentSection = indexPath.section
            
            // 2.3.让titleView选中最新的title
            titleView.setCurrentIndex(currentIndex: currentSection)
        }
        
        // 3.显示pageControl正确的currentPage
        let pageIndex = indexPath.item / 8
        pageControl.currentPage = pageIndex
    }
}


// MARK:- 实现KTitleView的代理方法
extension KPageView : KTitleViewDelegate {
    func titleView(_ titleView: KTitleView, currentIndex: Int) {
        // 1.滚动到正确的位置
        let indexPath = IndexPath(item: 0, section: currentIndex)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        // 2.微调collectionView -- contentOffset
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        // 3.改变pageControl的numberOfPages
        let itemCount = dataSource?.pageView(self, numberOfItemsInSection: currentIndex) ?? 0
        pageControl.numberOfPages = (itemCount - 1) / (layout.rows * layout.cols) + 1
        pageControl.currentPage = 0
        
        // 4.记录最新的currentSection
        currentSection = currentIndex
    }
}


// MARK:- 对外提供的函数
extension KPageView {
    func registerCell(_ cellClass : AnyClass?, identifier : String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func registerNib(_ nib : UINib?, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withReuseIdentifier : String, for indexPath : IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, for: indexPath)
    }
}












