//
//  HMEmptyView.m
//  美团
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMEmptyView.h"

@implementation HMEmptyView

+ (instancetype)emptyView
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeCenter;
    }
    return self;
}

/**
 *  当一个控件被添加到父控件或者从父控件移除会调用（一旦从父控件中移除，self.superview是nil）
 */
- (void)didMoveToSuperview
{
#warning 如果父控件不为nil，才需要添加约束
    if (self.superview) {
        // 填充整个父控件
        [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
}

@end
