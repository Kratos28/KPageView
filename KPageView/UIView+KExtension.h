//
//  Kratos
//
//  Created by Kratos on 15/11/12.
//  Copyright (c) 2015年 Kratos. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface UIView (Extension)
/****************************************************************************/
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
/****************************************************************************/

- (BOOL)isShowOnkeyWindow;
+ (instancetype)viewFromXib;






@end
