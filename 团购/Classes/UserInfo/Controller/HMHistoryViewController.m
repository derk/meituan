//
//  HMHistoryViewController.m
//  团购
//
//  Created by apple on 14-11-29.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMHistoryViewController.h"
#import "HMDealLocalTool.h"
#import "HMDeal.h"

@interface HMHistoryViewController ()

@end

@implementation HMHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"浏览记录";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 刷新数据（保持顺序）
    [self.deals removeAllObjects];
    NSArray *historyDeals = [HMDealLocalTool sharedDealLocalTool].historyDeals;
    [self.deals addObjectsFromArray:historyDeals];
    [self.collectionView reloadData];
}

#pragma mark - 实现父类方法
- (NSString *)emptyIcon
{
    return @"icon_latestBrowse_empty";
}

/**
 *  删除
 */
- (void)delete
{
    [[HMDealLocalTool sharedDealLocalTool] unsaveHistoryDeals:self.willDeletedDeals];
}
@end
