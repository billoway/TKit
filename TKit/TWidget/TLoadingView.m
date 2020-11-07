//
//  TLoadingView
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#define Rotate_Time             1.2 * 1
#define Rotate_PI               2 * 1
#define Rotate_Animation_Key    @"rotateAnimation"

#define Alert_Time              2.5f
#define Alert_W                 250
#define Alert_H                 120
#define Alert_H                 120

#import "TLoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "TExt.h"

@interface TLoadingView ()

//    Loading
@property (strong, nonatomic)   UIActivityIndicatorView     *_waitActivity;
/// 背景
@property (nonatomic, strong)   UIView                      *_loadBackView;
/// 圈圈1
@property (strong, nonatomic)   UIImageView                 *_waitIcon;
/// 圈圈2
@property (strong, nonatomic)   UIImageView                 *_waitIcon1;
/// loading 提示文字
@property (strong, nonatomic)   UILabel                     *_waitLabel;
/// 取消loading 按钮
@property (strong, nonatomic)   UIButton                    *_cancelBtn;

/// loading 动画 计时器
@property (strong, nonatomic)   NSTimer                     *_waitTimer;

/// 取消请求block
@property (nonatomic, strong)   VBlock      _cancelBlock;

// Auto label 背景
@property (nonatomic, strong)   UIView      *_alertView;
@property (nonatomic, strong)   UIView      *_alertBackView;
@property (strong, nonatomic)   UILabel     *_alertLabel;

/// 取消显示alert block
@property (nonatomic, strong)   VBlock dissAlertBlk;

@end
@implementation TLoadingView

#pragma mark - -------- TLoadingView method ----------

+ (void)showLoadingWithCancel:(VBlock)cancelBlk text:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self getInstance] set_cancelBlock:cancelBlk];
        [[self getInstance] doShowWithText:text];
    });
}

+ (void)showLoadingWithCancel:(VBlock)cancelBlk
{
    [self showLoadingWithCancel:cancelBlk text:nil];
}

+ (void)dissLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self getInstance] doDiss];
    });
}


//    loading 动画
- (void)rotateIcon
{
    CABasicAnimation *_rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];

    _rotationAnimation.toValue = [NSNumber numberWithFloat:(Rotate_PI * M_PI) * 1];
    _rotationAnimation.duration = Rotate_Time;
    _rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self._waitIcon.layer addAnimation:_rotationAnimation forKey:Rotate_Animation_Key];

    _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    _rotationAnimation.toValue = [NSNumber numberWithFloat:( (-Rotate_PI) * M_PI ) * 1];
    _rotationAnimation.duration = Rotate_Time;
    _rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self._waitIcon1.layer addAnimation:_rotationAnimation forKey:Rotate_Animation_Key];
}

- (void)startAnimation
{
    [self rotateIcon];
    k_Invalidate_Timer(self._waitTimer);
    self._waitTimer = [NSTimer scheduledTimerWithTimeInterval:Rotate_Time target:self selector:@selector(rotateIcon) userInfo:nil repeats:YES];
    [self._waitTimer fire];
}

- (void)stopAnimation
{
    k_Invalidate_Timer(self._waitTimer);
    [self._waitIcon.layer removeAnimationForKey:Rotate_Animation_Key];
}

//    加载loading
- (void)doShowWithText:(NSString *)text
{
    @synchronized(self){
        if ( k_Is_Empty(text) ) {
            text = @"加载中,请稍候…";
        }
        self._waitLabel.text = text;

//        self._cancelBtn.hidden = NO;//(self._cancelBlock == nil);
        
        [self startAnimation];
        
        UIView *view = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [view addSubview:self._loadBackView];
        [view bringSubviewToFront:self._loadBackView];
        [self._loadBackView setNeedsDisplay];
    }
}

//    移除loading
- (void)doDiss
{
    [self stopAnimation];

    [self._loadBackView removeFromSuperview];
}

//    取消请求
- (void)cancelRequest
{
    if (self._cancelBlock) {
        self._cancelBlock();
        self._cancelBlock = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self doDiss];
    });
}

+ (void)didActive
{
    if ([[self getInstance]._loadBackView superview]) {
        [[self getInstance] rotateIcon];
        k_Invalidate_Timer([self getInstance]._waitTimer);
        [self getInstance]._waitTimer = [NSTimer scheduledTimerWithTimeInterval:Rotate_Time target:[self getInstance] selector:@selector(rotateIcon) userInfo:nil repeats:YES];
        [[self getInstance]._waitTimer fire];
    }
}


#pragma mark - -------- AlertView method ----------

+ (void)showAlert:(NSString *)text time:(float)time
{
    [[self getInstance] showAlert:text time:time];
}

+ (void)showAlert:(NSString *)text
{
    [[self getInstance] showAlert:text time:Alert_Time];
}

- (void)showAlert:(NSString *)text time:(float)time
{
    if (time < 1.f) {
        time = Alert_Time;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self._alertLabel.text =  nil;
        self._alertLabel.text = text ? text : @"请稍候……";
        if (![self._alertView superview]) {
            [self._alertView removeFromSuperview];
            [self showAlert:[NSNumber numberWithFloat:time]];
        }
    });
}

- (void)showAlert:(NSNumber *)time
{
    CGSize size = self._alertLabel.realSize;
    
    CGRect bgFrame = CGRectMake( (f_Device_w - Alert_W) / 2.f, f_Device_h - Alert_H, Alert_W, size.height + 30 );
    CGRect frame = CGRectMake( (f_Device_w - Alert_W) / 2.f, f_Device_h - Alert_H + 15, Alert_W, size.height );
    
    self._alertBackView.frame = bgFrame;
    self._alertLabel.frame = frame;
    
    self._alertView.alpha = 1.f;
    UIView *view = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [view addSubview:self._alertView];
    [view bringSubviewToFront:self._alertView];
    
    [self._alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:[time floatValue]];
    [self._alertLabel performSelector:@selector(setText:) withObject:@"" afterDelay:[time floatValue]];
}


- (void)showCenterAlert:(NSString *)text;
{
    self._alertLabel.text = text ? text : @"请稍候……";

    CGSize size = self._alertLabel.realSize;

    CGRect bgFrame = CGRectMake( (f_Device_w - Alert_W) / 2.f, f_Device_h / 2 - 10, Alert_W, size.height + 30 );
    CGRect frame = CGRectMake( (f_Device_w - Alert_W) / 2.f, f_Device_h / 2 + 5, Alert_W, size.height );

    self._alertBackView.frame = bgFrame;
    self._alertLabel.frame = frame;

    self._alertView.alpha = 1.f;
    UIView *view = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [view addSubview:self._alertView];
    [view bringSubviewToFront:self._alertView];


    [self._alertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:Alert_Time];
}


#pragma mark - -------- private method ----------

SINGLETON_FOR_CLASS(TLoadingView)

- (id)init
{
    self = [super init];

    if (self) {
        CGRect frame = [[UIScreen mainScreen] applicationFrame];

        //        ------------ loading
        float loadbgW = 160;
        float loadbgH = 40.f;
        float iconW = 25;
        float iconH = 25;
        UIImage *tImage;
        UIImageView *tImgView;
        
        //  背景
        self._loadBackView = [[UIView alloc] initWithFrame:frame];

        //  透明背景
        UIView *tView = [UIView newView:CGRectMake(0, 0, self._loadBackView.width, self._loadBackView.height)];
        [self._loadBackView addSubview:tView];


        CGRect bgFrame = CGRectMake( (self._loadBackView.width - loadbgW) / 2, (self._loadBackView.height - loadbgH) / 2, loadbgW, loadbgH );
        UIView* backView = [[UIView alloc] initWithFrame:bgFrame];
        backView.alpha = 0.75;
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = 4;
        backView.backgroundColor = [UIColor blackColor];
        [self._loadBackView addSubview:backView];

        // 图片菊花0
        tImage = [UIImage getImage:s_loading_icon1];
        iconW = tImage.width;
        iconH = tImage.height;

        tImgView = [[UIImageView alloc] initWithImage:tImage];
        [tImgView setFrame:CGRectMake(6, (loadbgH - iconH) / 2, iconW, iconH)];
//        [tImgView setAnimationDuration:0.5f];
        [backView addSubview:tImgView];
        self._waitIcon = tImgView;

        // 图片菊花1
        tImage = [UIImage getImage:s_loading_icon2];
        tImgView = [[UIImageView alloc] initWithImage:tImage];
        [tImgView setFrame:CGRectMake(6, (loadbgH - iconH) / 2, iconW, iconH)];
//        [tImgView setAnimationDuration:0.5f];
        [backView addSubview:tImgView];
        self._waitIcon1 = tImgView;

        // 提示文字
        UILabel *tLabel = nil;
        tLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconW + 12, 1, 90, loadbgH)];
        tLabel.backgroundColor = [UIColor clearColor];
        [tLabel setText:@"加载中,请稍候..."];
        [tLabel setFont:[UIFont FontOfSize:11.f]];
        [tLabel setMinFontSizeForScale:7.f];
        [tLabel setTextColor:[UIColor whiteColor]];
        [tLabel setTextAlignment:NSTextAlignmentCenter];
        [backView addSubview:tLabel];
        self._waitLabel = tLabel;

        // 取消请求
        UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tButton.frame = CGRectMake(tLabel.right, 0, backView.width - tLabel.right, loadbgH);
        [tButton dosetImg:s_loading_cancel selectImg:nil highlightedImg:nil];
        [tButton addTarget:self action:@selector(cancelRequest) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:tButton];
        self._cancelBtn = tButton;
//        self._cancelBtn.hidden = YES;

        //        ------------ alert view
        float alertW = 250;
        float alertY = f_Device_h - Alert_H;

        // 背景
        self._alertView = [[UIView alloc] initWithFrame:frame];
        self._alertView.userInteractionEnabled = NO;

        // 黑色背景
        CGRect tFrame = CGRectMake( (f_Device_w - alertW) / 2.f, alertY, alertW, loadbgH );
        tView = [UIView newView:tFrame bgColor:[UIColor blackColor]];
        tView.alpha = 0.7;
        tView.layer.masksToBounds = YES;
        tView.layer.cornerRadius = 6;
        [self._alertView addSubview:tView];
        self._alertBackView = tView;

        // Loading 提示信息
        tLabel = [UILabel newLabel:CGRectMake( (f_Device_w - alertW) / 2.f, alertY, alertW, 50 )];
        [tLabel dosetText:@"请稍候..." font:15 color:[UIColor whiteColor]];
        [tLabel setFont:[UIFont FontOfSize:15]];
        tLabel.numberOfLines = 0;
        tLabel.textAlignment = NSTextAlignmentCenter;
        [self._alertView addSubview:tLabel];
        self._alertLabel = tLabel;
    }

    return self;
}

@end