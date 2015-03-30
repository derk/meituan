//
//  HMGetSingleDealResult.h
//  美团
//
//  Created by apple on 14-12-09.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGetSingleDealResult : NSObject
/** 本次API访问所获取的单页团购数量 */
@property (assign, nonatomic) int count;
/** 所有的团购 */
@property (strong, nonatomic) NSArray *deals;
@end
