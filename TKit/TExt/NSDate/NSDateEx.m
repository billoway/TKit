//
//  NSDateEx
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "NSDateEx.h"
#import "NSStringEx.h"

@implementation NSDate (Ext)

#pragma mark - -------- Date => 时间戳 ----------

/// Date => 时间戳   fmt:指定格式
- (NSString *)stringWithFmt:(TDateFmtType)fmt
{
    NSDateFormatter *tDateFormatter = [NSDateFormatter new];

    [tDateFormatter setDateFormat:[NSDate fmtString:fmt]];
    NSString *dateStr = [tDateFormatter stringFromDate:self];
    return dateStr;
}

/// Date => 时间戳   格式:TDateFmt 纯日期
- (NSString *)stringWithFmt
{
    NSDateFormatter *tDateFormatter = [NSDateFormatter new];

    [tDateFormatter setDateFormat:[NSDate fmtString:0]];
    NSString *dateStr = [tDateFormatter stringFromDate:self];
    return dateStr;
}

/// Date => 时间戳 月份
- (NSString *)monthCn
{
    NSArray *moths = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"十一", @"十二"];

    return [[moths objectAtIndex:self.month] appendStr:@"月"];
}

/// Date => 时间戳 月份
- (NSString *)monthEn
{
    return [[NSString stringByInt:(int)self.month] appendStr:@"月"];
}

/// Date => 时间戳 星期x
- (NSString *)weekDay
{
    return [self weekDay:@"星期"];
}

/// Date => 时间戳 front:前缀 周&星期
- (NSString *)weekDay:(NSString *)front
{
    NSArray *weeks = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];

    if (!front) {
        front = @"星期";
    }

    return [front appendStr:[weeks objectAtIndex:self.weekday]];
}

+ (NSString *)fmtString:(TDateFmtType)fmt
{
    NSArray *fmts = @[@"yyyy-MM-dd",
        @"yyyy-MM-dd HH:mm:SS",
        @"yyyy-MM-dd HH:mm",
        @"MM-dd HH:mm",
        @"yyyy-MM",
        @"yyyyMMddHHmmSS",
        @"yyyyMMddHHmm",
        @"yyyyMMddHH",
        @"yyyyMMdd",
        @"HHmmSS",
        @"MM-dd HH:mm:SS",
        @"HH:mm:SS",
        @"HH:mm",
        @"yyyy年MM月dd日",
        @"yyyy年MM月",
        @"MM月dd日"
        ];

    if ((fmt > fmts.count) || (fmt < 0)) {
        fmt = 0;
    }

    return [fmts objectAtIndex:fmt];
}

@end

@implementation NSString (date)

/// 时间戳 => Date 当前日期  fmt:指定格式
- (NSDate *)dateWithFmt:(TDateFmtType)fmt
{
    NSDateFormatter *tDateFormatter = [NSDateFormatter new];

    [tDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [tDateFormatter setDateFormat:[NSDate fmtString:fmt]];
    return [tDateFormatter dateFromString:self];
}

/// 时间戳 => Date 当前日期  格式:TDateFmt
- (NSDate *)dateWithFmt
{
    return [self dateWithFmt:TDateFmt];
}

@end