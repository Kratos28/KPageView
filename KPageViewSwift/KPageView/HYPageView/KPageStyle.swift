//
//  KPageStyle.swift
//  KPageView
//
//  Created by Kratos on 17/4/8.
//  Copyright © 2017年 Kratos. All rights reserved.
//  NSObject --> KVC

import UIKit

class KPageStyle {
    
    // 是否可以滚动
    var isScrollEnable : Bool = false
    
    // Label的一些属性
    var titleHeight : CGFloat = 44
    var normalColor : UIColor = UIColor.white
    var selectColor : UIColor = UIColor.orange
    var fontSize : CGFloat = 15
    
    var titleMargin : CGFloat = 30
    
    // 是否显示滚动条
    var isShowBottomLine : Bool = false
    var bottomLineColor : UIColor = UIColor.orange
    var bottomLineHeight : CGFloat = 2
    
    // 是否需要缩放功能
    var isScaleEnable : Bool = false
    var maxScale : CGFloat = 1.2
    
    // 是否需要显示的coverView
    var isShowCoverView : Bool = false
    var coverBgColor : UIColor = UIColor.black
    var coverAlpha : CGFloat = 0.4
    var coverMargin : CGFloat = 8
    var coverHeight : CGFloat = 25
    var coverRadius : CGFloat = 12
    
    // pageControl的高度
    var pageControlHeight : CGFloat = 20
}
