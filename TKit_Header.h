//
//  Header.h
//  APP
//
//  Created by LiuTao on 16/6/27.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//

#ifndef Header_h
#define Header_h

#ifdef DEBUG
#define DLog(fmt, ...) NSLog( (@"%s [Line %d] " fmt), __func__, __LINE__, ## __VA_ARGS__ );
#define LOG_DEALLOC     -(void)dealloc {     NSLog(@"%s",__func__); }
#else
#define DLog(...)
#define LOG_DEALLOC
#endif

// ****************************************** 数据常量 ******************************************

#ifdef DEBUG
#define S_HOST  @"127.0.0.1"
#define S_URL   @"127.0.0.1/path/client.php?type=1"
#else
#define S_HOST  @"127.0.0.1"
#define S_URL   @"127.0.0.1/path/client.php?type=1"
#endif

// ****************************************** UI常量 ******************************************


// ****************************************** 目录常量 ******************************************

/// --- 文件目录
#define kPathTemp                   NSTemporaryDirectory()
#define kPathDocument               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathLibrary                [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathCache                  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathBundle                 [[NSBundle mainBundle] bundlePath]
/// 路径是否存在
#define kPathExists(path)           [[NSFileManager defaultManager] fileExistsAtPath : path]

#define kPathInDirctory(n, dir)     [dir stringByAppendingPathComponent : n]
#define kPathInNSBundle(n, dir)     [[kPathBundle stringByAppendingPathComponent:dir ? dir : n] stringByAppendingPathComponent : dir ? n : nil]

/// 自动创建目录(多级目录)
#define kPathCreate(subPath, inDirectory) \
{ \
id directory = inDirectory; \
if (!directory) {directory = kPathDocument; } \
if (subPath) { \
if (![[NSFileManager defaultManager] fileExistsAtPath : [directory stringByAppendingPathComponent:subPath]]) { \
__autoreleasing NSError *error = nil; \
[[NSFileManager defaultManager] createDirectoryAtPath:[directory stringByAppendingPathComponent:subPath] withIntermediateDirectories:YES attributes:nil error:&error]; \
if (error) {NSLog(@"创建目录失败 %@", error); } \
else {NSLog(@"创建目录成功 %@", [directory stringByAppendingPathComponent:subPath])} \
} \
} \
}

// ****************************************** BLOCK常量 ******************************************

//// block
#define RELEASE_BLOCK(__x)              if (__x != NULL) {Block_release(__x); } \
__x = NULL
#define COPY_BLOCK(__dest, __src)       if (__src != NULL && __dest != __src) __dest = Block_copy(__src)
#define EXECUTE_BLOCK(A, ...)            if (A != NULL) {A(__VA_ARGS__); }

/// 无参数
typedef void (^VBlock)();
/// 一个参数(id)
typedef void (^TBlock)(id item);
/// 一个参数(int)
typedef void (^IBlock)(NSInteger index);
/// 一个参数(float)
typedef void (^FBlock)(float item);
/// 一个参数(bool)
typedef void (^BBlock)(BOOL isSuccess);
/// 一个参数(id) 返回(id)
typedef id (^RTBlock)(id item);
/// 一个参数(bool) 返回(bool)
typedef BOOL (^RBBlock)();

// ****************************************** 工具常量 ******************************************

/// System version utils
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/// 获取RGB颜色
#define kRGBA(r, g, b, a)       [UIColor colorWithRed : r / 255.0f green : g / 255.0f blue : b / 255.0f alpha : a]
#define kRGB(r, g, b) RGBA(r, g, b, 1.0f)

/// 竖屏
#define IsPortrait              ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)

/// nil 或者 NSNull
#define IsNilOrNull(_ref)       ( ( (_ref) == nil ) || ([(_ref) isEqual:[NSNull null]]) )

///大于等于7.0的ios版本
#define iOS7_OR_LATER       SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

///大于等于8.0的ios版本
#define iOS8_OR_LATER       SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

///iOS6时，导航VC中view的起始高度
#define YH_HEIGHT           (iOS7_OR_LATER ? 64 : 0)

///获取系统时间戳
#define getCurentTime       [NSString stringWithFormat : @"%ld", (long)[[NSDate date] timeIntervalSince1970]]

/// 属性字符串
#define k_AttributedString(f, c, t)     [[NSAttributedString alloc] initWithString : t attributes : @{NSFontAttributeName :[UIFont FontOfSize:f], NSForegroundColorAttributeName :[UIColor hexColor:c]}]

/// 可变属性字符串
#define k_MuAttriText(texts)            NSMutableAttributedString * muAttrStr = [NSMutableAttributedString new]; \
if (texts && [texts isKindOfClass:[NSArray class]]) { \
for (id attrStr in texts) { \
[muAttrStr appendAttributedString:attrStr];    } \
}

// ****************************************** 数据常量 ******************************************

/// NSUserDefaults 读写
#define K_UserDefault_Write(key,value)      [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define K_UserDefault_Read(key)             [[NSUserDefaults standardUserDefaults] objectForKey:key]

/// 有效的数组
#define k_Is_Valid_Arr(arr)    (arr && [arr isKindOfClass:[NSArray class]] && [arr count] > 0)

/// 当前的语言
#define l_CurrentLanguage           ([[NSLocale preferredLanguages] objectAtIndex:0])
/// 本地换字符获取
#define k_Localized(k)              [[NSBundle mainBundle] localizedStringForKey : (k)value : @"" table : nil]
/// 加载nib文件
#define k_Load_nib(n)               [[[NSBundle mainBundle] loadNibNamed:n owner:self options:nil] objectAtIndex : 0]
/// 浮点为0判断
#define k_Is_Zero(f)                (f > -0.00001f && f < 0.00001f)

/// 弧度转化
#define k_DegreesToRadians(degrees)              ( (degrees) * M_PI / 180.0 )
/// 弧度转化
#define k_RadiansToDegrees(radians)              ( (radians) * 180.0 / M_PI )

/// 判断字符串是否为空
#define k_Is_Empty(s)               (!s || [s isEqual:[NSNull null]] || [s isEqualToString:@""] || [s isEqualToString:@"null"])
/// 判断对象是否为空
#define k_Is_Nil(s)                 (!s || [s isEqual:[NSNull null]])
/// 去除特殊json 字符 (手动拼接json 字符串)
#define JsonStr(value)              [[value stringByReplacingOccurrencesOfString:@"\"" withString:@""] \
stringByReplacingOccurrencesOfString : @"\"" withString : @""]
///  "key":"value"
#define k_Json_Str(key, value)      [NSString stringWithFormat : @"\"%@\":\"%@\"", (key ? key : @""), (value ? JsonStr(value) : @"")]
///  "key":"value"
#define k_Json_Int(key, value)      [NSString stringWithFormat : @"\"%@\":%@", (key ? key : @""), (value ? value : @"0")]
///  "key":"value"
#define k_Json_StrEx(key, value)    [NSString stringWithFormat : @"\"%@\":%@", (key ? [key stringByReplacingPercentEscapesUsingEncoding : CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)] : @""), (value ? [value stringByReplacingPercentEscapesUsingEncoding : CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)] : @"")]


#define S_Null_Date     @"1970-01-01"
#define ALPHA           @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define NUMBERS         @"0123456789"
#define ALPHANUM        @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "
#define NUMBERSPERIOD   @"0123456789."

/// 金额显示 自动处理,单位:分  350 => 3.5
#define K_MONEY(money)          ([money intValue] % 10 != 0) ? [NSString stringWithFormat : @"%.2f", [money floatValue] / 100] : \
( ([money intValue] % 100 != 0) ? [NSString stringWithFormat : @"%.1f", [money floatValue] / 100] :                           \
[NSString stringWithFormat : @"%d", [money intValue] / 100] )
/// 金额显示 自动处理,单位:分  350 => 3.5元
#define K_MONEY_Y(money)        ([money intValue] % 10 != 0) ? [NSString stringWithFormat : @"%.2f 元", [money floatValue] / 100] : \
( ([money intValue] % 100 != 0) ? [NSString stringWithFormat : @"%.1f 元", [money floatValue] / 100] :                           \
[NSString stringWithFormat : @"%d 元", [money intValue] / 100] )
/// 金额显示 自动处理,单位:分  350 => ￥3.5
#define K_MONEY_S(money)        ([money intValue] % 10 != 0) ? [NSString stringWithFormat : @"￥%.2f", [money floatValue] / 100] : \
( ([money intValue] % 100 != 0) ? [NSString stringWithFormat : @"￥%.1f", [money floatValue] / 100] :                           \
[NSString stringWithFormat : @"￥%d", [money intValue] / 100] )
/// 金额显示 自动处理,单位:分  350 => ￥3.5元
#define K_MONEY_YS(money)       ([money intValue] % 10 != 0) ? [NSString stringWithFormat : @"￥%.2f 元", [money floatValue] / 100] : \
( ([money intValue] % 100 != 0) ? [NSString stringWithFormat : @"￥%.1f 元", [money floatValue] / 100] :                           \
[NSString stringWithFormat : @"￥%d 元", [money intValue] / 100] )

/// 距离显示 自动处理,单位:米  3470 => 3.47KM,  470 => 470M
#define K_JULI_KM(juli)         ( ([juli intValue] < 1000) ? [NSString stringWithFormat : @"%d M", [juli intValue]] :[NSString stringWithFormat:@"%.2f KM", [juli floatValue] / 1000] )
/// 距离显示 自动处理,单位:米  3470 => 3.47KM
#define K_JULI_K(juli)          ([NSString stringWithFormat:@"%.2f KM", [juli floatValue] / 1000])
/// 距离显示 自动处理,单位:米  3470 => 3470M
#define K_JULI_M(juli)          ([NSString stringWithFormat:@"%d 米", [juli intValue]])
/// 距离显示 自动处理,单位:米  3470 => 3.47千米,  470 => 470米
#define K_JULI_MI(juli)         ( ([juli intValue] < 1000) ? [NSString stringWithFormat : @"%d 米", [juli intValue]] :[NSString stringWithFormat:@"%.2f 千米", [juli floatValue] / 1000] )

/// 获取 时:分:秒
#define kGetTimes(time)         [NSString stringWithFormat:@"%02d:%02d:%02d",[time intValue]/3600,[time intValue]%3600/60,[time intValue]%60]
// ****************************************** 单例 ******************************************

/// 单例
#ifndef SINGLETON_FOR_CLASS

#import <objc/runtime.h>

#define SINGLETON_FOR_CLASS_HEADER(__CLASSNAME__)   \
\
+ (__CLASSNAME__ *)getInstance; \
+ (void)purgeGetInstance;


#define SINGLETON_FOR_CLASS(__CLASSNAME__)  \
\
static __CLASSNAME__ * _ ## __CLASSNAME__ ## _getInstance = nil; \
\
+ (__CLASSNAME__ *)getInstanceNoSynch   \
{   \
return (__CLASSNAME__ *)_ ## __CLASSNAME__ ## _getInstance; \
}   \
\
+ (__CLASSNAME__ *)getInstanceSynch \
{   \
@synchronized(self) {    \
if (nil == _ ## __CLASSNAME__ ## _getInstance) {  \
_ ## __CLASSNAME__ ## _getInstance = [[self alloc] init];   \
} \
else {  \
NSAssert2(1 == 0, @"SynthesizeSingleton: %@ ERROR: +(%@ *)getInstance method did not get swizzled.", self, self); \
}   \
}   \
return (__CLASSNAME__ *)_ ## __CLASSNAME__ ## _getInstance; \
}   \
\
+ (__CLASSNAME__ *)getInstance  \
{   \
return [self getInstanceSynch]; \
}   \
\
+ (id)allocWithZone:(NSZone *)zone  \
{   \
@synchronized(self) {    \
if (nil == _ ## __CLASSNAME__ ## _getInstance) { \
_ ## __CLASSNAME__ ## _getInstance = [super allocWithZone:zone];    \
if (nil != _ ## __CLASSNAME__ ## _getInstance) {  \
Method newGetInstanceMethod = class_getClassMethod( self, @selector(getInstanceNoSynch) );    \
method_setImplementation( class_getClassMethod( self, @selector(getInstance) ), method_getImplementation(newGetInstanceMethod) );   \
}   \
}   \
}   \
return _ ## __CLASSNAME__ ## _getInstance;  \
}   \
\
+ (void)purgeGetInstance    \
{   \
@synchronized(self) {    \
if (nil != _ ## __CLASSNAME__ ## _getInstance) {  \
Method newSharedInstanceMethod = class_getClassMethod( self, @selector(getInstanceSynch) );   \
method_setImplementation( class_getClassMethod( self, @selector(getInstance) ), method_getImplementation(newSharedInstanceMethod) );    \
_ ## __CLASSNAME__ ## _getInstance = nil;   \
}   \
}   \
}   \
\
- (id)copyWithZone:(NSZone *)zone   \
{   \
return self;    \
}

#endif


// ****************************************** 头文件 ******************************************



#endif /* Header_h */