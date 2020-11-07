//
//  TWebImgCache.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TWebImgView.h"
#import "TExt.h"

//#ifdef TKIT_LIB
//#import "../Externals/SDWebImage/UIImageView+WebCache.h"
//
//#else
#import "UIImageView+WebCache.h"

//#endif

static BOOL kOnlyWifi;
static BOOL kFaildRefresh;
static BOOL kIndicatorEnable;

@interface TWebImgView ()

/// 是否拉伸默认图
@property (nonatomic, assign)    BOOL scalePlaceImg;
/// 是否为头像
@property (nonatomic, assign)    BOOL isPic;
/// 菊花圈
@property (nonatomic, strong)    UIActivityIndicatorView *indicatorView;
/// 默认图
@property (nonatomic, strong)    UIImageView *_replaceImg;
/// 获取完成的回调
@property (nonatomic, strong)    WebImgBlock rBlock;

@end

@implementation TWebImgView


#pragma mark - -------- set_image_url (扩展 SDWebImg) ----------

/// ==> 设置网络头像的url 默认头像为subView 并且不拉伸
- (void)setPicUrl:(NSString *)imgUrl;
{
//    self.scalePlaceImg = NO;
    [self setImgUrl:imgUrl replaceImg:[UIImage getImage:Web_Default_Pic] scalePlace:NO rsp:nil];
}
/// ==> 设置网络图片的url 默认图片为subView 并且不拉伸
- (void)setImgUrl:(NSString *)imgUrl;
{
    [self setImgUrl:imgUrl replaceImg:[UIImage getImage:Web_Default_Img] scalePlace:YES rsp:nil];
}
/// ==> 设置网络图片的url replaceImg为空则无默认图
- (void)setImgUrl:(NSString *)imgUrl replaceImg:(UIImage *)replaceImg;
{
    [self setImgUrl:imgUrl replaceImg:replaceImg scalePlace:NO rsp:nil];
}
/// ==> 设置网络图片的url replaceImg为空则无默认图
- (void)setImgUrl:(NSString *)imgUrl rsp:(WebImgBlock)rsp;
{
    [self setImgUrl:imgUrl replaceImg:[UIImage getImage:Web_Default_Img] scalePlace:YES rsp:rsp];
}
/// ==> 继承 SDWebImg 设置网络图片的 url 和 默认图片
- (void)setImgUrl:(NSString *)imgUrl replaceImg:(UIImage *)replaceImg rsp:(WebImgBlock)rsp;
{
    [self setImgUrl:imgUrl replaceImg:replaceImg scalePlace:NO rsp:rsp];
}

/// ==> 继承 SDWebImg 设置网络图片的 url 和 默认图片
- (void)setImgUrl:(NSString *)imgUrl replaceImg:(UIImage *)replaceImg scalePlace:(BOOL)scalePlace rsp:(WebImgBlock)rsp;
{
    NSURL *tURL = [NSURL URLWithString:imgUrl];
    if (!tURL && [imgUrl hasPrefix:@"/"] ) {
        tURL = [[NSURL alloc] initFileURLWithPath:imgUrl];;
    }
    if (!tURL){
        [self addDefaultImg:[UIImage getImage:Web_Default_No_Img] isScale:scalePlace];
        return;
    }
    
    /// 默认图
    [self addDefaultImg:replaceImg isScale:scalePlace];
    
    // 处理 菊花圈 (根据开关自动加载)
    [self addIndicatorView];
    
    // 回调
    self.rBlock = rsp;
    __block TWebImgView *bSelf = self;
    
    // ------- 下载进度
    SDWebImageDownloaderProgressBlock bProgress = ^(NSInteger receivedSize, NSInteger expectedSize) {
        bSelf.progress = ((float)receivedSize) / expectedSize;
    };
    
    // ------- 下载完成
    SDWebImageCompletionBlock bCompletion = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        [bSelf imageDidDownload:image error:error cacheType:cacheType imageURL:tURL];
    };
    
    [self sd_setImageWithURL:tURL
            placeholderImage:nil
                     options:SDWebImageAllowInvalidSSLCertificates
                    progress:bProgress
                   completed:bCompletion];
    
}

-(void) imageDidDownload:(UIImage *)image error:(NSError *)error cacheType:( SDImageCacheType)cacheType imageURL:(NSURL *)imageURL
{
    // 调试bug 问题 ==> 界面上看 网络图片加载成功 默认图仍在（一般在读取缓存情况下出现bug  很难重现）
    if (!image && self.image) {
//        DLog(" ===> image is null %@ -- %@", image, error);
        [self imgDownloadFaild];
    }
//    DLog(" _IMAGE_DOWNLOAD_  self:%@  image:%@",NSStringFromCGSize(self.size),NSStringFromCGSize(image.size));
    
    // 移除默认图
    if (image || self.image) {
        [self._replaceImg removeFromSuperview];
    }
    // 移除菊花
    [self removeIndicatorView];
    
    // 移除进度条
    if (self.progressView) {
        [self.progressView removeFromSuperview];
    }
    
    // 回调
    // imageview 是否已经加载到内存中? 如果加载了 就不要继续回调了
//    if (cacheType != SDImageCacheTypeMemory && completion) {
//        completion(self,error);
//    }
    if (self.rBlock) {
        self.rBlock(self,error==nil);
        self.rBlock = nil;
    }
}


/// 清除图片缓存 imgUrl:图片下载地址
+(void) cleanWebImgForUrl:(NSString*)imgUrl;
{
    SDImageCache* cache = [SDImageCache sharedImageCache];
    SDWebImageManager* manager = [SDWebImageManager sharedManager];
    
    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:imgUrl]];
    [cache removeImageForKey:key fromDisk:YES];
}

#pragma mark - -------- regist_config ----------


/// 预置 仅Wifi时下图
+(void) regist_OnlyWifi:(BOOL)onlyWifi;
{
    kOnlyWifi = onlyWifi;
}
/// 预置 失败后点击刷新
+(void) regist_FaildRefresh:(BOOL)faildRefresh;
{
    kFaildRefresh = faildRefresh;
}
/// 预置 失败后点击刷新
+(void) regist_IndicatorEnable:(BOOL)indicatorEnable;
{
    kIndicatorEnable = indicatorEnable;
}

#pragma mark - -------- private ----------

///  添加默认图片 ==> 避免拉伸变形
- (void)addDefaultImg:(UIImage *)tImage isScale:(BOOL)isScale
{
    if (!self._replaceImg) {
        self._replaceImg = [[UIImageView alloc] init];
    }

    if (tImage) {
        float scale = self.width/tImage.width; // 图片缩放倍数   用于图片过大时  默认图过小
        if (isScale) {
            // 逻辑 尺寸小的边 是默认图1.8倍以上 并且 尺寸大的边 是默认图2.2倍以上  倍数为 小边与默认图倍数  除以1.6
            if ((((self.width > self.height) ? self.height : self.width) / tImage.width > 1.8) && (((self.width < self.height) ? self.height : self.width) / tImage.width > 2.2f)) {
                scale = ((self.width > self.height ? self.height : self.width) / tImage.width) / 1.5;
            }else if(tImage.width > self.width){
                scale = (self.width*0.85)/tImage.width;
            }
            if (scale>1) {
                scale = 1;
            }
        }
        self._replaceImg.frame = CGRectMake(0, 0, tImage.width * scale, tImage.height * scale);
    }else{
        self._replaceImg.frame = CGRectMake(0, 0, self.width, self.height);
    }
    
    if (![self._replaceImg superview]) {
        [self addSubview:self._replaceImg];
    }

    if (!tImage || ![tImage isKindOfClass:[UIImage class]]) {
        return;
    }
    
    [self._replaceImg setImage:tImage];
    self._replaceImg.center = CGPointMake(self.width / 2.f, self.height / 2.f);
}

///  添加失败图片 ==> 避免拉伸变形
- (void) imgDownloadFaild
{
    UIImage* faildImg = [UIImage getImage:Web_Default_Faild_Img];
    if (faildImg) {
        self._replaceImg.image = faildImg;
    }
}

/// 加载菊花圈圈
- (void)addIndicatorView
{
    if (self.indicatorView || !self.indicatorEnable) {
        return;
    }
    
    UIActivityIndicatorView *tActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    tActivityView.frame = CGRectMake(0, 10, 15, 15);
    tActivityView.hidesWhenStopped = YES;
    [tActivityView startAnimating];
    [self addSubview:tActivityView];
    tActivityView.center = self.center;
    self.indicatorView = tActivityView;
}

-(void) removeIndicatorView
{
    if (self.indicatorView) {
        [self.indicatorView stopAnimating];
    }
}

/// 下载进度 控件
- (void)setProgressView:(UIView <TDownProgressProtocol> *)progressView
{
    if (!progressView) {
        return;
    }

    @synchronized(self) {
        [self addSubview:progressView];
        //        progressView.center = self.center;
        float   x = CGRectGetWidth(self.frame) / 2;
        float   y = CGRectGetHeight(self.frame) / 2;
        CGPoint center = CGPointMake(x, y);
        progressView.center = center;
        _progressView = progressView;
    }
}

/// 下载进度
- (void)setProgress:(float)progress
{
    if (self.progressView) {
        self.progressView.progress = progress;
    }
}

#pragma mark - -------- 缓冲圈 ----------




#pragma mark - -------- private ----------

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
        self.onlyWifi = kOnlyWifi;
        self.faildRefresh = kFaildRefresh;
        self.indicatorEnable = kIndicatorEnable;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
        self.onlyWifi = kOnlyWifi;
        self.faildRefresh = kFaildRefresh;
        self.indicatorEnable = kIndicatorEnable;
    }
    return self;
}


@end

@implementation UIImageView (setImgWithUrl)

/// 设置网络图片的url(SDWebImage 框架) 通用:防止框架改动
- (void)setImgWithUrl:(NSString *)imgUrl replaceImg:(UIImage *)replaceImg
{
    NSURL *url = [NSURL URLWithString:imgUrl];
    if (!url && [imgUrl hasPrefix:@"/"] ) {
        url = [[NSURL alloc] initFileURLWithPath:imgUrl];;
    }
    if (!url) {
        return;
    }
    [self sd_setImageWithURL:url placeholderImage:replaceImg];
}

@end