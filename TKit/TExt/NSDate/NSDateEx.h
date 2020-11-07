//
//  NSDateEx
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#define CurrDate [NSDate date]

typedef NS_OPTIONS (NSInteger, TDateFmtType) {
    /// fmt => yyyy-MM-dd
    TDateFmt = 0,
    /// fmt => yyyy-MM-dd HH:mm:SS
    TDateFmt1,
    /// fmt => yyyy-MM-dd HH:mm
    TDateFmt2,
    /// fmt => MM-dd HH:mm
    TDateFmt3,
    /// fmt => yyyy-MM
    TDateFmt4,
    /// fmt => yyyyMMddHHmmSS
    TDateFmt5,
    /// fmt => yyyyMMddHHmm
    TDateFmt6,
    /// fmt => yyyyMMddHH
    TDateFmt7,
    /// fmt => yyyyMMdd
    TDateFmt8,
    /// fmt => HHmmSS
    TDateFmt9,
    /// fmt => MM-dd HH:mm:SS
    TDateFmt10,
    /// fmt => HH:mm:SS
    TDateFmt11,
    /// fmt => HH:mm
    TDateFmt12,
    /// fmt => yyyy年MM月dd日
    TDateFmt13,
    /// fmt => yyyy年MM月
    TDateFmt14,
    /// fmt => MM月dd日
    TDateFmt15
};

//#ifdef TKIT_LIB
//#import "../../Externals/NSDate-Extensions/NSDate-Utilities.h"
//
//#else
#import "NSDate-Utilities.h"

//#endif


@interface NSDate (Ext)

#pragma mark - -------- Date => 时间戳 ----------

/// Date => 时间戳   fmt:指定格式
- (NSString *)stringWithFmt:(TDateFmtType)fmt;
/// Date => 时间戳   格式:TDateFmt
- (NSString *)stringWithFmt;
/// Date => 时间戳 月份
- (NSString *)monthCn;
/// Date => 时间戳 月份
- (NSString *)monthEn;
/// Date => 时间戳 星期x
- (NSString *)weekDay;
/// Date => 时间戳 front:前缀 周&星期
- (NSString *)weekDay:(NSString *)front;

@end
@interface NSString (date)

#pragma mark - -------- 时间戳 => Date ----------

/// 时间戳 => Date 当前日期  fmt:指定格式
- (NSDate *)dateWithFmt:(TDateFmtType)fmt;
/// 时间戳 => Date 当前日期  格式:TDateFmt
- (NSDate *)dateWithFmt;

@end