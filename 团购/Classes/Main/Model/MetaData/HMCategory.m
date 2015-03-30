//
//  HMCategory.m
//  美团
//
//  Created by apple on 14-12-09.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMCategory.h"

@implementation HMCategory
- (NSString *)title
{
    return self.name;
}

- (NSArray *)subtitles
{
    return self.subcategories;
}

- (NSString *)image
{
    return self.small_icon;
}

- (NSString *)highlightedImage
{
    return self.small_highlighted_icon;
}
MJCodingImplementation
@end
