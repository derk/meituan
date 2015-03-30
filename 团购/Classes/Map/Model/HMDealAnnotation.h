//
//  HMDealAnnotation.h
//  黑团HD
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class HMDeal;

@interface HMDealAnnotation : NSObject <MKAnnotation>
/**
 *  大头针的位置
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

/**
 *  这颗大头针绑定的团购模型
 */
@property (nonatomic, strong) HMDeal *deal;
@end
