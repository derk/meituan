//
//  HMCategoriesViewController.m
//  美团
//
//  Created by apple on 14-12-02.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMCategoriesViewController.h"
#import "HMDropdownMenu.h"
#import "HMCategory.h"

@interface HMCategoriesViewController () <HMDropdownMenuDelegate>
@property (nonatomic, weak) HMDropdownMenu *menu;
@end

@implementation HMCategoriesViewController

- (void)loadView
{
    HMDropdownMenu *menu = [HMDropdownMenu menu];
    menu.delegate = self;
    menu.items = [HMMetaDataTool sharedMetaDataTool].categories;
    self.view = menu;
    self.menu = menu;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(400, 480);
}

#pragma mark - HMDropdownMenuDelegate
- (void)dropdownMenu:(HMDropdownMenu *)dropdownMenu didSelectMain:(int)mainRow
{
    HMCategory *c = dropdownMenu.items[mainRow];
    if (c.subcategories.count == 0) {
        // 发出通知，选中了某个分类
        [HMNotificationCenter postNotificationName:HMCategoryDidSelectNotification object:nil userInfo:@{HMSelectedCategory : c}];
    } else { // 右边有子类别
        if (self.selectedCategory == c) {
            // 选中右边的子类别
            self.selectedSubCategoryName = self.selectedSubCategoryName;
        }
    }
}

- (void)dropdownMenu:(HMDropdownMenu *)dropdownMenu didSelectSub:(int)subRow ofMain:(int)mainRow
{
    // 发出通知，选中了某个分类
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    HMCategory *c = dropdownMenu.items[mainRow];
    userInfo[HMSelectedCategory] = c;
    userInfo[HMSelectedSubCategoryName] = c.subcategories[subRow];
    
    UIKeyboardAnimationCurveUserInfoKey;
    
    [HMNotificationCenter postNotificationName:HMCategoryDidSelectNotification object:nil userInfo:userInfo];
}

#pragma mark - 公共方法
- (void)setSelectedCategory:(HMCategory *)selectedCategory
{
    _selectedCategory = selectedCategory;
    
    int mainRow = [self.menu.items indexOfObject:selectedCategory];
    [self.menu selectMain:mainRow];
}

- (void)setSelectedSubCategoryName:(NSString *)selectedSubCategoryName
{
    _selectedSubCategoryName = [selectedSubCategoryName copy];
    
    int subRow = [self.selectedCategory.subcategories indexOfObject:selectedSubCategoryName];
    [self.menu selectSub:subRow];
}

@end
