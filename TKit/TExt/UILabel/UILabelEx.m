//
//  UILabelEx
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#define f_min_label_point 2.f

#import "UILabelEx.h"
#import "TExt.h"

@implementation UILabel (TExt)
@dynamic minFontSizeForScale;
@dynamic muAttriTexts;

///// 设置 内容:NSString, 字体:float, 颜色:UIColor || hexColor
- (void)dosetText:(NSString *)text font:(float)font color:(id)color
{
    if (text) {
        self.text = [text description];
    }

    if (font > 0) {
#if auto_scale
        self.font = [UIFont FontOfSize:f_auto_scale(font)];
#else
        self.font = [UIFont FontOfSize:font];
#endif
    }

    if ([color isKindOfClass:[UIColor class]]) {
        self.textColor = color;
    }else if ([color isKindOfClass:[NSString class]]){
        self.textColor = [UIColor hexColor:color];
    }
}


#pragma mark - -------- size-to-fit ----------

/// 计算取得实际size
- (CGSize)realSize
{
    return [self sizeThatFits:self.size];
}

/// 自动设置高度 (置顶对齐) (realsize.height <= self.height)
- (void)dosizeToFitEx
{
    // 如果 高度为0 根据行数 和字体所占像素数 自动设置高度
    if ( (self.height < f_min_label_point) && (self.numberOfLines != 0) ) {
        self.height = self.font.pointSize * self.numberOfLines + self.numberOfLines;
    }
    CGSize fitSize = [self sizeThatFits:self.size];
    if (fitSize.height > 0 && fitSize.height < self.height) {
        self.height = fitSize.height;
    }
}

/// 自动设置高度 (置顶对齐) (realsize.height >= self.height)
- (void)dosizeToFillEx
{
    // 如果 高度为0 根据行数 和字体所占像素数 自动设置高度
    if ( (self.height < f_min_label_point) && (self.numberOfLines != 0) ) {
        self.height = self.font.pointSize * self.numberOfLines + self.numberOfLines;
    }
    CGSize fitSize = [self sizeThatFits:CGSizeMake(self.width, f_Device_h)];
    if (fitSize.height > self.height) {
        self.height = fitSize.height;
    }
}

/// 自动设置宽度 (左对齐) (realsize.width >= self.width)
- (void)doAlignmentLeft
{
    if ( (self.width < f_min_label_point) ) {
        self.width = f_Device_w;
    }

    CGSize fitSize = [self sizeThatFits:CGSizeMake(self.width, self.height)];
    if (fitSize.width > 0 && fitSize.width < self.width) {
        self.width = fitSize.width;
    }
}

- (void)setMinFontSizeForScale:(CGFloat)minFontSizeForScale
{
    self.minimumScaleFactor = minFontSizeForScale;
}

-(void) setMuAttriTexts:(NSArray *)muAttriTexts
{
    NSMutableAttributedString* attriString = [NSMutableAttributedString new];
    if (muAttriTexts && [muAttriTexts isKindOfClass:[NSArray class]]) {
        for (id attrText in muAttriTexts) {
            [attriString appendAttributedString:attrText];
        }
    }
    self.attributedText = attriString;
}



/// 价格增加横线
-(void) addCenterLine
{
    UILabel* tLabel = self;
    if (!tLabel.text) {return;}
    
    CGSize size = tLabel.realSize;
    UIView* tLine = [self viewWithTag:3286];
    if (!tLine) {
        tLine = [UIView newView:CGRectMake(2, tLabel.height/2-0.5, size.width, 1) bgColor:tLabel.textColor];
        tLine.tag = 3286;
        [tLabel addSubview:tLine];
    }
    if (tLabel.textAlignment == NSTextAlignmentCenter) {
        tLine.left = (tLabel.width-size.width)/2-2;
    }else if (tLabel.textAlignment == NSTextAlignmentRight){
        tLine.right = tLabel.width-2;
    }
    
}

-(void) setLineHeight:(float) lineHeight
{
    if (!self.text) {
        return;
    }
    UILabel* _LAB_ = self;
    
    _LAB_.numberOfLines = 0;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //    style.lineSpacing = lineHeight;
    style.alignment = self.textAlignment;
    style.minimumLineHeight = lineHeight-1;
    style.maximumLineHeight = lineHeight;
    
    id attributedCfg = @{NSFontAttributeName: _LAB_.font,
                         NSForegroundColorAttributeName: _LAB_.textColor,
                         NSParagraphStyleAttributeName: style,
                         };
    NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:_LAB_.text attributes:attributedCfg];
    _LAB_.attributedText = attributedText;
}


/// 价格增加边框
-(void) addBorder
{
    UILabel* tLabel = self;
    if (!tLabel.text) {return;}
    
    tLabel.clipsToBounds = NO;
    CGSize size = CGSizeMake(tLabel.realSize.width+8, tLabel.realSize.height+5);
    UIView* tBorder = [UIView newView:CGRectMake(tLabel.width-size.width+4, tLabel.height/2-size.height/2, size.width, size.height) bgColor:[UIColor clearColor]];
    [tBorder setBorderWidth:1 coror:tLabel.textColor];
    
    [tLabel addSubview:tBorder];
}

#pragma mark - -------- NEW ----------

+ (id)newLabel:(CGRect)frame
{
    id tLabel = nil;

    tLabel = [[[self class] alloc] init];
    [tLabel setFrame:frame];
    [tLabel setBackgroundColor:[UIColor clearColor]];
    return tLabel;
}

@end