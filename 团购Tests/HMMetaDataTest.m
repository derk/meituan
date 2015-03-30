//
//  HMMetaDataTest.m
//  美团Test
//
//  Created by apple on 14-12-11.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HMMetaDataTool.h"
#import "HMCategory.h"
#import "HMCity.h"
#import "HMCityGroup.h"
#import "HMSort.h"

@interface HMMetaDataTest : XCTestCase

@end

@implementation HMMetaDataTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testLoadMetaData
{
//    单元测试
    HMMetaDataTool *tool = [HMMetaDataTool sharedMetaDataTool];
//    XCTAssert(tool.categories.count > 0, @"分类数据加载失败");
//    XCTAssert(tool.cities.count > 0, @"城市数据加载失败");
//    XCTAssert(tool.cityGroups.count > 0, @"城市组数据加载失败");
//    XCTAssert(tool.sorts.count > 0, @"排序数据加载失败");
    
//    XCTAssert([[tool.categories firstObject] isKindOfClass:[HMCategory class]], @"分类数据内容错误");
    
    for (HMCategory *c in tool.categories) {
        NSLog(@"%@ %@", c.name, c.subcategories);
    }
}

@end
