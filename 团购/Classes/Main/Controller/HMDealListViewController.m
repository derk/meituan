//
//  HMDealListViewController.m
//  美团
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMDealListViewController.h"
#import "HMDealCell.h"
#import "HMDealDetailViewController.h"
#import "HMEmptyView.h"

@interface HMDealListViewController () <HMDealCellDelegate>
/** 没有数据时显示的view */
@property (nonatomic, weak) HMEmptyView *emptyView;
@end

@implementation HMDealListViewController
#pragma mark - 懒加载
- (NSMutableArray *)deals
{
    if (_deals == nil) {
        self.deals = [NSMutableArray array];
    }
    return _deals;
}

- (HMEmptyView *)emptyView
{
    if (_emptyView == nil) {
        HMEmptyView *emptyView = [HMEmptyView emptyView];
        emptyView.image = [UIImage imageNamed:self.emptyIcon];
        [self.view insertSubview:emptyView belowSubview:self.collectionView];
        self.emptyView = emptyView;
    }
    return _emptyView;
}

#pragma mark - 初始化
- (id)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // cell的尺寸
    layout.itemSize = CGSizeMake(305, 305);
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBaseView];
}

/**
 *  设置控制器view属性
 */
- (void)setupBaseView
{
    // 设置颜色
//    if (night_mode) {
//        self.collectionView.backgroundColor = [UIColor blackColor];
//    } else {
//        self.collectionView.backgroundColor = [UIColor clearColor];
//    }
//    self.collectionView.backgroundColor = [HMColorTool colorWithKey:@"HMCollectionViewBg"];
//    
//    UIImageView *imageView;
//    imageView.image = [HMImageTool imageWithName:@"add"];
    
    UILabel *label;
    
    label.text = [HMStringTool stringWithKey:@"hello"];
    
    
    // 垂直方向上永远有弹簧效果
    self.collectionView.alwaysBounceVertical = YES;
    self.view.backgroundColor = HMGlobalBg;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HMDealCell" bundle:nil] forCellWithReuseIdentifier:@"deal"];
}

#pragma mark - 应该要在：即将显示view的时候，根据屏幕方向调整cell的间距
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:self.view.width orientation:self.interfaceOrientation];
}

#pragma mark - 处理屏幕的旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
#warning 这里要注意：由于是即将旋转，最后的宽度就是现在的高度
    // 总宽度
    CGFloat totalWidth = self.view.height;
    [self setupLayout:totalWidth orientation:toInterfaceOrientation];
}

/**
 *  调整布局
 *
 *  @param totalWidth 总宽度
 *  @param orientation 显示的方向
 */
- (void)setupLayout:(CGFloat)totalWidth orientation:(UIInterfaceOrientation)orientation
{
    // 总列数
    int columns = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    // 每一行的最小间距
    CGFloat lineSpacing = 25;
    // 每一列的最小间距
    CGFloat interitemSpacing = (totalWidth - columns * layout.itemSize.width) / (columns + 1);
    
    layout.minimumInteritemSpacing = interitemSpacing;
    layout.minimumLineSpacing = lineSpacing;
    // 设置cell与CollectionView边缘的间距
    layout.sectionInset = UIEdgeInsetsMake(lineSpacing, interitemSpacing, lineSpacing, interitemSpacing);
}

#pragma mark - 数据源方法
#warning 如果要在数据个数发生的改变时做出响应，那么响应操作可以考虑在数据源方法中实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
#warning 控制emptyView的可见性
    self.emptyView.hidden = (self.deals.count > 0);
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"deal" forIndexPath:indexPath];
    cell.delegate = self;
    cell.deal = self.deals[indexPath.item];
    return cell;
}

#pragma mark - 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 弹出详情控制器
    HMDealDetailViewController *detailVc = [[HMDealDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}
@end
