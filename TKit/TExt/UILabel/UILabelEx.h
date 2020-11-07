//
//  UILabelEx
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//


@interface UILabel (TExt)

/// 最小的字体尺寸
@property (nonatomic, assign) CGFloat minFontSizeForScale;
/// 属性字符串: 数组
@property (nonatomic, strong) NSArray* muAttriTexts;

/// 计算取得实际size (self.width为0 取f_Device_w)
@property (nonatomic, assign, readonly) CGSize realSize;

/// new label
+ (id)newLabel:(CGRect)frame;

///// 设置 内容, 字体, 颜色 (为 nil 时不设置)
- (void)dosetText:(NSString *)text font:(float)font color:(id)color;

/// 自动设置高度 (置顶对齐) (realsize.height <= self.height)
- (void)dosizeToFitEx;
/// 自动设置高度 (置顶对齐) (realsize.height >= self.height)
- (void)dosizeToFillEx;
/// 自动设置宽度 (左对齐) (realsize.width >= self.width)
- (void)doAlignmentLeft;
/// 自动设置宽度 (左对齐) (realsize.width >= self.width)
- (void)doAlignmentLeftInWidth:(float)width;

/// 价格增加横线
-(void) addCenterLine;

/// 价格增加边框
-(void) addBorder;


/// 设置行高
@property (nonatomic, assign) float lineHeight;

@end

#define k_AttriText(f,c,t)  [[NSAttributedString alloc] initWithString:t attributes:@{NSFontAttributeName: [UIFont FontOfSize:f],NSForegroundColorAttributeName: [UIColor hexColor:c]}]

#define _ShadowSize CGSizeMake(0, 1)


#define K_DELETE_LINE(_LAB_) {\
id attributedCfg = @{NSFontAttributeName: _LAB_.font,\
NSForegroundColorAttributeName: _LAB_.textColor,\
NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),\
NSStrikethroughColorAttributeName: _LAB_.textColor,\
};\
NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:_LAB_.text attributes:attributedCfg];\
_LAB_.attributedText = attributedText;\
}