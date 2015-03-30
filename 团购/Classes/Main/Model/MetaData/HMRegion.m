//
//  HMRegion.m
//  美团
//
//  Created by apple on 14-12-10.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMRegion.h"

@implementation HMRegion
- (NSString *)title
{
    return self.name;
}

- (NSArray *)subtitles
{
    return self.subregions;
}

MJCodingImplementation
@end
