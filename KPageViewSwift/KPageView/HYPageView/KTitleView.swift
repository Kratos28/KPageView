//
//  KTitleView.swift
//  KPageView
//
//  Created by Kratos on 17/4/8.
//  Copyright © 2017年 Kratos. All rights reserved.
//

import UIKit

protocol KTitleViewDelegate : class {
    func titleView(_ titleView : KTitleView, currentIndex : Int)
}

class KTitleView: UIView {
    
    // MARK: 定义属性
    // weak : 只能用来修饰对象
    // 指针 --> 引用
    typealias ColorRGB = (red : CGFloat, green : CGFloat, blue : CGFloat)
    
    weak var delegate : KTitleViewDelegate?
    
    fileprivate var style : KPageStyle
    fileprivate var titles : [String]
    fileprivate var currentIndex : Int = 0
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var selectRGB : ColorRGB = self.style.selectColor.getRGB()
    fileprivate lazy var normalRGB : ColorRGB = self.style.normalColor.getRGB()
    fileprivate lazy var deltaRGB : ColorRGB = {
        let deltaR = self.selectRGB.red - self.normalRGB.red
        let deltaG = self.selectRGB.green - self.normalRGB.green
        let deltaB = self.selectRGB.blue - self.normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height = self.style.bottomLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.bottomLineHeight
        return bottomLine
    }()
    fileprivate lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = self.style.coverAlpha
        return coverView
    }()
    
    // MARK: 构造函数
    init(frame: CGRect, style : KPageStyle, titles : [String]) {
        self.style = style
        self.titles = titles
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK:- 设置UI界面
extension KTitleView {
    fileprivate func setupUI() {
        // 1.添加一个UIScrollView
        addSubview(scrollView)
        
        // 2.设置所有的标题
        setupTitleLabels()
        
        // 3.设置label的frame
        setupLabelsFrame()
        
        // 4.设置bottomLine
        setupBottomLine()
        
        // 5.设置coverView
        setupCoverView()
    }
    
    private func setupCoverView() {
        
        // 1.判断是否需要显示coverView
        guard style.isShowCoverView else {
            return
        }
        
        // 2.添加到scrollView
        scrollView.insertSubview(coverView, at: 0)
        
        // 3.设置遮盖的frame
        let firstLabel = titleLabels.first!
        var coverW = firstLabel.bounds.width
        let coverH = style.coverHeight
        var coverX = firstLabel.frame.origin.x
        let coverY = (firstLabel.frame.height - coverH) * 0.5
        if style.isScrollEnable {
            coverX -= style.coverMargin
            coverW += 2 * style.coverMargin
        }
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        
        // 4.设置圆角
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
    }
    
    
    private func setupBottomLine() {
        // 1.判断是否需要显示BottomLine
        guard style.isShowBottomLine else {
            return
        }
        
        // 2.将bottomLine添加到scrollView中
        scrollView.addSubview(bottomLine)
        
        // 3.设置bottomLine的frame中的属性
        bottomLine.frame.origin.x = titleLabels.first!.frame.origin.x
        bottomLine.frame.size.width = titleLabels.first!.frame.width
    }
    
    private func setupLabelsFrame() {
        
        // 1.定义出变量&常量
        let labelH = style.titleHeight
        let labelY : CGFloat = 0
        var labelW : CGFloat = 0
        var labelX : CGFloat = 0
        
        // 2.设置titleLabel的frame
        let count = titleLabels.count
        for (i, titleLabel) in titleLabels.enumerated() {
            if style.isScrollEnable { // 可以滚动
                labelW = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : titleLabel.font], context: nil).width
                labelX = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i-1].frame.maxX + style.titleMargin)
            } else { // 不可以滚动
                labelW = bounds.width / CGFloat(count)
                labelX = labelW * CGFloat(i)
            }
            
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            
        }
        
        // 设置scale属性
        if style.isScaleEnable {
            // ?. 在等号的左边, 那么系统会自动判断可选类型是否有值
            // ?. 在等号的右边, 那么如果可选类型没有值, 该语句返回nil
            titleLabels.first?.transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
        }
        
        // 3.设置contentSize
        if style.isScrollEnable {
            scrollView.contentSize.width = titleLabels.last!.frame.maxX + style.titleMargin * 0.5
        }
    }
    
    private func setupTitleLabels() {
        // 元祖: (a,b)
        for (i, title) in titles.enumerated() {
            // 1.创建UILabel
            let label = UILabel()
            
            // 2.设置label的属性
            label.tag = i
            label.text = title
            label.textColor = i == 0 ? style.selectColor : style.normalColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: style.fontSize)
            
            // 3.将label添加到scrollView中
            scrollView.addSubview(label)
            
            // 4.将label添加到数组中
            titleLabels.append(label)
            
            // 5.监听label的点击
            // 事件监听依然是发送消息
            // swift: #selector
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled = true
        }
    }
}


// MARK:- 监听label的点击
extension KTitleView {
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer) {
        // 1.校验UILabel
        guard let targetLabel = tapGes.view as? UILabel else {
            return
        }
        guard targetLabel.tag != currentIndex else {
            return
        }
        
        // 2.设置最新的targetLabel
        setTargetLabel(targetLabel)
        
        // 3.通知代理
        delegate?.titleView(self, currentIndex: currentIndex)
    }
    
    fileprivate func setTargetLabel(_ targetLabel : UILabel) {
        // 1.取出原来的label
        let sourceLabel = titleLabels[currentIndex]
        
        // 2.改变Label的颜色
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectColor
        
        // 3.记录最新的index
        currentIndex = targetLabel.tag
        
        // 4.让点击的label居中显示
        adjustLabelPosition(targetLabel)
        
        // 5.调整scale缩放
        // transform : frame.wh = bounds.wh * transform的值
        if style.isScaleEnable {
            UIView.animate(withDuration: 0.25, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            })
        }
        
        // 6.调整bottomLine
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }
        
        // 7.调整CoverView
        if style.isShowCoverView {
            let coverX = style.isScrollEnable ? (targetLabel.frame.origin.x - style.coverMargin) : targetLabel.frame.origin.x
            let coverW = style.isScrollEnable ? (targetLabel.frame.width + style.coverMargin * 2) : targetLabel.frame.width
            UIView.animate(withDuration: 0.15, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }
    }
    
    fileprivate func adjustLabelPosition(_ targetLabel : UILabel) {
        // 0.只有可以滚动的时候调整
        guard style.isScrollEnable else {
            return
        }
        
        // 1.计算一下offsetX
        var offsetX = targetLabel.center.x - bounds.width * 0.5
        
        // 2.临界值的判断
        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
            offsetX = scrollView.contentSize.width - scrollView.bounds.width
        }
        
        // 3.设置scrollView的contentOffset
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}



extension KTitleView : KContentViewDelegate {
    func contentView(_ contentView: KContentView, inIndex: Int) {
        // 1.记录最新的currentIndex
        currentIndex = inIndex
        
        // 2.让targetLabel居中显示
        adjustLabelPosition(titleLabels[currentIndex])
    }
    
    func contentView(_ contentView: KContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        // 1.获取sourceLabel&targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.颜色的渐变
        sourceLabel.textColor = UIColor(r: selectRGB.red - progress * deltaRGB.red, g: selectRGB.green - progress * deltaRGB.green, b: selectRGB.blue - progress * deltaRGB.blue)
        
        print("sourceLabel: R=\(selectRGB.red - progress * deltaRGB.red) G=\(selectRGB.green - progress * deltaRGB.green) B =\(selectRGB.blue - progress * deltaRGB.blue)");
        
        targetLabel.textColor = UIColor(r: normalRGB.red + progress * deltaRGB.red, g: normalRGB.green + progress * deltaRGB.green, b: normalRGB.blue + progress * deltaRGB.blue)
        
        print("targetLabel: R=\(normalRGB.red + progress * deltaRGB.red) G=\(normalRGB.green + progress * deltaRGB.green) B =\( normalRGB.blue + progress * deltaRGB.blue))");
        
        
        // 3.scale的调整
        if style.isScaleEnable {
            let deltaScale = style.maxScale - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.maxScale - progress * deltaScale, y: style.maxScale - progress * deltaScale)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + progress * deltaScale, y: 1.0 + progress * deltaScale)
        }
        
        // 4.bottomLine的调整
        if style.isShowBottomLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + progress * deltaX
            bottomLine.frame.size.width = sourceLabel.frame.width + progress * deltaW
        }
        
        // 5.coverView的调整
        if style.isShowCoverView {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + deltaW * progress) : (sourceLabel.frame.width + deltaW * progress)
            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + deltaX * progress) : (sourceLabel.frame.origin.x + deltaX * progress)
        }
    }
}



// MARK:- 对外提供的函数
extension KTitleView {
    func setCurrentIndex(currentIndex : Int) {
        setTargetLabel(titleLabels[currentIndex])
    }
}













