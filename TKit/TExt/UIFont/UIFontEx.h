//
//  UIFontEx.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

@interface UIFont (TExt)

/// 预设字体
+(void) registerFontName:(NSString*)fontName;
/// 无预设字体时取系统字体
+ (UIFont *)FontOfSize:(CGFloat)f;

//+ (void)logAllFont;

@end