//
//  UIImageEx
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "UIImageEx.h"
#import "TExt.h"

static NSMutableDictionary *kInstance;

@implementation UIImage (TExt)

#pragma mark - -------- Get App Image ----------

// 获取APP自带图片
+ (UIImage *)getImage:(NSString *)imgName
{
    NSString    *path = nil;
    UIImage     *img = nil;

    if (!imgName || [imgName isEqualToString:@""]) {
        return nil;
    }

    if (!kInstance) {
        kInstance = [[NSMutableDictionary alloc] initWithCapacity:0];
    }

    if ([kInstance count] > 0) {
        img = [kInstance objectForKey:imgName];

        if (img != nil) {
            return img;
        }
    }

//    NSString *retinaTag = [UIScreen mainScreen].scale > 2.1 ? @"@3x" : @"@2x";
    // 1.有扩展名 2:匹配.png扩展 2:匹配@2x.png扩展 3:匹配.jpg扩展 .....
    NSArray *extNames = @[@"",
                          @".png",
                          [@"@2x" appendStr:@".png"],
                          [@"@3x" appendStr:@".png"],

                          @".jpg",
                          [@"@2x" appendStr:@".jpg"],
                          [@"@3x" appendStr:@".jpg"],

                          @".gif",
                          [@"@2x" appendStr:@".gif"],
                          [@"@3x" appendStr:@".gif"],

                          @".bmp",
                          [@"@2x" appendStr:@".bmp"],
                          [@"@3x" appendStr:@".bmp"]
                        ];

    for (id ext in extNames) {
        path = [[s_MainBundle_Path appendPath:s_Image_Dir] appendPath:[imgName appendStr:ext]];
        img = [[UIImage alloc] initWithContentsOfFile:path];
        if (!img) {
            path = [s_MainBundle_Path appendPath:[imgName appendStr:ext]];
            img = [[UIImage alloc] initWithContentsOfFile:path];
        }
        if (img) {
            break;
        }
    }

    if (img) {
        [kInstance setObject:img forKey:imgName];
    }else {
        DLog(@" ---> Can't find the image (%@) ", imgName);
    }

    return img;
}

/// 获取APP自带图片,缓存到内存 (自动社别设备后缀  iphone4比例:xxx@2x.png iphone5比例: xxx-568h@2x.png )
+ (UIImage *)getDeviceImg:(NSString *)imageName
{
    if (Is_4InchDisplay) {
        NSString *sepStr = @".";

        if ([imageName rangeOfString:@"@2x."].location != NSNotFound) {
            sepStr = @"@2x.";
        }
        else {
            if ([imageName rangeOfString:@"@2x"].location != NSNotFound) {
                sepStr = @"@2x";
            }
        }

        NSArray     *items = [imageName componentsSeparatedByString:sepStr];
        NSString    *realName = [NSString stringWithFormat:@"%@%@%@%@", [items objectAtIndex:0], iPhone5_Tag, sepStr, [items objectAtIndex:1]];
        return [UIImage getImage:realName];
    }

    return [UIImage getImage:imageName];
}

/// 获取APP自带图片,根据主题文件名称区分
+ (UIImage *)getThemeImg:(NSString *)imgName theme:(NSString *)theme
{
    NSString *fullName = [theme stringByAppendingPathComponent:imgName];

    if (theme && ![theme isEqualToString:@""]) {
        fullName = [theme stringByAppendingPathComponent:imgName];
    }

    return [UIImage getImage:fullName];
}

+ (void)removeImage:(NSString *)imageName
{
    if (!imageName || [imageName isEqualToString:@""]) {
        return;
    }
    [kInstance removeObjectForKey:imageName];
}

+ (void)removeAllImage
{
    [kInstance removeAllObjects];
}

#pragma mark - -------- Image Scale ----------

- (UIImage *)resizableImage:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
}

- (UIImage *)scale2xImage
{
    CGImageRef imageRef = self.CGImage;

    if (self.scale == 2) {
        return self;
    }

    return [UIImage imageWithCGImage:imageRef scale:2.0f orientation:UIImageOrientationUp];
}

- (CGFloat)width
{
    return self.size.width / (self.scale == 1 ? 2.f : 1.f);
}

- (CGFloat)height
{
    return self.size.height / (self.scale == 1 ? 2.f : 1.f);
}

#pragma mark - -------- launchImage Image ----------

+ (UIImage *)launchImage
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    BOOL phone = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
    BOOL landscape = UIInterfaceOrientationIsLandscape(orientation);
    NSString *os_version = [[UIDevice currentDevice] systemVersion];

    //check the ios7 key
    NSArray *ios7LaunchImages = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    if (ios7LaunchImages != nil) {
        NSString *orientationString = @"Portrait";
        if (!phone && landscape) {
            orientationString = @"Landscape";
        }
        //filter down the array to just the matching elements

        UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
        if (mainWindow == nil) {
            mainWindow = [[UIApplication sharedApplication].windows firstObject];
        }


        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UILaunchImageMinimumOSVersion <= %@ AND UILaunchImageOrientation = %@ AND UILaunchImageSize = %@", os_version, orientationString, NSStringFromCGSize(mainWindow.bounds.size)];
        NSArray *suitableLaunchImages = [ios7LaunchImages filteredArrayUsingPredicate:predicate];
        NSString *imageName = [[suitableLaunchImages lastObject] objectForKey:@"UILaunchImageName"];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image != nil) {
            return image;
        }
    }

    //check the pre-ios7 key
    NSString *baseName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImageFile"];
    if (baseName == nil) {
        baseName = @"Default";
    }

    if (phone) {
        BOOL fourinch = ([UIScreen mainScreen].bounds.size.height == 568.0);
        return fourinch ? [UIImage imageNamed:[NSString stringWithFormat:@"%@-568h", baseName]] : [UIImage imageNamed:baseName];
    }
    else {
        UIImage *image = nil;
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-PortraitUpsideDown", baseName]];
        }
        else if (orientation == UIInterfaceOrientationLandscapeLeft) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-LandscapeLeft", baseName]];
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-LandscapeRight", baseName]];
        }
        if (image != nil) {
            return image;
        }

        image = [UIImage imageNamed:[NSString stringWithFormat:(landscape ? @"%@-Landscape" : @"%@-Portrait"), baseName]];

        if (image != nil) {
            return image;
        }

        return [UIImage imageNamed:[NSString stringWithFormat:(landscape ? @"%@-Landscape~ipad" : @"%@-Portrait~ipad"), baseName]];
    }
}



// Thanks to http://stackoverflow.com/a/20045142/2082172
// This category supports only iOS 7+, although it should be easy to add 6- support.

static NSString *const kAssetImageBaseFileName = @"LaunchImage";

// Asset catalog part
static CGFloat const kAssetImage4inchHeight = 568.;
static CGFloat const kAssetImage35inchHeight = 480.;
static CGFloat const kAssetImage6PlusScale = 3.;

static NSString *const kAssetImageiOS8Prefix = @"-800";
static NSString *const kAssetImageiOS7Prefix = @"-700";
static NSString *const kAssetImagePortraitString = @"-Portrait";
static NSString *const kAssetImageLandscapeString = @"-Landscape";
static NSString *const kAssetImageiPadPostfix = @"~ipad";
static NSString *const kAssetImageHeightFormatString = @"-%.0fh";
static NSString *const kAssetImageScaleFormatString = @"@%.0fx";

// IB based part
static NSString *const kAssetImageLandscapeLeftString = @"-LandscapeLeft";
static NSString *const kAssetImagePathToFileFormatString = @"~/Library/Caches/LaunchImages/%@/%@";
static NSString *const kAssetImageSizeFormatString = @"{%.0f,%.0f}";


+ (UIImage *)assetLaunchImageWithOrientation:(UIInterfaceOrientation)orientation useSystemCache:(BOOL)cache
{
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat screenHeight = screen.bounds.size.height;
    if ([screen respondsToSelector:@selector(convertRect:toCoordinateSpace:)]) {
        screenHeight = [screen.coordinateSpace convertRect:screen.bounds toCoordinateSpace:screen.fixedCoordinateSpace]
                       .size.height;
    }
    CGFloat scale = screen.scale;
    BOOL portrait = UIInterfaceOrientationIsPortrait(orientation);
    BOOL isiPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
    BOOL isiPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    NSMutableString *imageNameString = [NSMutableString stringWithString:kAssetImageBaseFileName];
    if (isiPhone &&
        screenHeight > kAssetImage4inchHeight) {
        // currently here will be launch images for iPhone 6 and 6 plus
        [imageNameString appendString:kAssetImageiOS8Prefix];
    }
    else {
        [imageNameString appendString:kAssetImageiOS7Prefix];
    }
    if (scale >= kAssetImage6PlusScale || isiPad) {
        NSString *orientationString = portrait ? kAssetImagePortraitString : kAssetImageLandscapeString;
        [imageNameString appendString:orientationString];
    }

    if (isiPhone && screenHeight > kAssetImage35inchHeight) {
        [imageNameString appendFormat:kAssetImageHeightFormatString, screenHeight];
    }

    if (cache) {
        if (isiPad) {
            [imageNameString appendString:kAssetImageiPadPostfix];
        }
        return [UIImage imageNamed:imageNameString];
    }
    else {
        if (scale > 1) {
            [imageNameString appendFormat:kAssetImageScaleFormatString, scale];
        }
        if (isiPad) {
            [imageNameString appendString:kAssetImageiPadPostfix];
        }
        NSData *data =
            [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameString ofType:@"png"]];
        return [UIImage imageWithData:data scale:scale];
    }
}

+ (UIImage *)interfaceBuilderBasedLaunchImageWithOrientation:(UIInterfaceOrientation)orientation
                                              useSystemCache:(BOOL)cache
{
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat screenHeight = screen.bounds.size.height;
    CGFloat screenWidth = screen.bounds.size.width;
    BOOL portrait = UIInterfaceOrientationIsPortrait(orientation);
    if ( (screenHeight > screenWidth && !portrait) || (screenWidth > screenHeight && portrait) ) {
        CGFloat temp = screenWidth;
        screenWidth = screenHeight;
        screenHeight = temp;
    }
    NSMutableString *imageNameString = [NSMutableString stringWithString:kAssetImageBaseFileName];
    NSString *orientationString = portrait ? kAssetImagePortraitString : kAssetImageLandscapeLeftString;
    [imageNameString appendString:orientationString];

    [imageNameString appendFormat:kAssetImageSizeFormatString, screenWidth, screenHeight];
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *pathToFile = [[NSString
                             stringWithFormat:kAssetImagePathToFileFormatString, bundleID, imageNameString] stringByExpandingTildeInPath];
    if (cache) {
        return [UIImage imageNamed:pathToFile];
    }
    else {
        CGFloat scale = screen.scale;
        NSData *data = [NSData dataWithContentsOfFile:pathToFile];
        return [UIImage imageWithData:data scale:scale];
    }
}

+ (UIImage *)interfaceBuilderBasedLaunchImage
{
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return [UIImage interfaceBuilderBasedLaunchImageWithOrientation:statusBarOrientation useSystemCache:YES];
}

+ (UIImage *)assetLaunchImage
{
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return [UIImage assetLaunchImageWithOrientation:statusBarOrientation useSystemCache:YES];
}

+ (UIImage *)assetLaunchImageWithSize:(CGSize)size useSystemCache:(BOOL)cache
{
    UIInterfaceOrientation orientation =
        (size.height > size.width) ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeLeft;
    return [UIImage assetLaunchImageWithOrientation:orientation useSystemCache:cache];
}

+ (UIImage *)interfaceBuilderBasedLaunchImageWithSize:(CGSize)size useSystemCache:(BOOL)cache
{
    UIInterfaceOrientation orientation =
        (size.height > size.width) ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeLeft;
    return [UIImage interfaceBuilderBasedLaunchImageWithOrientation:orientation useSystemCache:cache];
}


#pragma mark - -------- Image Rotate ----------

- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:k_RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView              *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(k_DegreesToRadians(degrees));

    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;

    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();

    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width / 2, rotatedSize.height / 2);

    //   // Rotate the image context
    CGContextRotateCTM( bitmap, k_DegreesToRadians(degrees) );

    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - -------- Image Compress ----------

/// 去除图片方向信息
- (UIImage *)fixOrientation
{
    UIImage *aImage = self;

    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) {
        return aImage;
    }

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (aImage.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
        break;

    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        break;

    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        break;

    default:
        break;
    }

    switch (aImage.imageOrientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;

    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;

    default:
        break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate( NULL, aImage.size.width, aImage.size.height,
                                              CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                              CGImageGetColorSpace(aImage.CGImage),
                                              CGImageGetBitmapInfo(aImage.CGImage) );
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
        // Grr...
        CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
        break;

    default:
        CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
        break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/// 压缩图片
- (UIImage *)imgCompressByMaxWidth:(float)maxWidth quality:(float)quality
{
    CGSize size = CGSizeMake( maxWidth, self.size.height * (maxWidth / self.size.width) );
    return [self thumbnailImage:size quality:quality];
    
}


#pragma mark - -------- Image sava ----------

/// 保存图片到相册
+ (void)savaToAlbum:(UIImage *)image
{
    UIImage *savaImage = image;
    if ([savaImage isKindOfClass:[UIImage class]]) {
        UIImageWriteToSavedPhotosAlbum(savaImage, image, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片未能下载成功，无法保存!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

/// 保存回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString    *message;
    NSString    *title;

    if (!error) {
        title = NSLocalizedString(@"提示", @"");
        message = NSLocalizedString(@"照片保存成功,打开相册即可查看。", @"");
    }
    else {
        title = NSLocalizedString(@"提示", @"");
        message = @"保存失败，请重新尝试。";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"好", @"") otherButtonTitles:nil];
    [alert show];
}

@end