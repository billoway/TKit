//
//  TLoadingView
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//
#define s_Alert_Req_Failed  @"请求失败,请稍后再试"
#define s_Alert_More_Failed @"加载更多数据失败,请稍后再试"

#define  s_loading_bg       @"loading_bg.png"

/// 
#define  s_loading_icon1    @"loading_icon_1.png"
#define  s_loading_icon2    @"loading_icon_2.png"
#define  s_loading_icon3    @"loading_icon_3.png"
#define  s_loading_cancel   @"loading_cancel.png"

#import <UIKit/UIKit.h>
#import "TDefine.h"

// 自定义对话框
@protocol CancelRequestDelegate;
@interface TLoadingView : NSObject
SINGLETON_FOR_CLASS_HEADER(TLoadingView)

/// 加载Loading cancelBlk:取消回调 text:文字
+ (void)showLoadingWithCancel:(VBlock)cancelBlk text:(NSString *)text;
/// 加载Loading cancelBlk:取消回调
+ (void)showLoadingWithCancel:(VBlock)cancelBlk;

///  移除loading
+ (void)dissLoading;

//  加载提示语  text：提示文字    time：显示时间
+ (void)showAlert:(NSString *)text time:(float)time;
+ (void)showAlert:(NSString *)text;

/// 显示中间的提示语
- (void)showCenterAlert:(NSString *)text;

+ (void)didActive;

@end