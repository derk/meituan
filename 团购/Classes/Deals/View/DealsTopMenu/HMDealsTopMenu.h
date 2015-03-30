//
//  HMDealsTopMenu.h
//  团购
//
//  Created by apple on 14-11-30.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDealsTopMenu : UIView
+ (instancetype)menu;

- (void)addTarget:(id)target action:(SEL)action;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@end
