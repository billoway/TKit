//
//  UIButtonEx.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TExt)

/// 设置 点击相应, target, tag
- (void)dosetClick:(SEL)click target:(id)target tag:(NSInteger)tag;

/// 设置 标题, 字体, 颜色:(hexColor || UIColor)
- (void)dosetTitle:(NSString *)title font:(float)font color:(id)color;
/// 设置 标题 ==> 选中, 高亮
- (void)dosetTitle:(NSString *)title selectTitle:(NSString *)sTitle highlightedTitle:(NSString *)hTitle;
/// 设置 标题颜色 ==> 选中, 高亮
- (void)dosetColor:(UIColor *)color selectColor:(UIColor *)sColor highlightedColor:(UIColor *)hColor;

/// 设置 图片 UIImage or imgName => [UIImage getImage:imgName]
- (void)dosetImg:(id)img selectImg:(id)sImg highlightedImg:(id)hImg;
/// 设置 背景图片 UIImage or imgName => [UIImage getImage:imgName]
- (void)dosetBgImg:(id)img selectImg:(id)sImg highlightedImg:(id)hImg;

/// image EdgeInsets (left, top)
@property (nonatomic, assign) CGPoint imageOrigin;
/// title EdgeInsets (left, top)
@property (nonatomic, assign) CGPoint titleOrigin;

+ (id)newButton:(CGRect)frame;

@end

#pragma mark - -------- UIColor ----------

/// 初始化UIColor：HexString
#define UIColor_HexColorAlpha(color,hexString,alpha)    {\
NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];\
\
/* String should be 6 or 8 characters*/\
if ([cString length] < 6) {\
    color = [UIColor blackColor];\
}\
\
/* strip 0X if it appears*/\
if ([cString hasPrefix:@"0X"]) {\
    cString = [cString substringFromIndex:2];\
}\
\
if ([cString hasPrefix:@"#"]) {\
    cString = [cString substringFromIndex:1];\
}\
\
if ([cString length] != 6) {\
    color = [UIColor blackColor];\
}\
\
/* Separate into r, g, b substrings */\
NSRange range;\
range.location = 0;\
range.length = 2;\
NSString *rString = [cString substringWithRange:range];\
\
range.location = 2;\
NSString *gString = [cString substringWithRange:range];\
\
range.location = 4;\
NSString *bString = [cString substringWithRange:range];\
\
/* Scan values */\
unsigned int r, g, b;\
[[NSScanner scannerWithString:rString] scanHexInt:&r];\
[[NSScanner scannerWithString:gString] scanHexInt:&g];\
[[NSScanner scannerWithString:bString] scanHexInt:&b];\
\
color = [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha :alpha];\
}


#define UIColor_HexColor(color,hexString)   UIColor_HexColorAlpha(color,hexString,1)




#pragma mark - -------- UILabel ----------

/// 获取@2x图片的宽
#define UIImage_GetWith(tImage)     {tImage.size.width / (tImage.scale == 1 ? 2.f : 1.f);}
/// 获取@2x图片的高
#define UIImage_GetHeight(tImage)   {tImage.size.htight / (tImage.scale == 1 ? 2.f : 1.f);}


#pragma mark - -------- UILabel ----------
/// 初始化UILabel
#define UILabelNew(x,y,w,h)  [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)]


#pragma mark - -------- UIButton ----------


#if auto_scale
    /// 设置UIButton 标题字体，自动适配
    #define UIButton_SetFone(button,fontSize)   [button.titleLabel setFont:[UIFont FontOfSize:f_auto_scale(fontSize)]]
#else
    /// 设置UIButton 标题字体，未适配i6P
    #define UIButton_SetFone(button,fontSize)   [button.titleLabel setFont:[UIFont FontOfSize:fontSize]];
#endif

//- (void)dosetTitle:(NSString *)title font:(float)font color:(id)color;
/// 设置 标题, 字体, 颜色
#define UIButton_SetTitle(button,title,fontSize,color)  {\
[button setTitle:title forState:UIControlStateNormal];\
if ([color isKindOfClass:[NSString class]]) {\
    [button setTitleColor:[UIColor hexColor:color] forState:UIControlStateNormal];\
}else if ([color isKindOfClass:[UIColor class]]){\
    [button setTitleColor:color forState:UIControlStateNormal];\
}\
    UIButton_SetFone(button,fontSize);\
}



/// 初始化UIButton
#define UIButton_New(x,y,w,h)  [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
/// 设置UIButton点击事件
#define UIButton_SetClick(button,click,target,tag)  {[button addTarget:target action:click forControlEvents:UIControlEventTouchUpInside];button.tag = tag;}
/// 自动布局UIButton图标：自动居中、不拉伸
#define UIButton_AutoLayoutImg(button,tImage)  {\
float tX = (button.frame.size.width - tImage.size.width/2) / 2.f;\
float tY = (button.frame.size.height - tImage.size.height/2) / 2.f;\
[self setImageEdgeInsets:UIEdgeInsetsMake(tY, tX, tY, tX)];\
}

/// 设置UIButton图标/选中/高亮，自动居中，不拉伸
#define UIButton_SetImage(button,img,highlightedImg,selectImg)  {\
if ([img isKindOfClass:[UIImage class]]) {\
    [button setImage:img forState:UIControlStateNormal];\
}\
else if ([img isKindOfClass:[NSString class]]) {\
    [button setImage:[UIImage getImage:img] forState:UIControlStateNormal];\
}\
[button autoLayoutBtnImage:[button imageForState:UIControlStateNormal]];\
\
if ([sImg isKindOfClass:[UIImage class]]) {\
    [button setImage:sImg forState:UIControlStateSelected];\
}\
else if ([sImg isKindOfClass:[NSString class]]) {\
    [button setImage:[UIImage getImage:sImg] forState:UIControlStateSelected];\
}\
button.adjustsImageWhenHighlighted = sImg == nil;\
\
if ([hImg isKindOfClass:[UIImage class]]) {\
    [button setImage:hImg forState:UIControlStateHighlighted];\
}\
else if ([hImg isKindOfClass:[NSString class]]) {\
    [button setImage:[UIImage getImage:hImg] forState:UIControlStateHighlighted];\
}\
}


/// 设置UIButton背景图/选中/高亮，自动居中，不拉伸
#define UIButton_SetBgImg(button,bgImg,highlightedbgImg,selectImg)  {\
if ([bgImg isKindOfClass:[UIImage class]]) {\
[button setImage:bgImg forState:UIControlStateNormal];\
}\
else if ([img isKindOfClass:[NSString class]]) {\
[button setImage:[UIImage getImage:img] forState:UIControlStateNormal];\
}\
[button autoLayoutBtnImage:[button imageForState:UIControlStateNormal]];\
\
if ([sImg isKindOfClass:[UIImage class]]) {\
[button setImage:sImg forState:UIControlStateSelected];\
}\
else if ([sImg isKindOfClass:[NSString class]]) {\
[button setImage:[UIImage getImage:sImg] forState:UIControlStateSelected];\
}\
button.adjustsImageWhenHighlighted = sImg == nil;\
\
if ([hImg isKindOfClass:[UIImage class]]) {\
[button setImage:hImg forState:UIControlStateHighlighted];\
}\
else if ([hImg isKindOfClass:[NSString class]]) {\
[button setImage:[UIImage getImage:hImg] forState:UIControlStateHighlighted];\
}\
}


