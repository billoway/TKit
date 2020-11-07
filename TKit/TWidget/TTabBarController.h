//
//  TTabBarController.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#define f_TabBar_h 50
#import <UIKit/UIKit.h>

@class BasePage;
@protocol TTabBarDataSource, TTabBarDelegate;
@interface TTabBarController : UITabBarController

@property (nonatomic, weak) id <TTabBarDataSource>   _dataSource;
@property (nonatomic, weak) id <TTabBarDelegate>     _delegate;
@property (nonatomic, strong) UIView                *_tabBar;

+ (TTabBarController *)tabBarWithDataSource:(id <TTabBarDataSource>)dataSource;

- (BasePage *)pageOfIndex:(NSInteger)index;
- (void)flashBadgeAtIndex:(int)index isShow:(BOOL)isShow;

@end

#pragma mark - -------- 数据源和委托 ----------

/// TabBar 数据源
@protocol TTabBarDataSource <NSObject>
@required
- (TTabBarController *)tabController;

@optional
/// 底部btn 之间线的宽度
- (float)lineWidthBetweenForBtn;
/// 底部tabBar 高度
- (float)heightForBottomBar;
/// 底部tabBar 背景
- (UIView *)backViewForBottomBar;
/// tabBar 选中后的高亮背景
- (UIView *)selectViewForBarBtn;
/// barBtn 背景
- (UIView *)backViewForBarBtn:(NSInteger)index;
/// barBtn 背景图和高亮图 背景图:index0 高亮图 index1
- (NSArray *)barBtnImgs;
/// barBtn 布局
- (void)layoutBarBtn:(UIButton*)button forIndex:(NSInteger)index;

@end

/// TabBar 委托
@protocol TTabBarDelegate <NSObject>

@optional
- (void)didSelectBarBtn:(NSInteger)index;
- (BOOL)canSelectBarBtn:(NSInteger)index;
@end