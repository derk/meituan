//
//  HMDeal.m
//  美团
//
//  Created by apple on 14-12-04.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMDeal.h"
#import "HMBusiness.h"

@implementation HMDeal
- (NSDictionary *)objectClassInArray
{
    return @{@"businesses" : [HMBusiness class]};
}

- (NSDictionary *)replacedKeyFromPropertyName
{
    // 模型的desc属性对应着字典中的description
    return @{@"desc" : @"description"};
}

- (BOOL)isEqual:(HMDeal *)other
{
    return [self.deal_id isEqualToString:other.deal_id];
}

- (NSNumber *)dealNumber:(NSNumber *)sourceNumber
{
    NSString *str = [sourceNumber description];
    
    // 小数点的位置
    NSUInteger dotIndex = [str rangeOfString:@"."].location;
    if (dotIndex != NSNotFound && str.length - dotIndex > 2) { // 小数超过2位
        str = [str substringToIndex:dotIndex + 3];
    }
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    return [fmt numberFromString:str];
}

- (void)setList_price:(NSNumber *)list_price
{
    _list_price = [self dealNumber:list_price];
    
    
}

- (void)setCurrent_price:(NSNumber *)current_price
{
    _current_price = [self dealNumber:current_price];
}

MJCodingImplementation
@end
