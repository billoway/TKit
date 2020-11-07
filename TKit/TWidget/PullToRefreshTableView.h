//
//  PullToRefreshTableView.h
//  _app
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

/*
 *   下拉刷新 及 上拖加载 表视图
 *   使用本类，您无需去关注StateView中的方法，只要调用PullToRefreshTableView中以下三种方法即可
 *
 *   - (void)tableViewDidDragging;
 *   - (int)tableViewDidEndDragging;
 *   - (void)reloadData:(BOOL)dataIsAllLoaded;
 *
 *   未对DataSource及Delegate进行任何处理，您可自定义您的数据源及委托
 */

#define k_RETURN_DO_NOTHING         0       //  返回值：不执行
#define k_RETURN_REFRESH            1       //  返回值：下拉刷新
#define k_RETURN_LOADMORE           2       //  返回值：加载更多

#define s_Up_img    @"PullToRefresh.bundle/arrow_up@2x.png"
#define s_Down_img  @"PullToRefresh.bundle/arrow_down@2x.png"

#import <UIKit/UIKit.h>

@class StateView;
/// 下拉刷新/上拖加载 表视图
@interface PullToRefreshTableView : UITableView

@property (strong, nonatomic) StateView *headerView;    //  下拉刷新视图
@property (strong, nonatomic) StateView *footerView;    //  上拖加载视图

@property (nonatomic) BOOL isHeaderHide;                // 是否隐藏顶部底部样式
@property (nonatomic) BOOL isfooterHide;                // 是否隐藏顶部底部样式

/// 当表视图拖动时的执行方法  当表视图拖动时的执行方法
- (int)tableViewDidDragging;

/// 当表视图结束拖动时的执行方法   使用方法：设置表视图的delegate，实现 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate方法，在垓方法中直接调用本方法
- (int)tableViewDidEndDragging;

/// 刷新表视图数据 dataIsAllLoaded 标识数据是否已全部加载（即“上拖加载更多”是否可用）
- (void)reloadData:(BOOL)dataIsAllLoaded;

/// 加载更多 0: 松开加载(有箭头动画)  1:位移超过范围即开始加载
+ (void)registerLoadMoreType:(int)type;

@end