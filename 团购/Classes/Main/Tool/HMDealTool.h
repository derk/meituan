//
//  HMDealTool.h
//  美团
//
//  Created by apple on 14-12-11.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMFindDealsParam.h"
#import "HMFindDealsResult.h"
#import "HMGetSingleDealParam.h"
#import "HMGetSingleDealResult.h"

@interface HMDealTool : NSObject

/**
 *  搜索团购
 *
 *  @param param   请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)findDeals:(HMFindDealsParam *)param success:(void (^)(HMFindDealsResult *result))success failure:(void (^)(NSError *error))failure;


/**
 *  获得指定团购（获得单个团购信息）
 */
+ (void)getSingleDeal:(HMGetSingleDealParam *)param success:(void (^)(HMGetSingleDealResult *result))success failure:(void (^)(NSError *error))failure;


@end
