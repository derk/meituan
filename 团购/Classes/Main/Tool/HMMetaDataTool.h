//
//  HMMetaDataTool.h
//  美团
//
//  Created by apple on 14-12-11.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSingleton.h"
@class HMCity, HMSort, HMCategory;

@interface HMMetaDataTool : NSObject
HMSingletonH(MetaDataTool)
/**
 *  所有的分类
 */
@property (strong, nonatomic, readonly) NSArray *categories;
/**
 *  所有的城市
 */
@property (strong, nonatomic, readonly) NSArray *cities;
/**
 *  所有的城市组
 */
@property (strong, nonatomic, readonly) NSArray *cityGroups;
/**
 *  所有的排序
 */
@property (strong, nonatomic, readonly) NSArray *sorts;

/**
 *  通过分类名称（子分类名称）获得对应的分类模型
 */
- (HMCategory * )categoryWithName:(NSString *)name;

- (HMCity *)cityWithName:(NSString *)name;

/**
 *  存储选中的城市名称
 */
- (void)saveSelectedCityName:(NSString *)name;
///**
// *  存储选中的区域
// */
//- (void)saveSelectedRegion:(hm *)name;
///**
// *  存储选中的子区域名字
// */
//- (void)saveSelectedCityName:(NSString *)name;
///**
// *  存储选中的分类
// */
//- (void)saveSelectedCityName:(NSString *)name;
///**
// *  存储选中的子分类名字
// */
//- (void)saveSelectedCityName:(NSString *)name;
/**
 *  存储选中的排序
 */
- (void)saveSelectedSort:(HMSort *)sort;

- (HMCity *)selectedCity;
- (HMSort *)selectedSort;
@end
