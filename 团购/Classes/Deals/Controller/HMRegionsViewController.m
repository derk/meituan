//
//  HMRegionsViewController.m
//  美团
//
//  Created by apple on 14-12-03.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMRegionsViewController.h"
#import "HMDropdownMenu.h"
#import "HMCity.h"
#import "HMRegion.h"
#import "HMCitiesViewController.h"

@interface HMRegionsViewController () <HMDropdownMenuDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *mylabel;


- (IBAction)changeCity;
@property (nonatomic, weak) HMDropdownMenu *menu;
@end

@implementation HMRegionsViewController

- (HMDropdownMenu *)menu
{
    if (_menu == nil) {
        // 顶部的view
        UIView *topView = [self.view.subviews firstObject];
        
        // 创建菜单
        HMDropdownMenu *menu = [HMDropdownMenu menu];
        menu.delegate = self;
        [self.view addSubview:menu];
        // menu的ALEdgeTop == topView的ALEdgeBottom
        [menu autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topView];
        // 除开顶部，其他方向距离父控件的间距都为0
        [menu autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        self.menu = menu;
    }
    return _menu;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(400, 480);
}

- (IBAction)changeCity {
    // 1.关闭所在的popover(利用KVC可以访问任何属性和成员变量)
    UIPopoverController *popover = [self valueForKeyPath:@"popoverController"];
    [popover dismissPopoverAnimated:YES];
    
    // 2.弹出城市列表
    HMCitiesViewController *citiesVc = [[HMCitiesViewController alloc] init];
    citiesVc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:citiesVc animated:YES completion:nil];
}

#pragma mark - 公共方法
- (void)setRegions:(NSArray *)regions
{
    _regions = regions;
    
    self.menu.items = regions;
}

- (void)setSelectedRegion:(HMRegion *)selectedRegion
{
    _selectedRegion = selectedRegion;
    
    int mainRow = [self.menu.items indexOfObject:selectedRegion];
    [self.menu selectMain:mainRow];
}

- (void)setSelectedSubRegionName:(NSString *)selectedSubRegionName
{
    _selectedSubRegionName = [selectedSubRegionName copy];
    
    int subRow = [self.selectedRegion.subregions indexOfObject:selectedSubRegionName];
    [self.menu selectSub:subRow];
}

#pragma mark - HMDropdownMenuDelegate
- (void)dropdownMenu:(HMDropdownMenu *)dropdownMenu didSelectMain:(int)mainRow
{
    HMRegion *r = dropdownMenu.items[mainRow];
    if (r.subregions.count == 0) {
        // 发出通知，选中了某个区域
        [HMNotificationCenter postNotificationName:HMRegionDidSelectNotification object:nil userInfo:@{HMSelectedRegion : r}];
    } else { // 右边有子区域
        if (self.selectedRegion == r) {
            // 选中右边的子区域
            self.selectedSubRegionName = self.selectedSubRegionName;
        }
    }
}

- (void)dropdownMenu:(HMDropdownMenu *)dropdownMenu didSelectSub:(int)subRow ofMain:(int)mainRow
{
    // 发出通知，选中了某个分类
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    HMRegion *r = dropdownMenu.items[mainRow];
    userInfo[HMSelectedRegion] = r;
    userInfo[HMSelectedSubRegionName] = r.subregions[subRow];
    [HMNotificationCenter postNotificationName:HMRegionDidSelectNotification object:nil userInfo:userInfo];
}
@end
