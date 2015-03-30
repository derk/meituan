//
//  HMCitiesViewController.m
//  美团
//
//  Created by apple on 14-12-04.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMCitiesViewController.h"
#import "HMCityGroup.h"
#import "HMCitySearchViewController.h"

@interface HMCitiesViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
- (IBAction)coverClick;
@property (weak, nonatomic) IBOutlet UIButton *cover;
- (IBAction)close;
/** 导航栏顶部的间距约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarTopLc;
/** 城市组数据 */
@property (strong, nonatomic) NSArray *cityGroups;
/** 城市搜索结果界面 */
@property (nonatomic, weak) HMCitySearchViewController *citySearchVc;
@end

@implementation HMCitiesViewController

#pragma mark - 懒加载
- (HMCitySearchViewController *)citySearchVc
{
    if (_citySearchVc == nil) {
        HMCitySearchViewController *citySearchVc = [[HMCitySearchViewController alloc] init];
        [self addChildViewController:citySearchVc];
        self.citySearchVc = citySearchVc;
    }
    return _citySearchVc;
}

- (NSArray *)cityGroups
{
    if (!_cityGroups) {
        self.cityGroups = [HMMetaDataTool sharedMetaDataTool].cityGroups;
    }
    return _cityGroups;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate
/** 搜索框结束编辑（退出键盘） */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 如果正在dissmis，就不要执行后面代码
    if (self.isBeingDismissed) return;
    
    // 更换背景
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    // 隐藏取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    // 让整体向下挪动
    self.navBarTopLc.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        // 让约束执行动画
        [self.view layoutIfNeeded];
        // 让遮盖慢慢消失
        self.cover.alpha = 0.0;
    }];
    
    // 清空文字
    searchBar.text = nil;
    // 移除城市搜索结果界面
    [self.citySearchVc.view removeFromSuperview];
}

/** 搜索框开始编辑（弹出键盘） */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 更换背景
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    // 显示取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    // 让整体向上挪动
    self.navBarTopLc.constant = -62;
    [UIView animateWithDuration:0.25 animations:^{
        // 让约束执行动画
        [self.view layoutIfNeeded];
        // 让遮盖慢慢出来
        self.cover.alpha = 0.6;
    }];
}

/** 点击了取消 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

/** 搜索框的文字发生改变的时候调用 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.citySearchVc.view removeFromSuperview];
    if (searchText.length > 0) {
        [self.view addSubview:self.citySearchVc.view];
        
        [self.citySearchVc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.citySearchVc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:searchBar];
        
        // 传递搜索条件
        self.citySearchVc.searchText = searchText;
    }
}

#pragma mark - 让控制器在formSheet情况下也能正常退出键盘
- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}
- (IBAction)coverClick {
    [self.view endEditing:YES];
}

#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HMCityGroup *group = self.cityGroups[section];
    return group.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    HMCityGroup *group = self.cityGroups[indexPath.section];
    cell.textLabel.text = group.cities[indexPath.row];
    return cell;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    HMCityGroup *group = self.cityGroups[section];
    return group.title;
}

// Shift + Control + 单击 == 查看在xib\storyboard中重叠的所有UI控件
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    // 将cityGroups数组中所有元素的title属性值取出来，放到一个新的数组
    return [self.cityGroups valueForKeyPath:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.关闭控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 2.发出通知
    HMCityGroup *group = self.cityGroups[indexPath.section];
    NSString *cityName = group.cities[indexPath.row];
    HMCity *city = [[HMMetaDataTool sharedMetaDataTool] cityWithName:cityName];
    [HMNotificationCenter postNotificationName:HMCityDidSelectNotification object:nil userInfo:@{HMSelectedCity : city}];
}
@end
