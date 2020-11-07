//
//  define.pch
//  TestBlock
//
//  Created by LiuTao on 15/12/30.
//  Copyright © 2015年 LiuTao. All rights reserved.
//

//  build-setting 中搜索   PREFIX_HEADER  添加  UIDeinfe.h 文件路径（直接托文件过去即可）


// 判断是否有定义 某个宏
#ifndef UIDefine_h
#define UIDefine_h
 

/// 屏幕宽度
#define F_DEVICE_BOUNDS     [UIScreen mainScreen].bounds
/// 屏幕宽度
#define F_DEVICE_W          [UIScreen mainScreen].bounds.size.width
/// 屏幕高度
#define F_DEVICE_H          [UIScreen mainScreen].bounds.size.height
/// 状态栏高
#define F_STATUS_BAR_H      20
/// 导航栏高
#define F_NAV_BAR_H         44
/// 导航页面Y
#define F_NAV_Y             (F_STATUS_BAR_H + F_NAV_BAR_H)
/// 导航页面高
#define F_NAV_H             (F_DEVICE_H - F_NAV_Y)
/// Tabbar
#define F_TAB_BAR_H         49
/// 根据iphone6 效果图的尺寸 算出实际设备中尺寸
#define F_I6_SIZE(f)        ( ( (int)( ( F_DEVICE_W * ( (f) / 375.f ) ) * 2 ) ) / 2.f )
/// 根据iphone5 效果图的尺寸 算出实际设备中尺寸
#define F_I5_SIZE(f)        ( ( (int)( ( F_DEVICE_W * ( (f) / 320.f ) ) * 2 ) ) / 2.f )


//---------------- 处理图片
//获取images.bundle 中的图片
#define GET_IMAGE(name)         [UIImage imageNamed:[NSString stringWithFormat:@"images.bundle/%@",name?name:@"default.png"]]
//自动设置 imgView 的 size :不会改变img的 x，y
#define SET_IMAGE_SIZE(tImgView)     {CGRect frame = tImgView.frame;\
frame.size = CGSizeMake(tImgView.image.size.width/2, tImgView.image.size.height/2);\
tImgView.frame = frame;}


//------------------  数据比较
#pragma mark - -------- UIView ----------

/// 视图的坐标中存在非整元素的位置和大小时,会导致图片锯齿严重,在iPhone6 Plus上会肉眼可识别, 此处处理,使坐标系中的数都为0.5的倍数
#define  k_float_int(tmp)    ( ( (int)( (tmp) * 2 ) ) / 2.f )

// 初始化
#define KViewNew(frame)     [[UIView alloc] initWithFrame : frame]

/// UIView get width
#define KViewGetWidth(view)          view.frame.size.width
/// UIView set width
#define KViewSetWidth(view, w)       {CGRect frame = view.frame; \
                                      frame.size.width = k_float_int(w); \
                                      view.frame = frame; \
}

/// UIView get height
#define KViewGetHeight(view)        view.frame.size.height
/// UIView set height
#define KViewSetHeight(view, h)     {CGRect frame = view.frame; \
                                     frame.size.height = k_float_int(h); \
                                     view.frame = frame; \
}

/// UIView get left
#define KViewGetLeft(view)           view.frame.origin.x
/// UIView set left
#define KViewSetLeft(view, left)     {CGRect frame = view.frame; \
                                      frame.origin.x = k_float_int(left); \
                                      view.frame = frame; \
}

/// UIView get right
#define KViewGetRight(view)          (view.frame.origin.x + view.frame.size.width)
/// UIView set right
#define KViewSetRight(view, right)   {CGRect frame = view.frame; \
                                      frame.origin.x = k_float_int(right - frame.size.width); \
                                      view.frame = frame; \
}

/// UIView get top
#define KViewGetTop(view)           view.frame.origin.y
/// UIView set top
#define KViewSetTop(view, top)      {CGRect frame = view.frame; \
                                     frame.origin.y = k_float_int(top); \
                                     view.frame = frame; \
}

/// UIView get bottom
#define KViewGetBottom(view)          (view.frame.origin.y + view.frame.size.height)
/// UIView set bottom
#define KViewSetBottom(view, bottom)   {CGRect frame = view.frame; \
                                        frame.origin.y = k_float_int(bottom - frame.size.height); \
                                        view.frame = frame; \
}

/// UIView get size
#define KViewGetSize(view)            view.frame.size
/// UIView set size
#define KViewSetSize(view, size)    {CGRect frame = view.frame; \
                                     frame.size.width = k_float_int(size.width); \
                                     frame.size.height = k_float_int(size.height); \
                                     view.frame = frame; \
}

/// UIView get orgin
#define KViewGetOrigin(view)            view.frame.origin
/// UIView set orgin
#define KViewSetOrigin(view, origin)    {CGRect frame = view.frame; \
                                         frame.origin.x = k_float_int(origin.x); \
                                         frame.origin.y = k_float_int(origin.y); \
                                         view.frame = frame; \
}

/// UIView get centerY
#define KViewGetCenterY(view)            view.center.y
/// UIView set centerY
#define KViewSetCenterY(view, centerY)    {CGPoint center = view.center; \
                                           center.y = k_float_int(centerY); \
                                           view.center = center; \
}

/// UIView get centerX
#define KViewGetCenterX(view)            view.center.x
/// UIView set centerX
#define KViewSetCenterX(view, centerX)    {CGPoint center = view.center; \
                                           center.x = k_float_int(centerX); \
                                           view.center = center; \
}

// 加圆角
#define KViewSetCornerRadius(view, radius)      {view.layer.masksToBounds = YES; \
                                                 view.layer.cornerRadius = radius; \
}

// 加边框
#define KViewSetBorder(view, borderW, color)       {view.layer.borderWidth = borderW; \
                                                    view.layer.borderColor = color?[color CGColor]:nil; \
}

// 设置阴影
#define KViewSetShadowCoror(view, color, offset, radius)       {view.layer.shadowColor = color.CGColor; \
                                                                view.layer.shadowOffset = offset; \
                                                                view.layer.shadowRadius = radius; \
                                                                view.layer.shadowOpacity = 1; \
}
// 移除所有子视图
#define KViewRemoveSubviews(view)   {for (UIView *tV in view.subviews) { \
                                         [tV removeFromSuperview]; \
                                     } \
}

// 移到顶层
#define KViewBringToFront(view)     [view.superview bringSubviewToFront : view]

// 移到底层
#define KViewSendToBack(view)       [view.superview sendSubviewToBack : view]

// 是否在顶层
#define KViewIsFront(view)          ([view.superview.subviews lastObject] == view)

// 是否在底层
#define KViewIsBack(view)           ([view.superview.subviews objectAtIndex:0] == view)

// 获取自己在父视图中的Index
#define KViewGetSubViewIndex(view)  [view.superview.subviews indexOfObject:view]

// 切换两个视图的下标顺序
#define KViewSwapDepths(view1,view2)  [view1.superview exchangeSubviewAtIndex:KViewGetSubViewIndex(view1) withSubviewAtIndex:KViewGetSubViewIndex(view2)]




#pragma mark - -------- UIColor ----------

/// 初始化UIColor：HexString
#define KColor_HexColorAlpha(color,hexString,alpha)    {\
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


#define KColor_HexColor(color,hexString)   UIColor_HexColorAlpha(color,hexString,1)




#pragma mark - -------- UIImage ----------

/// 获取@2x图片的宽
#define KImage_GetWith(tImage)     {tImage.size.width / (tImage.scale == 1 ? 2.f : 1.f);}
/// 获取@2x图片的高
#define KImage_GetHeight(tImage)   {tImage.size.htight / (tImage.scale == 1 ? 2.f : 1.f);}


#pragma mark - -------- UILabel ----------
/// 初始化UILabel
#define KLabelNew(frame)  [[UILabel alloc] initWithFrame:frame]


#pragma mark - -------- UIButton ----------


#if auto_scale_font
/// 设置UIButton 标题字体，自动适配
    #define KButton_SetFone(button,fontSize)   [button.titleLabel setFont:[UIFont FontOfSize:f_auto_scale(fontSize)]]
#else
/// 设置UIButton 标题字体，未适配i6P
    #define KButton_SetFone(button,fontSize)   [button.titleLabel setFont:[UIFont FontOfSize:fontSize]];
#endif

//- (void)dosetTitle:(NSString *)title font:(float)font color:(id)color;
/// 设置 标题, 字体, 颜色
#define KButton_SetTitle(button,title,fontSize,color)  {\
[button setTitle:title forState:UIControlStateNormal];\
if ([color isKindOfClass:[NSString class]]) {\
[button setTitleColor:[UIColor hexColor:color] forState:UIControlStateNormal];\
}else if ([color isKindOfClass:[UIColor class]]){\
[button setTitleColor:color forState:UIControlStateNormal];\
}\
UIButton_SetFone(button,fontSize);\
}



/// 初始化UIButton
#define KButton_New(x,y,w,h)  [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
/// 设置UIButton点击事件
#define KButton_SetClick(button,click,target,tag)  {[button addTarget:target action:click forControlEvents:UIControlEventTouchUpInside];button.tag = tag;}
/// 自动布局UIButton图标：自动居中、不拉伸
#define KButton_AutoLayoutImg(button,tImage)  {\
float tX = (button.frame.size.width - tImage.size.width/2) / 2.f;\
float tY = (button.frame.size.height - tImage.size.height/2) / 2.f;\
[self setImageEdgeInsets:UIEdgeInsetsMake(tY, tX, tY, tX)];\
}

/// 设置UIButton图标/选中/高亮，自动居中，不拉伸
#define KButton_SetImage(button,img,highlightedImg,selectImg)  {\
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
//#define UIButton_SetBackgroundImage(button,img,highlightedImg,selectImg)  {\




































#endif /* UIDefine_h */
