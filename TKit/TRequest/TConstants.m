//
//  Constants
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TConstants.h"

#import "TExt.h"
#import "TFileIO.h"
#import "TCDCenter.h"
#import "TCommand.h"

@interface TConstants ()

/// 登录返回信息
@property (nonatomic, strong)   NSMutableDictionary *_blocks;

@end
@implementation TConstants

#pragma mark - -------- user info ----------

+ (id)user
{
    return [self getInstance]._user;
}

#pragma mark - -------- apns info ----------

- (NSString *)_deviceToken
{
    return [TConstants objForKey:USER_TOKEN];
}

- (void)set_deviceToken:(NSString *)deviceToken
{
    [TConstants setObj:deviceToken forKey:USER_TOKEN];
}

#pragma mark - -------- client info ----------

/// 本地保存的版本 用于更新后 显示教程 和首次启动加载
#define _client_key @"B-984AE30BC806-84680-EFA990A6-499944"

/// 是否首次启动新版本 用于教程或者其他数据加载
+ (BOOL)firstEnterNewVer
{
    NSString *lastClient = [self objForKey:_client_key];

    return ![lastClient isEqualToString:s_clientVer];
}

/// 首次启动新版本 教程或者其他数据加载完毕
+ (void)doEnterNewVer
{
    [self setObj:s_clientVer forKey:_client_key];
}

#pragma mark - -------- 缓存 ----------

+ (void)doCleanCache
{
    [self doCleanUsersCache];
    NSString    *xxxPath = [s_Caches_Path appendPath:__USER];
    NSString    *imgPath = [s_Caches_Path appendPath:@"com.hackemist.SDWebImageCache.default/"];

    // ---------------- 清除 文件缓存
    __autoreleasing NSError *tError;
    NSFileManager           *tFileManager = [NSFileManager defaultManager];

    if (![tFileManager removeItemAtPath:xxxPath error:&tError]) {
        DLog(@"----------- 删除 【%@】 失败  \n 【%@】", xxxPath, tError);
    }

    if (![tFileManager removeItemAtPath:imgPath error:&tError]) {
        DLog(@"----------- 删除 【%@】 失败  \n 【%@】", imgPath, tError);
    }
}

/// 缓存大小libTCWeiboSDK.a
+ (float)cacheSize;
{
    NSString    *bdPath = [s_Caches_Path appendPath:s_BaseData_Dir];
    NSString    *cachePath = [s_Caches_Path appendPath:s_CacheData_Dir];
    NSString    *imgPath = [s_Caches_Path appendPath:@"com.hackemist.SDWebImageCache.default/"];

    float size = 0;
    // [bdAttri fileSize]+[cacheAttri fileSize];//+(int)[imgAttri fileSize];
    size += [TFileIO folderSizeAtPath:bdPath];
    size += [TFileIO folderSizeAtPath:cachePath];
    size += [TFileIO folderSizeAtPath:imgPath];
    return size;
}


+ (void)doCleanUsersCache
{
    NSString *xmlPath = [s_Caches_Path appendPath:@"users/"];

    // ---------------- 清除 文件缓存
    __autoreleasing NSError *tError;
    NSFileManager           *tFileManager = [NSFileManager defaultManager];

    if (![tFileManager removeItemAtPath:xmlPath error:&tError]) {
        //        DLog(@"----------- 删除 【%@】 失败  \n 【%@】",xmlPath,tError);
    }
}

+ (void)doCleanMemCache
{
    [[self getInstance]._memCache removeAllObjects];
}

/// 保存内存缓存
+ (void)setMemCache:(id)info forKey:(NSString *)key
{
    if ( k_Is_Empty(key) ) {
        return;
    }

    if (![self getInstance]._memCache) {
        [self getInstance]._memCache = [NSMutableDictionary dictionary];
    }

    if (!info) {
        [[self getInstance]._memCache removeObjectForKey:key];
    }
    else {
        [[self getInstance]._memCache setObject:info forKey:key];
    }
}

/// 读取内存缓存
+ (id)memCacheForKey:(NSString *)key
{
    if (k_Is_Empty(key) || ![self getInstance]._memCache) {
        return nil;
    }

    return [[self getInstance]._memCache objectForKey:key];
}

// 生成路径  Library/Cache/userCache/ your path
+ (NSString *)createCacheDir:(NSString *)path
{
    NSString *tPath = s_Caches_Path;

    if (![[path pathComponents] containsObject:@"Library"] && ![[path pathComponents] containsObject:@"Documents"]) {
        tPath = [[s_Caches_Path appendPath:@"userCache"] appendPath:path];
    }

    [[self getInstance] createDirectory:tPath];
    return tPath;
}

// 生成路径  Library/Cache/(userCache^bdCache)/ your path
+ (NSString *)createCacheDir:(NSString *)path isBase:(BOOL)isBase
{
    NSString *tPath = s_Caches_Path;

    if (![[path pathComponents] containsObject:@"Library"] && ![[path pathComponents] containsObject:@"Documents"]) {
        tPath = [[s_Caches_Path appendPath:isBase ? @"bdCache":@"userCache"] appendPath:path];
    }

    [[self getInstance] createDirectory:tPath];
    return tPath;
}

- (void)createDirectory:(NSString *)path
{
    NSString *dir = path;

    if (![path hasSuffix:@"/"]) {
        [path stringByDeletingLastPathComponent];
    }

    NSFileManager *tFileManage = [[NSFileManager alloc] init];

    if (![tFileManage fileExistsAtPath:dir]) {
        [tFileManage createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

#pragma mark - -------- NSUserDefaults ----------

+ (void)setObj:(id)value forKey:(id)key
{
    NSUserDefaults *tUser = [NSUserDefaults standardUserDefaults];

    [tUser setObject:value forKey:key];
    [NSUserDefaults resetStandardUserDefaults];
}

+ (id)objForKey:(id)key
{
    NSUserDefaults *tUser = [NSUserDefaults standardUserDefaults];

    return [tUser objectForKey:key];
}

#pragma mark - -------- CoreData 配置保存----------

#define k_cfg_fetch(userId, userIdEx, key) [[TCDCenter context] fetchRecord:@"LocalConfig" predicateFormat: \
                                            @"userid == %@ && useridEx == %@ && key == %@", userId, userIdEx, key]

/// 写入配置 用户ID: self._userId 用户扩展ID: self._userIdEx
+ (void)setCfg:(id)value forKey:(id)key
{
    [self setCfg:value forKey:key userId:[self getInstance]._userId userIdEx:[self getInstance]._userIdEx];
}

/// 写入配置 用户ID: userId 用户扩展ID: self._userIdEx
+ (void)setCfg:(id)value forKey:(id)key userId:(NSString *)userId
{
    [self setCfg:value forKey:key userId:userId userIdEx:[self getInstance]._userIdEx];
}

/// 写入配置 用户ID: userId 用户扩展ID: userIdEx
+ (void)setCfg:(id)value forKey:(id)key userId:(NSString *)userId userIdEx:(NSString *)userIdEx
{
    if (!value || !key) {
        return;
    }

    id tRecord;
    id records = k_cfg_fetch(userId, userIdEx, key);

    if ( records && ([records count] > 0) ) {
        tRecord = [records objectAtIndex:0];
    }
    else {
        tRecord = [[TCDCenter context] insertRecord:@"LocalConfig" setting:^(id item) {
            [item setValue:userId forKey:@"userid"];
            [item setValue:userIdEx forKey:@"useridEx"];
            [item setValue:key forKey:@"key"];
        }
                  ];
    }

    [tRecord setValue:value forKey:@"value"];
    [TCDCenter saveContext];
}

/// 读取配置 用户ID: self._userId 用户扩展ID: self._userIdEx
+ (id)getCfgForKey:(id)key
{
    return [self getCfgForKey:key userId:[self getInstance]._userId userIdEx:[self getInstance]._userIdEx];
}

/// 读取配置 用户ID: userId 用户扩展ID: self._userIdEx
+ (id)getCfgForKey:(id)key userId:(NSString *)userId
{
    return [self getCfgForKey:key userId:userId userIdEx:[self getInstance]._userIdEx];
}

/// 读取配置 用户ID: userId 用户扩展ID: userIdEx
+ (id)getCfgForKey:(id)key userId:(NSString *)userId userIdEx:(NSString *)userIdEx
{
    if (!key) {
        return nil;
    }

    id tRecord;
    id records = k_cfg_fetch(userId, userIdEx, key);

    if ( records && ([records count] > 0) ) {
        tRecord = [records objectAtIndex:0];
        return [tRecord valueForKey:@"value"];
    }

    return nil;
}

/// 恢复默认配置  用户ID: self._userId 用户扩展ID: self._userIdEx
+ (void)reSetCfg
{
    [self reSetCfgForUser:[self getInstance]._userId userIdEx:[self getInstance]._userIdEx];
}

/// 恢复默认配置  用户ID: userId 用户扩展ID: self._userIdEx
+ (void)reSetCfgForUser:(NSString *)userId
{
    [self reSetCfgForUser:userId userIdEx:[self getInstance]._userIdEx];
}

/// 恢复默认配置  用户ID: userId  用户扩展ID: userIdEx
+ (void)reSetCfgForUser:(NSString *)userId userIdEx:(NSString *)userIdEx
{
    if (!userId) {
        return;
    }

    id records = k_cfg_fetch(userId, userIdEx, nil);

    if ( records && ([records count] > 0) ) {
        for (id tRecord in records) {
            [[TCDCenter context] deleteObject:tRecord];
        }

        [TCDCenter saveContext];
    }
}


#pragma mark - -------- instance ----------
static TConstants *_constants;

+ (TConstants *)getInstance
{
    if (!_constants) {
        _constants = [[[self class] alloc] init];

        _constants._loginId = @"";
        _constants._userId = @"";
        _constants._userIdEx = @"";
        _constants._blocks = [NSMutableDictionary dictionary];
    }

    return _constants;
}

@end



void _TBlock_new(TBlock aBlk, NSString *key)
{
    if (aBlk != nil) {
        [[TConstants getInstance]._blocks setObject:aBlk forKey:key];
    }
}

void _VBlock_new(VBlock aBlk, NSString *key)
{
    if (aBlk != nil) {
        [[TConstants getInstance]._blocks setObject:aBlk forKey:key];
    }
}

void _TBlock_do(NSString *key, id item)
{
    VBlock aBlk = [[TConstants getInstance]._blocks objectForKey:key];
    if (aBlk) {
        aBlk(item);
    }
    [[TConstants getInstance]._blocks removeObjectForKey:key];
}

void _VBlock_do(NSString *key)
{
    VBlock aBlk = [[TConstants getInstance]._blocks objectForKey:key];
    if (aBlk) {
        aBlk();
    }
    [[TConstants getInstance]._blocks removeObjectForKey:key];
}

void _Block_new(const void *aBlock, NSString *key)
{
    if (aBlock != nil) {
        [[TConstants getInstance]._blocks setObject:(__bridge id)(aBlock) forKey:key];
    }
}

void *_Block_do(NSString *key)
{
    return (__bridge void *)([[TConstants getInstance]._blocks objectForKey:key]);
}

void _Block_remove(NSString* key)
{
    [[TConstants getInstance]._blocks removeObjectForKey:key];
}
