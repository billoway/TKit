//
//  NSStringEx
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "NSString+parse.h"
#import "NSString+MD5.h"

@interface NSString (Ext)

#pragma mark - -------- delete ----------

/// 删除字符 删除开头和结尾空格
- (NSString *)deleteTriSpace;

/// 删除字符 删除空格
- (NSString *)deleteSpace;

- (NSString *)delete_nbsp;

/// 删除字符 删除空格和换行
- (NSString *)deleteSpaceAndLine;

/// 删除字符 删除标点符号
- (NSString *)deleteSpecialChar;

/// 删除指定字符串 regex:正则表达式
- (NSString *)deleteByRegex:(NSString *)regex;

/// 删除指定字符串 target:指定字符串
- (NSString *)deleteStr:(NSString *)target;

/// 删除不匹配的字符串 target:指定字符串
- (NSString *)deleteUnMatchStr:(NSString *)target;

#pragma mark - -------- new string by sub ----------

/// 截取字符串 指定结尾下标
- (NSString *)subTo:(NSUInteger)to;

/// 截取字符串 指定开始下标
- (NSString *)subFrom:(NSUInteger)from;

/// 截取字符串 截取为日期 (yyyy-MM-dd )
- (NSString *)subToDate;

/// 截取字符串 截取为数组
- (NSArray *)subToArrBy:(NSString *)sub;

#pragma mark - -------- new string by init ----------

/// int 初始化字符串
+ (NSString *)stringByInt:(int)t;

/// float 初始化字符串
+ (NSString *)stringByFloat:(float)f;

/// id 初始化字符串
+ (NSString *)stringById:(id)param;

/// 字符串 转 number
- (NSNumber *)numberValue;

/// 拼接字符串 追加字符串
- (NSString *)appendFmt:(NSString *)format, ...;

/// 拼接字符串 追加字符串
- (NSString *)appendStr:(NSString *)str;

/// 拼接字符串 追加路径
- (NSString *)appendPath:(NSString *)str;

/// 获取指定位置的 字符
- (NSString *)strAtIndex:(NSInteger)index;

/// 生成uuid
+ (NSString *)uuidWithPrefix:(NSString *)prefix;

/// URL 标准转码
- (NSString *)encodeURL;

#pragma mark - -------- is xxx string ----------

/// 是否有效的日期字符串
- (BOOL)isValidDate;

/// 是否包含特殊字符
- (BOOL)isContainSpecialChar;

/// 是否包含数字
- (BOOL)isContainNumber;

/// 是否纯数字
- (BOOL)isNumber;

/// 是否包含指定字符串
- (BOOL)isContain:(NSString *)str;

/// 是否包含指定字符串 regex:正则表达式
- (BOOL)isByRegex:(NSString *)regex;

/// 是否有效手机号码 [大陆手机]
- (BOOL)isMobileNumber;

@end

#pragma mark - -------- NSMutableString ----------

@interface NSMutableString (add)

/// 拼接字符串 追加字符串
- (void)addStr:(NSString *)str;
/// 拼接字符串 追加CDATA字符串
- (void)addCDATA:(NSString *)str;

@end

#define s_Null_Date     @"1970-01-01"
#define ALPHA           @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define NUMBERS         @"0123456789"
#define ALPHANUM        @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "
#define NUMBERSPERIOD   @"0123456789."

#define K_MONEY(money)          ([money intValue] % 10 != 0) ? [NSString stringWithFormat:@"%.2f", [money floatValue] / 100] : \
    ( ([money intValue] % 100 != 0) ? [NSString stringWithFormat:@"%.1f", [money floatValue] / 100] :                           \
      [NSString stringWithFormat:@"%d", [money intValue] / 100] )

#define K_MONEY_Y(money)        ([money intValue] % 10 != 0) ? [NSString stringWithFormat:@"%.2f 元", [money floatValue] / 100] : \
    ( ([money intValue] % 100 != 0) ? [NSString stringWithFormat:@"%.1f 元", [money floatValue] / 100] :                           \
      [NSString stringWithFormat:@"%d 元", [money intValue] / 100] )

#define K_MONEY_S(money)        ([money intValue] % 10 != 0) ? [NSString stringWithFormat:@"￥%.2f", [money floatValue] / 100] : \
    ( ([money intValue] % 100 != 0) ? [NSString stringWithFormat:@"￥%.1f", [money floatValue] / 100] :                           \
      [NSString stringWithFormat:@"￥%d", [money intValue] / 100] )

#define K_MONEY_YS(money)       ([money intValue] % 10 != 0) ? [NSString stringWithFormat:@"￥%.2f 元", [money floatValue] / 100] : \
    ( ([money intValue] % 100 != 0) ? [NSString stringWithFormat:@"￥%.1f 元", [money floatValue] / 100] :                           \
      [NSString stringWithFormat:@"￥%d 元", [money intValue] / 100] )


/********   正则表达式 参考
 *  正则表达式30分钟入门教程:  http://deerchao.net/tutorials/regex/regex.htm
 *  正则表达式语言 - 快速参考: http://msdn.microsoft.com/zh-cn/library/az24scfc.aspx
 *
 *
 *   网址（URL）    [a-zA-z]+://[^\s]*
 *
 *   IP地址(IP Address)   ((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)
 *
 *   电子邮件(Email)    \w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*
 *
 *   QQ号码   [1-9]\d{4,}
 *
 *   HTML标记(包含内容或自闭合)   <(.*)(.*)>.*<\/\1>|<(.*) \/>
 *
 *   密码(同时包含数字/大写/小写/标点，8位以上)    (?=^.{8,}$)(?=.*\d)(?=.*\W+)(?=.*[A-Z])(?=.*[a-z])(?!.*\n).*$
 *
 *   日期(年-月-日)  (\d{4}|\d{2})-((1[0-2])|(0?[1-9]))-(([12][0-9])|(3[01])|(0?[1-9]))
 *
 *   日期(月/日/年)  ((1[0-2])|(0?[1-9]))/(([12][0-9])|(3[01])|(0?[1-9]))/(\d{4}|\d{2})
 *
 *   时间(小时:分钟, 24小时制)  ((1|0?)[0-9]|2[0-3]):([0-5][0-9])
 *
 *   汉字(字符) [\u4e00-\u9fa5]
 *
 *   中文及全角标点符号(字符)  [\u3000-\u301e\ufe10-\ufe19\ufe30-\ufe44\ufe50-\ufe6b\uff01-\uffee]
 *
 *   中国大陆固定电话号码  (\d{4}-|\d{3}-)?(\d{8}|\d{7})
 *
 *   中国大陆手机号码  1\d{10}
 *
 *   中国大陆邮政编码  [1-9]\d{5}
 *
 *   中国大陆身份证号(15位或18位)  \d{15}(\d\d[0-9xX])?
 *
 *   非负整数(正整数或零)  \d+
 *
 *   正整数  [0-9]*[1-9][0-9]*
 *
 *   负整数  -[0-9]*[1-9][0-9]*
 *
 *   整数  -?\d+
 *
 *   小数  (-?\d+)(\.\d+)?
 *
 *   不包含abc的单词  \b((?!abc)\w)+\b
 *
 ********/