//
//  UIFontEx.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "UIFontEx.h"
#import "TExt.h"

@implementation UIFont (TExt)

static NSString* kCurrFontName;
+(void) registerFontName:(NSString*)fontName
{
    kCurrFontName = fontName;
}

+ (UIFont *)FontOfSize:(CGFloat)f
{
    if (k_Is_Empty(kCurrFontName)) {
        return [UIFont systemFontOfSize:f];
    }
    return [UIFont fontWithName:kCurrFontName size:f];
}

//+ (void)logAllFont
//{
//    NSArray *familyNames = [UIFont familyNames];
//
//    NSArray *fontNames;
//
//    NSInteger indFamily, indFont;
//
//    for (indFamily = 0; indFamily < [familyNames count]; ++indFamily) {
//        DLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        fontNames = [[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
//
//        for (indFont = 0; indFont < [fontNames count]; ++indFont) {
//            DLog(@"Font name: %@", [fontNames objectAtIndex:indFont]);
//        }
//    }
//}


@end