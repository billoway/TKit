//
//  UIAlertViewEx
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "UIAlertViewEx.h"
#import "NSArrayEx.h"
#import "TDefine.h"

#pragma mark - -------- UIAlert & UIActionSheet block ----------

@interface TAlertResp : NSObject <UIAlertViewDelegate, UIActionSheetDelegate>

#define i_Block_Alert_Tag       951
#define i_Block_ActionSheet_Tag 952

@property (nonatomic, strong) AlertBlock selectBlock;
@property (nonatomic, strong) AlertBlock actionSheetBlock;

@property (nonatomic, strong) UIAlertView   *kAlert;
@property (nonatomic, strong) UIActionSheet *kAction;

SINGLETON_FOR_CLASS_HEADER(TAlertResp);

@end

@implementation TAlertResp

SINGLETON_FOR_CLASS(TAlertResp);

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = [alertView tag];

    if (tag == i_Block_Alert_Tag) {
        if (self.selectBlock) {
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
            self.selectBlock(buttonIndex);
        }

        self.selectBlock = nil;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = [actionSheet tag];

    if (tag == i_Block_ActionSheet_Tag) {
        if (self.actionSheetBlock) {
            self.actionSheetBlock(buttonIndex);
        }

        self.actionSheetBlock = nil;
    }
}


@end

#pragma mark - -------- showAlert ----------

@implementation NSObject (showAlert)

///  弹出框方法 click:回调 btns:按钮
- (void)showAlert:(NSString *)msg btns:(id)btns click:(AlertBlock)click
{
    [self showAlertWithTitle:@"提示" msg:msg btns:btns click:click];
}
///  弹出框方法 click:回调 btns:按钮
- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg btns:(id)btns click:(AlertBlock)click
{
    TAlertResp *tDelegate = [TAlertResp getInstance];
    
    if (tDelegate.selectBlock) {
        return;
    }
    
    tDelegate.selectBlock = click;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:tDelegate cancelButtonTitle:nil otherButtonTitles:nil, nil];
    if ([btns isKindOfClass:[NSArray class]]) {
        for (id tBtn in btns) {
            [alertView addButtonWithTitle:tBtn];
        }
    }else{
        [alertView addButtonWithTitle:[btns description]];
    }
    alertView.tag = i_Block_Alert_Tag;

    [alertView show];
}

///  弹出框方法 click:回调 cancel:左边 done:右边
- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg done:(NSString *)done cancel:(NSString *)cancel click:(AlertBlock)click
{
    UIAlertView *tAlert = [self alert:title msg:msg done:done cancel:cancel click:click];

    if (tAlert) {
        [tAlert show];
    }
}

- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg done:(NSString *)done cancel:(NSString *)cancel after:(float)after click:(AlertBlock)click
{
    UIAlertView *tAlert = [self alert:title msg:msg done:done cancel:cancel click:click];

    if (tAlert) {
        [tAlert performSelector:@selector(show) withObject:nil afterDelay:after];
    }
}

///  弹出框方法 click:回调 cancel:左边 done:右边
- (void)showAlert:(NSString *)msg done:(NSString *)done cancel:(NSString *)cancel click:(AlertBlock)click
{
    UIAlertView *tAlert = [self alert:@"提示" msg:msg done:done cancel:cancel click:click];

    if (tAlert) {
        [tAlert show];
    }
}

///  弹出框方法 click:回调 cancel:左边 done:右边 after:等待一段时间后弹出
- (void)showAlert:(NSString *)msg done:(NSString *)done cancel:(NSString *)cancel after:(float)after click:(AlertBlock)click
{
    UIAlertView *tAlert = [self alert:@"提示" msg:msg done:done cancel:cancel click:click];

    if (tAlert) {
        [tAlert performSelector:@selector(show) withObject:nil afterDelay:after];
    }
}

///  private
- (UIAlertView *)alert:(NSString *)title msg:(NSString *)msg done:(NSString *)done cancel:(NSString *)cancel click:(AlertBlock)click
{
    TAlertResp *tDelegate = [TAlertResp getInstance];

    if (tDelegate.selectBlock) {
        return nil;
    }

    tDelegate.selectBlock = click;

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:tDelegate cancelButtonTitle:cancel otherButtonTitles:done, nil];
    alertView.tag = i_Block_Alert_Tag;
    return alertView;
}

@end

#pragma mark - -------- showActionSheet ----------

@implementation NSObject (showActionSheet)

///  弹出ActionSheet方法 click:回调 others:按钮数组
- (UIActionSheet *)showActionSheetWithBtns:(NSArray *)others
                                     click:(AlertBlock)click
{
    return [self showActionSheet:nil msg:nil cancel:@"取消" others:others click:click];
}

///  弹出ActionSheet方法 click:回调 others:按钮数组
- (UIActionSheet *)showActionSheet:(NSString *)title msg:(NSString *)msg cancel:(NSString *)cancel others:(NSArray *)others
                             click:(AlertBlock)click
{
    TAlertResp *tDelegate = [TAlertResp getInstance];

    if (tDelegate.actionSheetBlock) {
        return nil;
    }

    tDelegate.actionSheetBlock = click;

    UIActionSheet *tActionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:tDelegate cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    tActionSheet.tag = i_Block_ActionSheet_Tag;

    for (id btnTitle in others) {
        [tActionSheet addButtonWithTitle:btnTitle];
    }

    if (cancel) {
        tActionSheet.cancelButtonIndex = [tActionSheet addButtonWithTitle:cancel];
    }

    return tActionSheet;
}

@end