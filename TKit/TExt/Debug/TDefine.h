//
//  Debug.h
//  TExt
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2014年 bill. All rights reserved.
//

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

struct Connect_cfg{
    /// 加密通讯
    BOOL req_encrypt;
    /// 调试_请求报文日志
    BOOL debug_log_req;
    /// 调试_返回报文日志
    BOOL debug_log_resp;
    /// 调试_返回报文日志(缓存)
    BOOL debug_log_resp_cache;
};
/// 通讯配置
typedef struct Connect_cfg Connect_cfg;

#pragma mark - -------- define ----------

#ifdef DEBUG
/// 自定义log输出   [正式发布不会输出]
  #define DLog(fmt, ...)                [TDefine DE_TLog : @"==> %s [line %d] " fmt, __FUNCTION__, __LINE__,  ## __VA_ARGS__]
/// 抛异常
  #define DAssert(con, des)             NSAssert( (con), (des) )
  #define k_Exception(name, _reason)    {@throw [NSException exceptionWithName:name reason:_reason userInfo:nil]; }
#else
  #if TARGET_IPHONE_SIMULATOR
/// 自定义log输出   [正式发布不会输出]
    #define DLog(fmt, ...)              [TDefine DE_TLog : @"==> %s [line %d] " fmt, __FUNCTION__, __LINE__,  ## __VA_ARGS__]
/// 抛异常
    #define DAssert(con, des)           NSAssert( (con), (des) )
    #define k_Exception(name, _reason)  {@throw [NSException exceptionWithName:name reason:_reason userInfo:nil]; }

  #else
    #define DLog(fmt, ...)
    #define DAssert(condition, desc)
    #define k_Exception(_name, _reason)
  #endif
#endif /* ifdef DEBUG */



//  ARC下performselector-may-cause-a-leak-because-its-selector-is-unknown警告
#define SuppressPerformSelectorLeakWarning(Stuff)                           \
do {                                                                    \
_Pragma("clang diagnostic push")                                    \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff;                                                              \
_Pragma("clang diagnostic pop")                                     \
} \
while (0)

#pragma mark - -------- 常量 ----------

#define Coordinate2DMake(lat, long) CLLocationCoordinate2DMake(lat, long)

#define s_File_Dir          @"file.bundle"
#define s_Image_Dir         @"images.bundle"

#define s_MainBundle_Path   [[NSBundle mainBundle] bundlePath]
#define s_Document_Path     [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define s_Tmp_Path          [[s_Document_Path stringByDeletingLastPathComponent] appendPath:@"tmp"]
#define s_Library_Path      [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define s_Caches_Path       [s_Library_Path stringByAppendingPathComponent:@"Caches"]


#pragma mark - -------- GCD ----------
#define Dispatch_Back_queue     dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define Dispatch_Main_queue     dispatch_get_main_queue()


// ------------------------------------------------------------------------
#pragma mark - -------- 本地转化 ----------
/// 屏幕方向是否为上、左、右
#define Is_UpPortrait(ori) ( (ori) == UIInterfaceOrientationMaskPortrait || (ori) == UIInterfaceOrientationLandscapeLeft || \
(ori) == UIInterfaceOrientationLandscapeRight )
#define Autoresizing_Size   (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)
#define Autoresizing_Local  (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | \
UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin)
#define Autoresizing_All    Autoresizing_Size | Autoresizing_Local

/// caches 路径
#define k_User_Caches(path, uid)    [NSString stringWithFormat : @"%@/%@/%@", s_Caches_Path, uid, path]
/// .app内路径
#define k_App_Path(n, d)            [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat : @"%@/%@", \
(!d ? @"" : [NSString stringWithFormat:@"/%@", d]), n]

#define l_CurrentLanguage           ([[NSLocale preferredLanguages] objectAtIndex:0])
/// 本地换字符获取
#define k_Localized(k)              [[NSBundle mainBundle] localizedStringForKey : (k)value : @"" table : nil]
/// 加载nib文件
#define k_Load_nib(n)               [[[NSBundle mainBundle] loadNibNamed:n owner:self options:nil] objectAtIndex : 0]
/// 浮点为0判断
#define k_Is_Zero(f)                (f > -0.00001f && f < 0.00001f)


/// 弧度转化
#define k_DegreesToRadians(degrees)              ( (degrees) *M_PI / 180.0 )
/// 弧度转化
#define k_RadiansToDegrees(radians)              ( (radians) * 180.0 / M_PI )
/// 拼接字符串
#define k_Str_Fmt(f, ...)           [NSString stringWithFormat : (@"" f), ## __VA_ARGS__]
/// 判断字符串是否为空
#define k_Is_Empty(s)               (!s || [s isEqual:[NSNull null]] || [s isEqualToString:@""] || [s isEqualToString:@"null"])
/// 判断对象是否为空
#define k_Is_Nil(s)                 (!s || [s isEqual:[NSNull null]])
/// 判断指针是否为空 是否为NSNull
#define k_IsNull(p)                 (!p || [p isEqual:[NSNull null]])
/// 去除特殊json 字符 (手动拼接json 字符串)
#define JsonStr(value)              [[value stringByReplacingOccurrencesOfString:@"\"" withString:@""] \
stringByReplacingOccurrencesOfString : @"\"" withString : @""]
///  "key":"value"
#define k_Json_Str(key, value)      [NSString stringWithFormat : @"\"%@\":\"%@\"", (key ? key : @""), (value ? JsonStr(value) : @"")]
///  "key":"value"
#define k_Json_Int(key, value)      [NSString stringWithFormat : @"\"%@\":%@", (key ? key : @""), (value ? value : @"0")]
///  "key":"value"
#define k_Json_StrEx(key, value)    [NSString stringWithFormat : @"\"%@\":%@", (key ? [key stringByReplacingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)] : @""), (value ? [value stringByReplacingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)] : @"")]


/// 颜色
#define k_RGBCOLOR(r, g, b)     [UIColor colorWithRed : r / 255.0 green : g / 255.0 blue : b / 255.0 alpha : 1]
#define k_RGBACOLOR(r, g, b, a) [UIColor colorWithRed : r / 255.0 green : g / 255.0 blue : b / 255.0 alpha : a]
#define k_HSVCOLOR(h, s, v)     [UIColor colorWithHue : h saturation : s value : v alpha : 1]
#define k_HSVACOLOR(h, s, v, a) [UIColor colorWithHue : h saturation : s value : v alpha : a]

#define k_Invalidate_Timer(REF) {[REF invalidate]; REF = nil; }
#define is_arc              __has_feature(objc_arc)

#pragma mark - -------- debug ----------


/// 主线程 异步执行
#define GCD_Main_async(block)       dispatch_async(dispatch_get_main_queue(), (block))
/// 主线程 异步执行
#define GCD_Main_sync(block)       dispatch_sync(dispatch_get_main_queue(), (block))

/// 后台线程 异步执行
#define GCD_Back_async(block)       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), (block))

/// 后台线程 异步执行(优先级:高)
#define GCD_Back_async_high(block)  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), (block))

/// 后台线程 异步执行(优先级:低)
#define GCD_Back_async_low(block)   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), (block))

/// 单例执行
#define GCD_Instance( instanceblock)\
static dispatch_once_t global_onceToken;\{dispatch_once(&global_onceToken, instanceblock)}


/// 版本号
#define s_clientVer     ([NSString stringWithFormat:@"%@.%@", [(__bridge NSDictionary *)CFBundleGetInfoDictionary( CFBundleGetMainBundle() ) objectForKey:@"CFBundleShortVersionString"], [(__bridge NSDictionary *)CFBundleGetInfoDictionary( CFBundleGetMainBundle() ) objectForKey:@"CFBundleVersion"]])


/// 根据iphone5 的 尺寸比例 算出实际尺寸
#define f_i5real(f)              ( ( (int)( (f_Device_w * ((f)/320.f)) * 2 ) ) / 2.f )
/// 根据iphone5 的 尺寸比例 算出实际尺寸
#define f_i6real(f)              ( ( (int)( (f_Device_w * ((f)/375.f)) * 2 ) ) / 2.f )


/// 
#define auto_scale                          1
/// 根据比例 处理系统已经拉伸过的元素
#define f_auto_scale(f)                     (f*([UIScreen mainScreen].scale>2?1.1:1))


#define _bself  __block typeof(self) bSelf = self;

#ifndef SINGLETON_FOR_CLASS

#import <objc/runtime.h>

#define SINGLETON_FOR_CLASS_HEADER(__CLASSNAME__)	\
\
+ (__CLASSNAME__*) getInstance;	\
+ (void) purgeGetInstance;


#define SINGLETON_FOR_CLASS(__CLASSNAME__)	\
\
static __CLASSNAME__* _##__CLASSNAME__##_getInstance = nil;	\
\
+ (__CLASSNAME__*) getInstanceNoSynch	\
{	\
    return (__CLASSNAME__*) _##__CLASSNAME__##_getInstance;	\
}	\
\
+ (__CLASSNAME__*) getInstanceSynch	\
{	\
    @synchronized(self){	\
        if(nil == _##__CLASSNAME__##_getInstance){	\
            _##__CLASSNAME__##_getInstance = [[self alloc] init];	\
        }else{	\
            NSAssert2(1==0, @"SynthesizeSingleton: %@ ERROR: +(%@ *)getInstance method did not get swizzled.", self, self);	\
        }	\
    }	\
    return (__CLASSNAME__*) _##__CLASSNAME__##_getInstance;	\
}	\
\
+ (__CLASSNAME__*) getInstance	\
{	\
    return [self getInstanceSynch]; \
}	\
\
+ (id)allocWithZone:(NSZone*) zone	\
{	\
    @synchronized(self){	\
        if (nil == _##__CLASSNAME__##_getInstance){	\
            _##__CLASSNAME__##_getInstance = [super allocWithZone:zone];	\
            if(nil != _##__CLASSNAME__##_getInstance){	\
                Method newGetInstanceMethod = class_getClassMethod(self, @selector(getInstanceNoSynch));	\
                method_setImplementation(class_getClassMethod(self, @selector(getInstance)), method_getImplementation(newGetInstanceMethod));	\
            }	\
        }	\
    }	\
    return _##__CLASSNAME__##_getInstance;	\
}	\
\
+ (void)purgeGetInstance	\
{	\
    @synchronized(self){	\
        if(nil != _##__CLASSNAME__##_getInstance){	\
            Method newSharedInstanceMethod = class_getClassMethod(self, @selector(getInstanceSynch));	\
            method_setImplementation(class_getClassMethod(self, @selector(getInstance)), method_getImplementation(newSharedInstanceMethod));	\
            _##__CLASSNAME__##_getInstance = nil;	\
        }	\
    }	\
}	\
\
- (id)copyWithZone:(NSZone *)zone	\
{	\
    return self;	\
}

#endif


@interface TDefine : NSObject

/// 是否加密传输报文
#define DE_ENCRYPT_REQ  1//[TDefine getInstance].req_cfg.req_encrypt
/// 是否打出请求报文
#define DE_LOG_REQ      1//[TDefine getInstance].req_cfg.debug_log_req
/// 是否打出返回报文
#define DE_LOG_RESP     1//[TDefine getInstance].req_cfg.debug_log_resp
/// 是否打出本地缓存报文
#define DE_LOG_RESP_CACHE     1//[TDefine getInstance].req_cfg.debug_log_resp_cache

/// 通讯配置
@property (nonatomic, assign) Connect_cfg req_cfg;

+ (void)DE_TLog:(NSString *)fmt, ...;

SINGLETON_FOR_CLASS_HEADER(TDefine);

@end
