//
//  TCommand.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#define i_Code_Net_Unable   300
#define i_Code_Cancel_Req   301
#define i_Code_Req_Timeout   302

#define s_BaseData_Dir      @"s_bd"
#define s_CacheData_Dir     @"s_cache"

#import <CoreData/CoreData.h>
#import "TProtocols.h"
#import "TDefine.h"


@class LocalCache;
@interface TCommand : NSObject

/// 请求模型
@property (nonatomic, strong) NSOperationQueue* _queue;
/// 响应对象
@property (nonatomic, weak) id _sourceSCreen;

/// 请求模型
@property (nonatomic, strong) id <TBParamProtocol> _reqObject;
/// 返回模型
@property (nonatomic, strong) id <TBModelProtocol> _rspObject;
/// 完成回调
@property (nonatomic, strong) TBlock _rspBlock;
/// 请求配置数据
@property (nonatomic, assign) TReqCfg reqCfg;
/// 0：网络 1：硬盘  2：内存
@property (nonatomic, assign) NSInteger cacheType;
/// 缓存索引记录 ==> CoreData
@property (nonatomic, strong) LocalCache* cacheItem;

- (void)addOperation:(NSOperation *)operation;
- (void)doResponse;

/// 失败 ==> 网络不稳定
- (void) faildNetUnconnect;
/// 失败 ==> 请求超时
- (void) faildRequestTimeout;
/// 取消请求
- (void) cancelRequest;

@end





@interface LocalCache : NSManagedObject

/// 用户id
@property (nonatomic, retain) NSString * userID;
/// 用户扩展id
@property (nonatomic, retain) NSString * userIDEx;

/// 请求id
@property (nonatomic, retain) NSString * reqId;
/// 数据id
@property (nonatomic, retain) NSString * dataId;
/// 数据版本
@property (nonatomic, retain) NSString * dataVer;
/// 查询, 搜索条件
@property (nonatomic, retain) NSString * querys;
/// 页数
@property (nonatomic, retain) NSString * pageno;
/// 请求时间
@property (nonatomic, retain) NSDate * reqDate;

/// 是不是基础数据 (基础数据不做缓存清理)
@property (nonatomic, retain) NSString * isBaseData;
/// 数据缓存路径
@property (nonatomic, retain) NSString * dataPath;

@end

#pragma mark - -------- Local_Cache_CoreData ----------

@interface LocalCache (localCachePath)


/// 合并用户数据 (当 userID 和 userIDEx 同时使用并且优先级相同时,合并数据的操作)
+(void) mergeCacheByUserId:(NSString*)userID userIDEx:(NSString*)userIDEx;

/// 清除缓存 (删除索引,并且删除所有的)
+(void) cleanAllCache;
/// 清除指定用户缓存 (删除索引)
+(void) cleanAllCacheForUserID:(NSString*)userID;
/// 清除临时缓存 (删除索引)
+(void) cleanAllTmpCache;

/// 清除指定用户缓存 (删除索引) 有效时间:当前时间 timeInterval 内
+(void) cleanAllCacheForUserID:(NSString*)userID timeInterval:(NSInteger)time;

/// 清除指定用户缓存 (删除索引)
+(void) cleanAllCacheForUserID:(NSString*)userID userIDEx:(NSString*)userIDEx;

/// 初始化一条缓存索引记录
+(LocalCache*) newCacheItemBySetting:(TBlock)setBlk;

///  保存索引记录  TCommand:TCommand
+(void) savaCacheBy:(TCommand*)TCommand;

/// 根据缓存属性 得到加密路径
-(void) getPathForWriteOrRead;

@end