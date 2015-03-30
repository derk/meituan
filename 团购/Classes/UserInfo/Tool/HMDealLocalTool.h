//
//  HMDealLocalTool.h
//  团购
//
//  Created by apple on 14-11-28.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSingleton.h"

@class HMDeal;

@interface HMDealLocalTool : NSObject
HMSingletonH(DealLocalTool)

/**
 *  返回最近浏览的团购
 */
@property (nonatomic, strong, readonly) NSMutableArray *historyDeals;

/**
 *  保存最近浏览的团购
 */
- (void)saveHistoryDeal:(HMDeal *)deal;
- (void)unsaveHistoryDeal:(HMDeal *)deal;
- (void)unsaveHistoryDeals:(NSArray *)deals;

/**
 *  返回收藏的团购
 */
@property (nonatomic, strong, readonly) NSMutableArray *collectDeals;

/**
 *  保存收藏的团购
 */
- (void)saveCollectDeal:(HMDeal *)deal;
/**
 *  取消收藏的团购
 */
- (void)unsaveCollectDeal:(HMDeal *)deal;
- (void)unsaveCollectDeals:(NSArray *)deals;
@end
