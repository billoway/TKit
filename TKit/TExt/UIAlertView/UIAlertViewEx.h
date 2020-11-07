//
//  UIAlertViewEx
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertBlock)(NSInteger index);

#pragma mark - -------- showAlert ----------

@interface NSObject (showAlert)

///  弹出框方法 click:回调 btns:按钮
- (void)showAlert:(NSString *)msg btns:(id)btns click:(AlertBlock)click;

///  弹出框方法 click:回调 btns:按钮
- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg btns:(id)btns click:(AlertBlock)click;

///  弹出框方法 click:回调 cancel:左边 done:右边
- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg done:(NSString *)done cancel:(NSString *)cancel click:(AlertBlock)click;

///  弹出框方法 click:回调 cancel:左边 done:右边
- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg done:(NSString *)done cancel:(NSString *)cancel after:(float)after click:(AlertBlock)click;

///  弹出框方法 click:回调 cancel:左边 done:右边
- (void)showAlert:(NSString *)msg done:(NSString *)done cancel:(NSString *)cancel click:(AlertBlock)click;

///  弹出框方法 click:回调 cancel:左边 done:右边 after:等待一段时间后弹出
- (void)showAlert:(NSString *)msg done:(NSString *)done cancel:(NSString *)cancel after:(float)after click:(AlertBlock)click;

@end

#pragma mark - -------- showActionSheet ----------

@interface NSObject (showActionSheet)

///  弹出ActionSheet方法 click:回调 others:按钮数组
- (UIActionSheet *)showActionSheetWithBtns:(NSArray *)others
                                     click:(AlertBlock)click;
///  弹出ActionSheet方法 click:回调 others:按钮数组
- (UIActionSheet *)showActionSheet:(NSString *)title msg:(NSString *)msg cancel:(NSString *)cancel others:(NSArray *)others
                             click:(AlertBlock)click;

@end

#define  DAlert(_title, _msg, _del, _tag, _cancel, _ok) [[UIAlertView alertView:_title msg:_msg del:_del tag:_tag cancel:_cancel others:_ok, nil] show]