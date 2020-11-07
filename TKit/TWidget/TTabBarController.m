//
//  TTabBarController.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#define Bar_Btn_Tag     200
#define s_Img_badge_tab @"icon_badge_tab.png"

#import "TTabBarController.h"
#import "TExt.h"

@interface TTabBarController ()
{
    float _barBtnW;
}
@property (nonatomic, strong) UIView *_selectView;

@end
@implementation TTabBarController

#pragma mark - -------- 刷新角标 ----------

- (void)flashBadgeAtIndex:(int)index isShow:(BOOL)isShow
{
    NSInteger         tag = 900 + index;
    UIImageView *tImgView = (UIImageView *)[self._tabBar viewWithTag:tag];

    if (!isShow) {
        [tImgView removeFromSuperview];
    } else if (!tImgView) {
        UIImage *tImage = [UIImage getImage:s_Img_badge_tab];
        tImgView = [[UIImageView alloc] init];
        tImgView.frame = CGRectMake(_barBtnW * index + 6, 4, tImage.width, tImage.height);
        [tImgView setImage:tImage];
        [self._tabBar addSubview:tImgView];
        [self._tabBar bringSubviewToFront:tImgView];
    }
}



#pragma mark - -------- 响应 ----------

- (void)setSelectedIndex:(NSUInteger)index
{
    // 委托事件
    if ([self._delegate respondsToSelector:@selector(canSelectBarBtn:)]) {
        BOOL canSelect = [self._delegate canSelectBarBtn:index];
        //        DLog(" ---- select barbtn :%d",index);
        if (!canSelect) {
            return;
        }
    }

    // 按钮高亮
    for (int i = 0; i < self.viewControllers.count; i++) {
        UIButton *tButton = (UIButton *)[self._tabBar viewWithTag:Bar_Btn_Tag + i];
        tButton.selected = (index == i);
        tButton.highlighted = (index == i) && (!tButton.isSelected); // 当选中时候不能再让按钮高亮,否则会有变暗的效果

        if (index == i) {
            [tButton bringToFront];
        }
    }

    if (self.selectedIndex == index) {
        return;
    }

    [super setSelectedIndex:index];

    // 滑动高亮图片
    __block TTabBarController *bSelf = self;
    [UIView animateWithDuration:0.15f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [bSelf._selectView setLeft:index * _barBtnW];
    } completion:^(BOOL finished) {}];

    // 委托事件
    if ([self._delegate respondsToSelector:@selector(didSelectBarBtn:)]) {
        [self._delegate didSelectBarBtn:index];
        //        DLog(" ---- select barbtn :%d",index);
    }
}

- (void)toucheAction:(UIButton *)button
{
    [self setSelectedIndex:[button tag] - Bar_Btn_Tag];
}

- (BasePage *)pageOfIndex:(NSInteger)index
{
    if (index >= self.viewControllers.count) {
        return nil;
    }

    BasePage    *tPage = nil;
    id          page = [self.viewControllers objectAtIndexEx:index];

    if ([page isKindOfClass:[UINavigationController class]]) {
        tPage = (BasePage *)[page topViewController];
    } else {
        tPage = (BasePage *)page;
    }

    return tPage;
}

#pragma mark - -------- 页面 ----------

+ (TTabBarController *)tabBarWithDataSource:(id <TTabBarDataSource>)dataSource
{
    TTabBarController *tTabBarPage = [[TTabBarController alloc] init];

    tTabBarPage._dataSource = dataSource;
    return tTabBarPage;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];

    // 创建自定义tabbar
    if (self._dataSource && viewControllers && (viewControllers.count > 0)) {
        [self createTabBar];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!Is_up_Ios_7) {
        self.wantsFullScreenLayout = YES;
        self.view.autoresizingMask = Autoresizing_All;
        self.view.autoresizesSubviews = YES;
    }
}

- (void)createTabBar
{
    self.tabBar.hidden = YES;

    // tabbar 高度和按钮宽度
    float tabBarH = f_TabBar_h;
    _barBtnW = f_Device_w / self.viewControllers.count;

    if ([self._dataSource respondsToSelector:@selector(heightForBottomBar)]) {
        tabBarH = [self._dataSource heightForBottomBar];
    }

    // ----- tabbar
    UIView *tView = [[UIView alloc] init];
    tView.frame = CGRectMake(0, f_Device_h - tabBarH, f_Device_w, tabBarH);
    [self.view addSubview:tView];
    self._tabBar = tView;
    [self._tabBar setBackImage:[UIImage getImage:@"tabbar_bg@2x.png"]];

    // 默认背景
//    UIImageView *tImgView = nil;
//    tImgView = [[UIImageView alloc] init];
//    tImgView.frame = CGRectMake(0, 0, self._tabBar.width, self._tabBar.height);
//    [tImgView setImage:[UIImage getImage:@"tabbar_bg@2x.png"]];
    //    [self._tabBar addSubview:tImgView];

    // ---  tabBar 选中后的高亮背景
    if ([self._dataSource respondsToSelector:@selector(selectViewForBarBtn)]) {
        UIView *tView = [self._dataSource selectViewForBarBtn];
        [tView setFrame:CGRectMake(0, 0, _barBtnW, tabBarH)];
        [self._tabBar addSubview:tView];
        self._selectView = tView;
    }

    // --- tabBar 背景图片
    if ([self._dataSource respondsToSelector:@selector(backViewForBottomBar)]) {
        UIView *tView = [self._dataSource backViewForBottomBar];
        [tView setFrame:CGRectMake(0, 0, self._tabBar.width, tabBarH)];
        [self._tabBar addSubview:tView];
    }

    // btn 之间线的宽度
    float lineWidth = 1.f;

    if ([self._dataSource respondsToSelector:@selector(lineWidthBetweenForBtn)]) {
        lineWidth = [self._dataSource lineWidthBetweenForBtn];
    }

    // --- barBtn 背景图和高亮图
    NSArray *tItems;
    float   currX = 0;

    if ([self._dataSource respondsToSelector:@selector(barBtnImgs)]) {
        tItems = [self._dataSource barBtnImgs];
    }

    for (NSInteger i = 0; i < self.viewControllers.count; i++) {
        // --- BarBtn View
        UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tButton.frame = CGRectMake(0 + _barBtnW * i, 0, _barBtnW, tabBarH);
        tButton.tag = Bar_Btn_Tag + i;

        [tButton addTarget:self action:@selector(toucheAction:) forControlEvents:UIControlEventTouchDown];
        [tButton addTarget:self action:@selector(toucheAction:) forControlEvents:UIControlEventTouchUpInside];
        [tButton addTarget:self action:@selector(toucheAction:) forControlEvents:UIControlEventTouchUpOutside];
        [tButton addTarget:self action:@selector(toucheAction:) forControlEvents:UIControlEventTouchDragOutside];
        [tButton addTarget:self action:@selector(toucheAction:) forControlEvents:UIControlEventTouchDragInside];

        [self._tabBar addSubview:tButton];

        // -----> 图片实现按钮的各个状态
        NSArray *btnImages = [tItems objectAtIndexEx:i];
        if (btnImages && (btnImages.count > 1)) {
            UIImage *tImage = [UIImage getImage:[btnImages objectAtIndexEx:0]];
            tButton.width = tImage.width;
            tButton.left = currX;
            currX += (tImage.size.width / 2.f) - lineWidth;
            tButton.adjustsImageWhenHighlighted = NO;
            [tButton setBackgroundImage:tImage forState:UIControlStateNormal];
            [tButton setBackgroundImage:[UIImage getImage:[btnImages objectAtIndexEx:1]] forState:UIControlStateSelected];
            [tButton setBackgroundImage:[UIImage getImage:[btnImages objectAtIndexEx:1]] forState:UIControlStateHighlighted];

        }

        // -----> 背景实现按钮的样式
        if ([self._dataSource respondsToSelector:@selector(backViewForBarBtn:)]) {
            UIView *tView = [self._dataSource backViewForBarBtn:i];
            [tView setFrame:CGRectMake(0, 0, _barBtnW, tabBarH)];
            [tButton addSubview:tView];
        }
        
        // -----> 自定义实现按钮的样式
        if ([self._dataSource respondsToSelector:@selector(layoutBarBtn:forIndex:)]) {
            [self._dataSource layoutBarBtn:tButton forIndex:i];
        }
    }

    [self setSelectedIndex:0];
}

@end