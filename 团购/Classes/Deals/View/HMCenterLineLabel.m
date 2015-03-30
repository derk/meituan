//
//  HMCenterLineLabel.m
//  团购
//
//  Created by apple on 14-12-01
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMCenterLineLabel.h"

@implementation HMCenterLineLabel
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 设置绘图颜色
    [self.textColor set];
    
    // 矩形框的值
    CGFloat x = 0;
    CGFloat y = self.height * 0.5;
    CGFloat w = self.width;
    CGFloat h = 0.5;
    UIRectFill(CGRectMake(x, y, w, h));
}
@end
