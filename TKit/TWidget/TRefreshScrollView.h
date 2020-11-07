//
//  TRefreshScrollView.h
//  uApp
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Gear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDefine.h"

/********
 下拉刷新控件 ==> 用于详情页面(刷新功能可开关)
 
 TRefreshScrollView* refreshView = [[TRefreshScrollView alloc] initWithFrame:CGRectMake(0, 0, f_Device_w, f_Device_h)];
 [refreshView doRefreshBlock:^{
 // do request data
 // [refreshView doneRefresh];
 }];
 [self.view addSubview:refreshView];
 ********/
@interface TRefreshScrollView : UIScrollView

/// content scrollview
@property (nonatomic, strong) UIView *headView;
/// 是否可以刷新 默认NO
@property (nonatomic, assign) BOOL refreshEnable;

/// 刷新回调
-(void) doRefreshBlock:(VBlock)refresh;
/// 数据刷新完成调用
-(void) doneRefresh;
/// 加载子视图
-(void) addContentView:(UIView*)view;
/// 移除所有子视图
-(void) removeContentViews;

@end
