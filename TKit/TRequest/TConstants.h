//
//  Constants
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#define     __USER      @"xxxx"
#define     USER_TOKEN  @"USER_TOKEN"

#define     s_Rsp_Root_Dir(pri) [TConstants createDirectory : @"rsp" isPrivate : pri]


#import "TExt.h"

@class Reachability, LoginModel;
@interface TConstants : NSObject

#pragma mark - -------- user info ----------

/// 登录ID (登录账号)
@property (nonatomic, strong)   NSString *_loginId;
/// 授权ID (登录,并授权成功后,用户唯一标识, 本地、内存缓存标识)
@property (nonatomic, strong)   NSString *_userId;
/// 授权ID (登录,并授权成功后,用户唯一标识, 本地、内存缓存标识 扩展:默认或者只用一个id 对比时 _userIdEx 为0, 当有多个ID 对应时,两个同时查 )
@property (nonatomic, strong)   NSString *_userIdEx;
/// 登录返回信息
@property (nonatomic, strong)   LoginModel *_user;

/// 是否登录
@property BOOL _isLogin;
/// 是否注销后重新登录
@property BOOL _isReLogin;

/// 登录返回信息
+ (LoginModel *)user;


#pragma mark - -------- client info ----------

/// 客户端token
@property (nonatomic, strong)   NSString *_deviceToken;
/// 是否首次启动新版本 用于教程或者其他数据加载
+ (BOOL)firstEnterNewVer;
/// 首次启动新版本 教程或者其他数据加载完毕
+ (void)doEnterNewVer;

#pragma mark - -------- 内存缓存 ----------
/// 内存缓存数据  setInfo infoForKey
@property (nonatomic, strong) NSMutableDictionary *_memCache;

/// 清除本地文件缓存
+ (void)doCleanCache;
/// 清除本地文件缓存 只清除用户的数据
+ (void)doCleanUsersCache;
/// 缓存大小
+(float) cacheSize;

/// 清除内存缓存 警告:由于读取内存缓存没有安全机制,清缓存后务必手动获取基本数据
+ (void)doCleanMemCache;
/// 保存内存缓存
+ (void)setMemCache:(id)info forKey:(NSString *)key;
/// 读取内存缓存
+ (id)memCacheForKey:(NSString *)key;

#pragma mark - -------- 缓存路径 ----------

/// 生成路径  Library/Cache/userCache/ your path
+ (NSString *)createCacheDir:(NSString *)path;
/// 生成路径  Library/Cache/(userCache^bdCache)/ your path
+ (NSString *)createCacheDir:(NSString *)path isBase:(BOOL)isBase;

- (void)createDirectory:(NSString *)path;

#pragma mark - -------- NSUserDefaults ----------
/// NSUserDefaults 方法
+ (void)setObj:(id)value forKey:(id)key;
/// NSUserDefaults 方法
+ (id)objForKey:(id)key;

#pragma mark - -------- CoreData 配置保存 不支持异步操作----------

/// CoreData 写入配置 用户ID: self._userId 用户扩展ID: self._userIdEx
+ (void)setCfg:(id)value forKey:(id)key;
/// CoreData 写入配置 用户ID: userId 用户扩展ID: self._userIdEx
+ (void)setCfg:(id)value forKey:(id)key userId:(NSString *)userId;

/// CoreData 读取配置 用户ID: self._userId 用户扩展ID: self._userIdEx
+ (id)getCfgForKey:(id)key;
/// CoreData 读取配置 用户ID: userId 用户扩展ID: self._userIdEx
+ (id)getCfgForKey:(id)key userId:(NSString *)userId;

/// CoreData 恢复默认配置  用户ID: self._userId 用户扩展ID: self._userIdEx
+ (void)reSetCfg;
/// CoreData 恢复默认配置  用户ID: userId 用户扩展ID: self._userIdEx
+ (void)reSetCfgForUser:(NSString *)userId;

+ (TConstants *)getInstance;

@end


/// TBlock 初始化并保存全局字典:key
void _TBlock_new(TBlock aBlk, NSString* key);
/// VBlock 初始化并保存全局字典:key(自动释放)
void _VBlock_new(VBlock aBlk, NSString* key);

/// TBlock 从全局字典取出:key 并执行
void _TBlock_do(NSString* key, id item);
/// VBlock 从全局字典取出:key 并执行(自动释放)
void _VBlock_do(NSString* key);

/// Block 从全局字典取出:key 并执行
void _Block_new(const void *aBlk, NSString* key);
/// Block 从全局字典取出:key
void *_Block_get(NSString* key);
/// Block 从全局字典中释放
void _Block_remove(NSString* key);
