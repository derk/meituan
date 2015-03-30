//
//  HMDealTool.m
//  美团
//
//  Created by apple on 14-12-11.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMDealTool.h"
#import "HMAPITool.h"

@implementation HMDealTool
+ (void)findDeals:(HMFindDealsParam *)param success:(void (^)(HMFindDealsResult *))success failure:(void (^)(NSError *))failure
{
    [[HMAPITool sharedAPITool] request:@"v1/deal/find_deals" params:param.keyValues success:^(id json) {
        if (success) {
            HMFindDealsResult *obj = [HMFindDealsResult objectWithKeyValues:json];
            success(obj);
        }
    } failure:failure];
}


+ (void)getSingleDeal:(HMGetSingleDealParam *)param success:(void (^)(HMGetSingleDealResult *result))success failure:(void (^)(NSError *error))failure
{
    [[HMAPITool sharedAPITool] request:@"v1/deal/get_single_deal" params:param.keyValues success:^(id json) {
        if (success) {
            HMGetSingleDealResult *obj = [HMGetSingleDealResult objectWithKeyValues:json];
            success(obj);
        }
    } failure:failure];
}
@end
