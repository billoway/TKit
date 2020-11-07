//
//  TWebImgCache.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#define Web_Default_Img             @"default_web_img.png"
#define Web_Default_Pic             @"default_web_pic.png"
#define Web_Default_Faild_Img       @"default_web_faild_img.png"
#define Web_Default_No_Img          @"default_web_no_img.png"
#define Web_Default_Faild_Pic       @"default_web_faild_pic.png"
#define Web_Default_Faild_Refresh   @"default_web_refresh_img.png"

#import <UIKit/UIKit.h>

@class TWebImgView;
typedef void (^ WebImgBlock)(TWebImgView *imgView, BOOL isSuccess);

@protocol TDownProgressProtocol;


@interface TWebImgView : UIImageView


/// 加载进度控件 需实现 ProgressProtocol 协议
@property (nonatomic, strong)    UIView <TDownProgressProtocol> *progressView;
/// 加载进度 百分比
@property (nonatomic, assign)    float progress;

/// 仅Wifi时下图  ==> 默认读取 [TWebImgView regist_OnlyWifi:NO];
@property (nonatomic, assign)    BOOL onlyWifi;
///// 失败后点击刷新 ==> 默认读取 [TWebImgView regist_FaildRefresh:NO];
@property (nonatomic, assign)    BOOL faildRefresh;
///// 显示菊花圈圈   ==> 默认读取 [TWebImgView regist_IndicatorEnable:NO];
@property (nonatomic, assign)    BOOL indicatorEnable;

#pragma mark - -------- set_image_url (扩展 SDWebImg) ----------

/// ==> 设置网络头像的url 默认头像为subView 并且不拉伸
- (void)setPicUrl:(NSString *)imgUrl;

/// ==> 设置网络图片的url 默认图片为subView 并且不拉伸
- (void)setImgUrl:(NSString *)imgUrl;

/// ==> 设置网络图片的url replaceImg为空则无默认图
- (void)setImgUrl:(NSString *)imgUrl replaceImg:(UIImage *)replaceImg;

/// ==> 设置网络图片的url replaceImg为空则无默认图
- (void)setImgUrl:(NSString *)imgUrl rsp:(WebImgBlock)rsp;

/// ==> 继承 SDWebImg 设置网络图片的 url 和 默认图片
- (void)setImgUrl:(NSString *)imgUrl replaceImg:(UIImage *)replaceImg rsp:(WebImgBlock)rsp;

/// 清除图片缓存 imgUrl:图片下载地址
+ (void)cleanWebImgForUrl:(NSString *)imgUrl;

#pragma mark - -------- regist_config ----------

/// 预置 仅Wifi时下图
+ (void)regist_OnlyWifi:(BOOL)onlyWifi;
/// 预置 失败后点击刷新
+ (void)regist_FaildRefresh:(BOOL)faildRefresh;
/// 预置 失败后点击刷新
+ (void)regist_IndicatorEnable:(BOOL)indicatorEnable;

@end

@interface UIImageView (setImgWithUrl)

/// 设置网络图片的url(SDWebImage 框架) 通用:防止框架改动
- (void)setImgWithUrl:(NSString *)imgUrl replaceImg:(UIImage *)replaceImg;

@end

/// 进度条协议
@protocol  TDownProgressProtocol<NSObject>
@required
/// 进度百分比 (小于等于1)
@property (nonatomic, assign) float progress;

@end
