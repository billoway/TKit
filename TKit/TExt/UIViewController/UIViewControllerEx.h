//
//  UIViewControllerEx.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#pragma mark - -------- UIViewController ----------

@interface UIViewController (TExt)

/// 创建导航控制器
- (UINavigationController *)navWithController;

- (UIImage *)imageWithUIView:(UIView *)view;
- (UIView *)imageWithScreen:(UIView *)view;
- (UIView *)imageWithDevice;
//- (UIView *)imageWithScreen;


/// 导航推入
- (void)pushController:(UIViewController *)tController;
/// 导航推出
- (UIViewController *)popController;
/// 导航推出 : 从当前计算的个数
- (UIViewController *)popControllerFromNow:(NSInteger)index;

/// 导航返回根控制器
- (void)popToRootController;
/// 弹上去页面
- (void)presentController:(UIViewController *)tController;
/// 页面弹下来
- (void)dismissController;

/// 使用系统导航栏 并且自定义返回标题 (空则不设置)
+(void) registe_custom_back_title:(NSString*)back cancel:(NSString*)cancel;

@end
