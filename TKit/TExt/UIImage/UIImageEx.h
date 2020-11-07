//
//  UIImageEx
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#define iPhone5_Tag @"-568h"

#import "UIImage+Alpha.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"


@interface UIImage (TExt)

#pragma mark - -------- Get App Image ----------

/// 获取APP自带图片,缓存到内存
+ (UIImage *)getImage:(NSString *)imageName;
/// 获取APP自带图片,缓存到内存 (自动社别设备后缀  iphone4比例:xxx@2x.png iphone5比例: xxx-568h@2x.png )
+ (UIImage *)getDeviceImg:(NSString *)imageName;
/// 获取APP自带图片,根据主题文件名称区分
+ (UIImage *)getThemeImg:(NSString *)imgName theme:(NSString *)theme;
/// 移除内存缓存图片
+ (void)removeImage:(NSString *)imageName;
/// 移除内存缓存所有图片
+ (void)removeAllImage;


#pragma mark - -------- Image Scale ----------

/// image 宽度(素材仅支持高清屏)
@property (nonatomic, readonly) CGFloat width;
/// image 高度(素材仅支持高清屏)
@property (nonatomic, readonly) CGFloat height;

///压缩图片为@2x状态,用于Retina 设备
- (UIImage *)scale2xImage;
///创建一个边角可拉伸的UIImage, top left bottom right 分别为上下左右不拉伸部分的长度
- (UIImage *)resizableImage:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

#pragma mark - -------- launchImage Image ----------

+ (UIImage *)launchImage;
+ (UIImage *)assetLaunchImage;
+ (UIImage *)interfaceBuilderBasedLaunchImage;
+ (UIImage *)interfaceBuilderBasedLaunchImageWithOrientation:(UIInterfaceOrientation)orientation useSystemCache:(BOOL)cache;
+ (UIImage *)assetLaunchImageWithOrientation:(UIInterfaceOrientation)orientation useSystemCache:(BOOL)cache;
+ (UIImage *)assetLaunchImageWithSize:(CGSize)size useSystemCache:(BOOL)cache;
+ (UIImage *)interfaceBuilderBasedLaunchImageWithSize:(CGSize)size useSystemCache:(BOOL)cache;

#pragma mark - -------- Image Rotate ----------

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;


#pragma mark - -------- Image Compress ----------

/// 去除图片方向信息
- (UIImage *)fixOrientation;

/// 压缩图片
- (UIImage *)imgCompressByMaxWidth:(float)maxWidth quality:(float)quality;

#pragma mark - -------- Image sava ----------

/// 保存图片到相册
+ (void)savaToAlbum:(UIImage *)image;

@end

/// 图片大小
#define i_CompressImg_quality   0.75
#define i_CompressImg_Width     720

/// 压缩图片 尺寸:720宽, 质量0.75
#define k_CompressImg(image)    [image imgCompressByMaxWidth:i_CompressImg_Width quality:i_CompressImg_quality]

/// 压缩图片后的文件流 尺寸:720宽, 质量0.75
#define k_CompressImgData(image)    UIImageJPEGRepresentation(k_CompressImg(image), 1)
