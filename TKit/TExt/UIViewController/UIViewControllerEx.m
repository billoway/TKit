//
//  UIViewControllerEx.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIViewControllerEx.h"
#import "TExt.h"


@interface CustomNavigationController : UINavigationController

@end
@implementation UIViewController (TExt)

/// 创建导航控制器
- (UINavigationController *)navWithController;
{
    CustomNavigationController *tNav = [[CustomNavigationController alloc] initWithRootViewController:self];
    
    tNav.navigationBarHidden = YES;
    tNav.wantsFullScreenLayout = YES;
    return tNav;
}

#pragma mark - -------- View2Image ----------

- (UIImage *)imageWithUIView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

- (UIView *)imageWithScreen:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    
    UIImage *tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *tImgView = [[UIImageView alloc] init];
    tImgView.frame = view.frame; // CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
    
    if (view.bounds.size.height > f_Screen_h) {
        CGRect rect = CGRectMake(0, f_StatusBar_h, f_Device_w, f_Screen_h);
        tImgView.frame = rect;
        CGImageRef imageRef = CGImageCreateWithImageInRect([tImage CGImage], rect);
        [tImgView setImage:[UIImage imageWithCGImage:imageRef]];
    } else {
        [tImgView setImage:tImage];
    }
    
    return tImgView;
}

- (UIView *)imageWithDevice  // :(UIView*) view
{
    UIView *view = self.view;
    
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    
    UIImage *tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *tImgView = [[UIImageView alloc] initWithFrame:view.frame];
    
    if (view.bounds.size.height > f_Screen_h) {
        CGRect rect = CGRectMake(0, f_StatusBar_h, f_Device_w, f_Screen_h);
        tImgView.frame = rect;
        CGImageRef imageRef = CGImageCreateWithImageInRect([tImage CGImage], rect);
        [tImgView setImage:[UIImage imageWithCGImage:imageRef]];
    } else {
        [tImgView setImage:tImage];
    }
    
    return tImgView;
}

- (UIView *)imageWithScreen
{
    return nil;
    //    // 需要先extern
    //    extern CGImageRef UIGetScreenImage();
    //
    //    CGImageRef  tImgRef = UIGetScreenImage();
    //    UIImage     *tImage = nil;
    //
    //    UIImageView *tImgView = [[UIImageView alloc] init];
    //
    //    tImgView.frame = CGRectMake(0, 0, f_Device_w, f_Screen_h);
    //
    //    CGRect      rect = CGRectMake(0, f_StatusBar_h * 2, f_Device_w * 2, f_Screen_h * 2);
    //    CGImageRef  nImgRef = CGImageCreateWithImageInRect(tImgRef, rect);
    //
    //    tImage = [UIImage imageWithCGImage:nImgRef];
    //    [tImgView setImage:tImage];
    //    CGImageRelease(tImgRef);
    //    CGImageRelease(nImgRef);
    //
    //    return tImgView;
}


#pragma mark - -------- push ext ----------
/// 导航进入
- (void)pushController:(UIViewController *)tController
{
    if (!k_Is_Empty(custom_back_title)) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:custom_back_title style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
    }
    [self.navigationController pushViewController:tController animated:YES];
}

/// 导航进入
- (void)doPush:(UIViewController *)tController
{
    [self performSelectorOnMainThread:@selector(pushController:) withObject:tController waitUntilDone:NO];
}

- (UIViewController *)popController
{
    return [self.navigationController popViewControllerAnimated:YES];
}

- (UIViewController *)popControllerFromNow:(NSInteger)index
{
    NSArray* viewControllers = self.navigationController.viewControllers;
    NSInteger currIndex = [viewControllers indexOfObject:self];
    UIViewController* targetController = [viewControllers objectAtIndexEx:currIndex-index];

    if (currIndex != NSNotFound && targetController) {
        [self.navigationController popToViewController:targetController animated:YES];
    }
    return nil;
}

- (void)popToRootController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)doPop
{
    [self performSelectorOnMainThread:@selector(popController) withObject:nil waitUntilDone:NO];
}

- (void)presentController:(UIViewController *)tController
{
    if (!Is_up_Ios_7) {
        tController.wantsFullScreenLayout = YES;
    }
    
    tController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:tController animated:YES completion:^{}];
}

- (void)dismissController
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

static NSString* custom_back_title;
static NSString* custom_cancel_title;

/// 使用系统导航栏 并且自定义返回标题 (空则不设置)
+(void) registe_custom_back_title:(NSString*)back cancel:(NSString*)cancel;
{
    if (!k_Is_Empty(back)) {
        custom_back_title = back;
    }
    if (!k_Is_Empty(cancel)) {
        custom_cancel_title = cancel;
    }
}

@end

@implementation CustomNavigationController

- (BOOL) shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return
    UIInterfaceOrientationMaskPortrait;
}

// ---- 6.0 以前翻转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return
    interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end