//
//  UIButtonEx.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "UIButtonEx.h"
#import "TExt.h"

@implementation UIButton (TExt)
@dynamic imageOrigin;
@dynamic titleOrigin;

/// 设置 标题, 字体, 颜色
- (void)dosetTitle:(NSString *)title font:(float)font color:(id)color;
{
    [self setTitle:title forState:UIControlStateNormal];
    if ([color isKindOfClass:[NSString class]]) {
        [self setTitleColor:[UIColor hexColor:color] forState:UIControlStateNormal];
    }else if ([color isKindOfClass:[UIColor class]]){
        [self setTitleColor:color forState:UIControlStateNormal];
    }

#if auto_scale
    [self.titleLabel setFont:[UIFont FontOfSize:f_auto_scale(font)]];
#else
    [self.titleLabel setFont:[UIFont FontOfSize:font]];
#endif
}

/// 设置 标题, 字体, 颜色
- (void)dosetTitle:(NSString *)title fontSize:(float)font colorHex:(id)color;
{
    [self setTitle:title forState:UIControlStateNormal];
    
    if ([color isKindOfClass:[NSString class]]) {
        [self setTitleColor:[UIColor hexColor:color] forState:UIControlStateNormal];
    }else if ([color isKindOfClass:[UIColor class]]){
        [self setTitleColor:color forState:UIControlStateNormal];
    }

#if auto_scale
    [self.titleLabel setFont:[UIFont FontOfSize:f_auto_scale(font)]];
#else
    [self.titleLabel setFont:[UIFont FontOfSize:font]];
#endif
}

/// 设置 标题 ==> 选中, 高亮
- (void)dosetTitle:(NSString *)title selectTitle:(NSString *)sTitle highlightedTitle:(NSString *)hTitle;
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:sTitle forState:UIControlStateSelected];
    [self setTitle:hTitle forState:UIControlStateHighlighted];
}

/// 设置 标题颜色 ==> 选中, 高亮
- (void)dosetColor:(UIColor *)color selectColor:(UIColor *)sColor highlightedColor:(UIColor *)hColor;
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:sColor forState:UIControlStateSelected];
    [self setTitleColor:hColor forState:UIControlStateHighlighted];
}

/// 设置 图片 UIImage or imgName => [UIImage getImage:imgName]
- (void)dosetImg:(id)img selectImg:(id)sImg highlightedImg:(id)hImg
{
    if ([img isKindOfClass:[UIImage class]]) {
        [self setImage:img forState:UIControlStateNormal];
    }
    else if ([img isKindOfClass:[NSString class]]) {
        [self setImage:[UIImage getImage:img] forState:UIControlStateNormal];
    }
    [self autoLayoutBtnImage:[self imageForState:UIControlStateNormal]];

    if ([sImg isKindOfClass:[UIImage class]]) {
        [self setImage:sImg forState:UIControlStateSelected];
    }
    else if ([sImg isKindOfClass:[NSString class]]) {
        [self setImage:[UIImage getImage:sImg] forState:UIControlStateSelected];
    }
    self.adjustsImageWhenHighlighted = sImg == nil;


    if ([hImg isKindOfClass:[UIImage class]]) {
        [self setImage:hImg forState:UIControlStateHighlighted];
    }
    else if ([hImg isKindOfClass:[NSString class]]) {
        [self setImage:[UIImage getImage:hImg] forState:UIControlStateHighlighted];
    }
}


/// 设置 背景图片 UIImage or imgName => [UIImage getImage:imgName]
- (void)dosetBgImg:(id)img selectImg:(id)sImg highlightedImg:(id)hImg
{
    if ([img isKindOfClass:[UIImage class]]) {
        [self setBackgroundImage:img forState:UIControlStateNormal];
    }
    else if ([img isKindOfClass:[NSString class]]) {
        [self setBackgroundImage:[UIImage getImage:img] forState:UIControlStateNormal];
    }

    if ([sImg isKindOfClass:[UIImage class]]) {
        [self setBackgroundImage:sImg forState:UIControlStateSelected];
    }
    else if ([sImg isKindOfClass:[NSString class]]) {
        [self setBackgroundImage:[UIImage getImage:sImg] forState:UIControlStateSelected];
    }
    self.adjustsImageWhenHighlighted = sImg == nil;


    if ([hImg isKindOfClass:[UIImage class]]) {
        [self setBackgroundImage:hImg forState:UIControlStateHighlighted];
    }
    else if ([hImg isKindOfClass:[NSString class]]) {
        [self setBackgroundImage:[UIImage getImage:hImg] forState:UIControlStateHighlighted];
    }
}

/// 设置 点击相应, target, tag
- (void)dosetClick:(SEL)click target:(id)target tag:(NSInteger)tag;
{
    [self addTarget:target action:click forControlEvents:UIControlEventTouchUpInside];
    self.tag = tag;
}

- (void)setImageOrigin:(CGPoint)origin
{
    UIImage *img = [self currentImage];
    if (!img || ![img isKindOfClass:[UIImage class]]) {
        return;
    }

    if (origin.y < 1) {
        origin.y = (self.height - img.height) / 2.f;
    }
    if (origin.x < 1) {
        origin.x = (self.width - img.width) / 2.f;
    }

    int tmpy = origin.y;
    int tmpx = origin.x;

    UIEdgeInsets insets = UIEdgeInsetsMake( tmpy, tmpx, self.height - (tmpy + img.height), self.width - (tmpx + img.width) );
    [self setImageEdgeInsets:insets];
}

- (void)setTitleOrigin:(CGPoint)origin
{
    NSString *title = [self currentTitle];
    if ( k_Is_Empty(title) ) {
        return;
    }

    if (origin.y < 1) {
        origin.y = (self.height - self.titleLabel.realSize.height)/2;
    }
    
    if (origin.x < 1) {
        origin.x = (self.width - self.titleLabel.realSize.width)/2;
    }
    
    self.titleLabel.origin = origin;
}

#pragma mark - -------- NEW ----------

+ (id)newButton:(CGRect)frame
{
    id tButton = nil;

    tButton = [[self class] buttonWithType:UIButtonTypeCustom];
    [tButton setFrame:frame];

    return tButton;
}

#pragma mark - -------- private ----------

- (void)autoLayoutBtnImage:(UIImage *)tImage
{
    float tX = (self.width - tImage.width) / 2.f;
    float tY = (self.height - tImage.height) / 2.f;

    [self setImageEdgeInsets:UIEdgeInsetsMake(tY, tX, tY, tX)];
}

@end