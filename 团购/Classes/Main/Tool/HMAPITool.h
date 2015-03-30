//
//  HMAPITool.h
//  美团
//
//  Created by apple on 14-12-10.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSingleton.h"

@interface HMAPITool : NSObject
- (void)request:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

HMSingletonH(APITool)
@end
