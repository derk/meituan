//
//  HMDealsViewController.m
//  美团
//
//  Created by apple on 14-12-02.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMDealsViewController.h"
#import "AwesomeMenu.h"
#import "AwesomeMenuItem.h"
#import "UIBarButtonItem+Extension.h"
#import "HMDealsTopMenu.h"
#import "HMCategoriesViewController.h"
#import "HMRegionsViewController.h"
#import "HMSortsViewController.h"
#import "HMCity.h"
#import "HMSort.h"
#import "HMRegion.h"
#import "HMCategory.h"
#import "HMDealTool.h"
#import "MJRefresh.h"
#import "HMHistoryViewController.h"
#import "HMNavigationController.h"
#import "HMCollectViewController.h"
#import "HMSearchViewController.h"
#import "HMMapViewController.h"

@interface HMDealsViewController () <AwesomeMenuDelegate>
/** 顶部菜单 */
/** 分类菜单 */
@property (weak, nonatomic) HMDealsTopMenu *categoryMenu;
/** 区域菜单 */
@property (weak, nonatomic) HMDealsTopMenu *regionMenu;
/** 排序菜单 */
@property (weak, nonatomic) HMDealsTopMenu *sortMenu;

/** 点击顶部菜单后弹出的Popover */
/** 分类Popover */
@property (strong, nonatomic) UIPopoverController *categoryPopover;
/** 区域Popover */
@property (strong, nonatomic) UIPopoverController *regionPopover;
/** 排序Popover */
@property (strong, nonatomic) UIPopoverController *sortPopover;

/** 选中的状态 */
@property (nonatomic, strong) HMCity *selectedCity;
/** 当前选中的区域 */
@property (strong, nonatomic) HMRegion *selectedRegion;
/** 当前选中的子区域名称 */
@property (copy, nonatomic) NSString *selectedSubRegionName;
/** 当前选中的排序 */
@property (strong, nonatomic) HMSort *selectedSort;
/** 当前选中的分类 */
@property (strong, nonatomic) HMCategory *selectedCategory;
/** 当前选中的子分类名称 */
@property (copy, nonatomic) NSString *selectedSubCategoryName;

/** 请求参数 */
@property (nonatomic, strong) HMFindDealsParam *lastParam;
/**
 *  存储请求结果的总数
 */
@property (nonatomic, assign) int totalNumber;
@end

@implementation HMDealsViewController

#pragma mark - 懒加载
- (UIPopoverController *)categoryPopover
{
    if (_categoryPopover == nil) {
        HMCategoriesViewController *cv = [[HMCategoriesViewController alloc] init];
        self.categoryPopover = [[UIPopoverController alloc] initWithContentViewController:cv];
    }
    return _categoryPopover;
}

- (UIPopoverController *)regionPopover
{
    if (!_regionPopover) {
        HMRegionsViewController *rv = [[HMRegionsViewController alloc] init];
        self.regionPopover = [[UIPopoverController alloc] initWithContentViewController:rv];
    }
    return _regionPopover;
}

- (UIPopoverController *)sortPopover
{
    if (!_sortPopover) {
        HMSortsViewController *sv = [[HMSortsViewController alloc] init];
        self.sortPopover = [[UIPopoverController alloc] initWithContentViewController:sv];
    }
    return _sortPopover;
}

#pragma mark - 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedCity = [HMMetaDataTool sharedMetaDataTool].selectedCity;
    HMRegionsViewController *rs = (HMRegionsViewController *)self.regionPopover.contentViewController;
    rs.regions = self.selectedCity.regions;
    self.selectedSort = [HMMetaDataTool sharedMetaDataTool].selectedSort;
    
    // 设置导航栏左边的内容
    [self setupNavLeft];
    
    // 设置导航栏右边的内容
    [self setupNavRight];
    
    // 用户菜单
    [self setupUserMenu];
    
    // 集成刷新控件
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];
    [self.collectionView headerBeginRefreshing];
    
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
}

#pragma mark - 通知处理
/** 监听通知 */
- (void)setupNotifications
{
    HMAddObsver(cityDidSelect:, HMCityDidSelectNotification);
    HMAddObsver(sortDidSelect:, HMSortDidSelectNotification);
    HMAddObsver(categoryDidSelect:, HMCategoryDidSelectNotification);
    HMAddObsver(regionDidSelect:, HMRegionDidSelectNotification);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    HMRemoveObsver;
}

- (void)regionDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.selectedRegion = note.userInfo[HMSelectedRegion];
    self.selectedSubRegionName = note.userInfo[HMSelectedSubRegionName];
    
    // 设置菜单数据
    self.regionMenu.titleLabel.text = [NSString stringWithFormat:@"%@ - %@", self.selectedCity.name, self.selectedRegion.name];
    self.regionMenu.subtitleLabel.text = self.selectedSubRegionName;
    
    // 关闭popover
    [self.regionPopover dismissPopoverAnimated:YES];
    
    // 加载最新的数据
    [self.collectionView headerBeginRefreshing];
}

- (void)categoryDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.selectedCategory = note.userInfo[HMSelectedCategory];
    self.selectedSubCategoryName = note.userInfo[HMSelectedSubCategoryName];
    
    // 设置菜单数据
    self.categoryMenu.imageButton.image = self.selectedCategory.icon;
    self.categoryMenu.imageButton.highlightedImage = self.selectedCategory.highlighted_icon;
    self.categoryMenu.titleLabel.text = self.selectedCategory.name;
    self.categoryMenu.subtitleLabel.text = self.selectedSubCategoryName;
    
    // 关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // 加载最新的数据
    [self.collectionView headerBeginRefreshing];
}

- (void)cityDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.selectedCity = note.userInfo[HMSelectedCity];
    self.selectedRegion = [self.selectedCity.regions firstObject];
    
    self.regionMenu.titleLabel.text = [NSString stringWithFormat:@"%@ - 全部", self.selectedCity.name];
    self.regionMenu.subtitleLabel.text = nil;
    
    // 更换显示的区域数据
    HMRegionsViewController *regionsVc = (HMRegionsViewController *)self.regionPopover.contentViewController;
    regionsVc.regions = self.selectedCity.regions;
    
    // 加载最新的数据
    [self.collectionView headerBeginRefreshing];
    
    // 存储用户的选择到沙盒
    [[HMMetaDataTool sharedMetaDataTool] saveSelectedCityName:self.selectedCity.name];
}

- (void)sortDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.selectedSort = note.userInfo[HMSelectedSort];
    
    self.sortMenu.subtitleLabel.text = self.selectedSort.label;
    
    // 销毁popover
    [self.sortPopover dismissPopoverAnimated:YES];
    
    // 加载最新的数据
    [self.collectionView headerBeginRefreshing];
    
    // 存储用户的选择到沙盒
    [[HMMetaDataTool sharedMetaDataTool] saveSelectedSort:self.selectedSort];
}

#pragma mark - 刷新数据
/**
 *  封装请求参数
 */
- (HMFindDealsParam *)buildParam
{
    HMFindDealsParam *param = [[HMFindDealsParam alloc] init];
    // 城市名称
    param.city = self.selectedCity.name;
    // 排序
    if (self.selectedSort) {
        param.sort = @(self.selectedSort.value);
    }
    // 除开“全部分类”和“全部”以外的所有词语都可以发
    // 分类
    if (self.selectedCategory && ![self.selectedCategory.name isEqualToString:@"全部分类"]) {
        if (self.selectedSubCategoryName && ![self.selectedSubCategoryName isEqualToString:@"全部"]) {
            param.category = self.selectedSubCategoryName;
        } else {
            param.category = self.selectedCategory.name;
        }
    }
    // 区域
    if (self.selectedRegion && ![self.selectedRegion.name isEqualToString:@"全部"]) {
        if (self.selectedSubRegionName && ![self.selectedSubRegionName isEqualToString:@"全部"]) {
            param.region = self.selectedSubRegionName;
        } else {
            param.region = self.selectedRegion.name;
        }
    }
    param.page = @1;
//    param.limit = @(3);
    return param;
}

- (void)loadNewDeals
{
    // 1.创建请求参数
    HMFindDealsParam *param = [self buildParam];
    
    // 2.加载数据
    [HMDealTool findDeals:param success:^(HMFindDealsResult *result) {
        // 结束刷新
        [self.collectionView headerEndRefreshing];
        
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        
        // 记录总数
        self.totalNumber = result.total_count;
        
        // 清空之前的所有数据
        [self.deals removeAllObjects];
        // 添加新的数据
        [self.deals addObjectsFromArray:result.deals];
        // 刷新表格
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.collectionView headerEndRefreshing];
        
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
    }];
    
    // 3.保存请求参数
    self.lastParam = param;
}

- (void)loadMoreDeals
{
    // 1.创建请求参数
    HMFindDealsParam *param = [self buildParam];
    // 页码
    param.page = @(self.lastParam.page.intValue + 1);
    
    // 2.加载数据
    [HMDealTool findDeals:param success:^(HMFindDealsResult *result) {
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        
        // 添加新的数据
        [self.deals addObjectsFromArray:result.deals];
        // 刷新表格
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        // 回滚页码
        param.page = @(param.page.intValue - 1);
        
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
    }];
    
    // 3.设置请求参数
    self.lastParam = param;
}

#pragma mark - 设置导航栏
/**
 *  设置导航栏左边的内容
 */
- (void)setupNavLeft
{
    // 1.LOGO
    UIBarButtonItem *logoItem = [UIBarButtonItem itemWithImageName:@"icon_meituan_logo" highImageName:@"icon_meituan_logo" target:nil action:nil];
    logoItem.customView.userInteractionEnabled = NO;
    
    // 2.分类
    HMDealsTopMenu *categoryMenu = [HMDealsTopMenu menu];
    [categoryMenu addTarget:self action:@selector(categoryMenuClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryMenu];
    self.categoryMenu = categoryMenu;
    
    // 3.区域
    HMDealsTopMenu *regionMenu = [HMDealsTopMenu menu];
    regionMenu.imageButton.image = @"icon_district";
    regionMenu.imageButton.highlightedImage = @"icon_district_highlighted";
    regionMenu.titleLabel.text = [NSString stringWithFormat:@"%@ - 全部", self.selectedCity.name];
    [regionMenu addTarget:self action:@selector(regionMenuClick)];
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc] initWithCustomView:regionMenu];
    self.regionMenu = regionMenu;
    
    // 4.排序
    HMDealsTopMenu *sortMenu = [HMDealsTopMenu menu];
    [sortMenu addTarget:self action:@selector(sortMenuClick)];
    sortMenu.imageButton.image = @"icon_sort";
    sortMenu.imageButton.highlightedImage = @"icon_sort_highlighted";
    sortMenu.titleLabel.text = @"排序";
    sortMenu.subtitleLabel.text = self.selectedSort.label;
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortMenu];
    self.sortMenu = sortMenu;
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, regionItem, sortItem];
}

/**
 *  设置导航栏右边的内容
 */
- (void)setupNavRight
{
    // 1.地图
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithImageName:@"icon_map" highImageName:@"icon_map_highlighted" target:self action:@selector(mapClick)];
    mapItem.customView.width = 50;
    mapItem.customView.height = 27;
    
    // 2.搜索
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImageName:@"icon_search" highImageName:@"icon_search_highlighted" target:self action:@selector(searchClick)];
    searchItem.customView.width = mapItem.customView.width;
    searchItem.customView.height = mapItem.customView.height;
    
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}

#pragma mark - 导航栏左边处理
/** 分类菜单 */
- (void)categoryMenuClick
{
    HMCategoriesViewController *cs = (HMCategoriesViewController *)self.categoryPopover.contentViewController;
    cs.selectedCategory = self.selectedCategory;
    cs.selectedSubCategoryName = self.selectedSubCategoryName;
    [self.categoryPopover presentPopoverFromRect:self.categoryMenu.bounds inView:self.categoryMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

/** 区域菜单 */
- (void)regionMenuClick
{
    HMRegionsViewController *rs = (HMRegionsViewController *)self.regionPopover.contentViewController;
    rs.selectedRegion = self.selectedRegion;
    rs.selectedSubRegionName = self.selectedSubRegionName;
    [self.regionPopover presentPopoverFromRect:self.regionMenu.bounds inView:self.regionMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

/** 排序菜单 */
- (void)sortMenuClick
{
    HMSortsViewController *os = (HMSortsViewController *)self.sortPopover.contentViewController;
    os.selectedSort = self.selectedSort;
    [self.sortPopover presentPopoverFromRect:self.sortMenu.bounds inView:self.sortMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - 导航栏右边处理
/** 搜索 */
- (void)searchClick
{
    HMSearchViewController *searchVc = [[HMSearchViewController alloc] init];
    searchVc.selectedCity = self.selectedCity;
    HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:searchVc];
    [self presentViewController:nav animated:YES completion:nil];
}

/** 地图 */
- (void)mapClick
{
    HMMapViewController *searchVc = [[HMMapViewController alloc] init];
    HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:searchVc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Path菜单
/**
 *  创建一个Path菜单item
 */
- (AwesomeMenuItem *)itemWithContent:(NSString *)content highlightedContent:(NSString *)highlightedContent
{
    UIImage *itemBg = [UIImage imageNamed:@"bg_pathMenu_black_normal"];
    return [[AwesomeMenuItem alloc] initWithImage:itemBg
                                                      highlightedImage:nil
                                                          ContentImage:[UIImage imageNamed:content]
                                               highlightedContentImage:[UIImage imageNamed:highlightedContent]];
}

/**
 *  用户菜单
 */
- (void)setupUserMenu
{
    // 1.周边的item
    AwesomeMenuItem *mineItem = [self itemWithContent:@"icon_pathMenu_mine_normal" highlightedContent:@"icon_pathMenu_mine_highlighted"];
    AwesomeMenuItem *collectItem = [self itemWithContent:@"icon_pathMenu_collect_normal" highlightedContent:@"icon_pathMenu_collect_highlighted"];
    AwesomeMenuItem *scanItem = [self itemWithContent:@"icon_pathMenu_scan_normal" highlightedContent:@"icon_pathMenu_scan_highlighted"];
    AwesomeMenuItem *moreItem = [self itemWithContent:@"icon_pathMenu_more_normal" highlightedContent:@"icon_pathMenu_more_highlighted"];
    NSArray *items = @[mineItem, collectItem, scanItem, moreItem];
    
    // 2.中间的开始tiem
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"]
                                                       highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"]
                                                           ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem optionMenus:items];
    [self.view addSubview:menu];
    // 真个菜单的活动范围
    menu.menuWholeAngle = M_PI_2;
    // 约束
    CGFloat menuH = 200;
    [menu autoSetDimensionsToSize:CGSizeMake(200, menuH)];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    // 3.添加一个背景
    UIImageView *menuBg = [[UIImageView alloc] init];
    menuBg.image = [UIImage imageNamed:@"icon_pathMenu_background"];
    [menu insertSubview:menuBg atIndex:0];
    // 约束
    [menuBg autoSetDimensionsToSize:menuBg.image.size];
    [menuBg autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menuBg autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    // 起点
    menu.startPoint = CGPointMake(menuBg.image.size.width * 0.5, menuH - menuBg.image.size.height * 0.5);
    // 禁止中间按钮旋转
    menu.rotateAddButton = NO;
    
    // 设置代理
    menu.delegate = self;
    
    // 设置透明度
    menu.alpha = 0.1;
}

#pragma mark - 菜单代理
- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    // 恢复图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    
    // 透明度变为0.1
    [UIView animateWithDuration:0.5 animations:^{
        menu.alpha = 0.1;
    }];
}

- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    // 显示xx图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
    
    // 透明度变为1
    [UIView animateWithDuration:0.5 animations:^{
        menu.alpha = 1.0;
    }];
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    [self awesomeMenuWillAnimateClose:menu];
    
    if (idx == 1) { // 收藏
        HMCollectViewController *historyVc = [[HMCollectViewController alloc] init];
        HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:historyVc];
        [self presentViewController:nav animated:YES completion:nil];
    } else if (idx == 2) { // 浏览记录
        HMHistoryViewController *historyVc = [[HMHistoryViewController alloc] init];
        HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:historyVc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 尾部控件的可见性
    self.collectionView.footerHidden = (self.deals.count == self.totalNumber);
    return [super collectionView:collectionView numberOfItemsInSection:section];
}

#pragma mark - 实现父类方法
- (NSString *)emptyIcon
{
    return @"icon_deals_empty";
}
@end