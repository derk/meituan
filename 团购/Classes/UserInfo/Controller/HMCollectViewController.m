//
//  HMCollectViewController.m
//  团购
//
//  Created by apple on 14-11-29.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMCollectViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HMDealLocalTool.h"
#import "HMDeal.h"

@interface HMCollectViewController ()

@end

@implementation HMCollectViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的收藏";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 刷新数据（保持顺序）
    [self.deals removeAllObjects];
    NSArray *collectDeals = [HMDealLocalTool sharedDealLocalTool].collectDeals;
    [self.deals addObjectsFromArray:collectDeals];
    [self.collectionView reloadData];
}

#pragma mark - 实现父类方法
- (NSString *)emptyIcon
{
    return @"icon_collects_empty";
}

/**
 *  删除
 */
- (void)delete
{
    [[HMDealLocalTool sharedDealLocalTool] unsaveCollectDeals:self.willDeletedDeals];
}
@end
