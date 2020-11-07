//
//  TCommand.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TCommand.h"
#import "TCDCenter.h"
#import "TConstants.h"
#import "TBParam.h"
#import "TLoadingView.h"

@implementation TCommand

- (void)addOperation:(NSOperation *)operation
{
    if (!self._queue) {
        self._queue = [NSOperationQueue new];
    }
    __block TCommand* bSelf = self;
    __block NSOperation* bOperation = operation;
    GCD_Main_async (^{
        [bSelf._queue addOperation:bOperation];
    });
}

/// 优先走委托方法回调 然后走block 回调 实现委托后不会再走block
- (void)doResponse
{
    if (self._reqObject._isWaiting) {
        [TLoadingView dissLoading];
    }
    __block TCommand* bSelf = self;
    
    if (self._sourceSCreen && [self._sourceSCreen respondsToSelector:@selector(responseEvent:)]) {
        GCD_Main_async(^{
            [bSelf._sourceSCreen responseEvent:bSelf];
        });
        return;
    }
    
    if (self._rspBlock) {
        GCD_Main_async(^{
            bSelf._rspBlock(bSelf._rspObject);
            bSelf._rspBlock = nil;
        });
        return;
    }
}



-(void) cancelAllOperations
{
    [self._queue cancelAllOperations];
}

-(void) netWorkUnable
{
    [self faildNetUnconnect];
}

    /// 失败 ==> 请求取消
- (void) cancelRequest
{
    [self cancelAllOperations];

    self._rspObject = [[self.reqCfg.rspClass alloc] init];
    self._rspObject.code = [NSString stringWithFormat:@"%d", i_Code_Cancel_Req];
    self._rspObject.message = @"请求被取消";

    [self doResponse];
}

    /// 失败 ==> 网络不稳定
- (void) faildNetUnconnect
{
    [self cancelAllOperations];

    self._rspObject = [[self.reqCfg.rspClass alloc] init];
    self._rspObject.code = [NSString stringWithFormat:@"%d", i_Code_Net_Unable];
    self._rspObject.message = @"网络不稳定";

    [self doResponse];
}

    /// 失败 ==> 请求超时
- (void) faildRequestTimeout
{
    [self cancelAllOperations];

    self._rspObject = [[self.reqCfg.rspClass alloc] init];
    self._rspObject.code = [NSString stringWithFormat:@"%d", i_Code_Req_Timeout];
    self._rspObject.message = @"请求超时";

    [self doResponse];
}

- (void)set_reqObject:(id <TBParamProtocol>)reqObject
{
    __reqObject = reqObject;
    self.reqCfg = [reqObject reqCfg];

    __block id <TBParamProtocol> TBParam = reqObject;
    if (!self.reqCfg.isUnChche) {
        self.cacheItem = [LocalCache newCacheItemBySetting:^(LocalCache* item) {
            item.userID = [TConstants getInstance]._userId;
            item.userIDEx = [TConstants getInstance]._userIdEx;
            item.reqId = [NSString stringWithUTF8String:TBParam.reqCfg.reqCmd];
            item.dataId = TBParam._dataId;
            item.dataVer = TBParam._dataVer;
            item.pageno = TBParam._pageno;
            item.isBaseData = [NSString stringByInt:TBParam.reqCfg.isBaseData];
            item.querys = TBParam._dataId;
        }];

        if (self.cacheItem) {
            [self.cacheItem getPathForWriteOrRead];
            // 真实缓存路径
            reqObject.cachePath = [[s_Caches_Path appendPath:[self.cacheItem.isBaseData boolValue]?s_BaseData_Dir:s_CacheData_Dir] appendPath:self.cacheItem.dataPath];
        }
    }
}



@end

#pragma mark - -------- Local_Cache_CoreData ----------

@implementation LocalCache

@dynamic dataId;
@dynamic dataPath;
@dynamic dataVer;
@dynamic reqId;
@dynamic querys;
@dynamic userID;
@dynamic userIDEx;
@dynamic reqDate;
@dynamic pageno;
@dynamic isBaseData;

@end

@implementation LocalCache (localCachePath)

-(void) getPathForWriteOrRead
{
    NSString* path = [[@"reqId==" appendStr:self.reqId] appendStr:@"--"];
    path = [[[path appendStr:@"userID=="]   appendStr:self.userID]   appendStr:@"--"];
    path = [[[path appendStr:@"userIDEx=="] appendStr:self.userIDEx] appendStr:@"--"];
    path = [[[path appendStr:@"dataVer==" ] appendStr:self.dataVer ] appendStr:@"--"];
    path = [[[path appendStr:@"querys=="  ] appendStr:self.querys  ] appendStr:@"--"];
    path = [[[path appendStr:@"pageno=="  ] appendStr:self.pageno  ] appendStr:@".json"];

    // DLog(" ---->>> %@ ",path);
#ifndef DEBUG
    self.dataPath = [path encryptToMD5];
#else
    self.dataPath = [[[@"reqId==" appendStr:self.reqId] appendStr:[path encryptToMD5]] appendStr:@".json"];
#endif

}


/// 清除缓存 (删除索引,并且删除所有的文件)
+(void) cleanAllCache
{
    id allCaCheItem = [[TCDCenter context] fetchRecord:@"LocalCache"];
    for (id cdObj in allCaCheItem) {
        [[TCDCenter context] deleteObject:cdObj];
    }
    [TCDCenter saveContext];
}
/// 清除指定用户缓存 (删除索引)
+(void) cleanAllCacheForUserID:(NSString*)userID
{
    if (k_Is_Empty(userID)) {return;}

    id allCaCheItem = [[TCDCenter context] fetchRecord:@"LocalCache" predicateFormat:@"userID==%@",userID];
    for (id cdObj in allCaCheItem) {
        [[TCDCenter context] deleteObject:cdObj];
    }
    [TCDCenter saveContext];
}

/// 清除临时缓存 (删除索引)
+(void) cleanAllTmpCache;
{
    id allCaCheItem = [[TCDCenter context] fetchRecord:@"LocalCache" predicateFormat:@"isBaseData==0"];
    for (id cdObj in allCaCheItem) {
        [[TCDCenter context] deleteObject:cdObj];
    }
    [TCDCenter saveContext];
}

/// 清除指定用户缓存 (删除索引) 有效时间:当前时间 timeInterval 内
+(void) cleanAllCacheForUserID:(NSString*)userID timeInterval:(NSInteger)time
{
    if (k_Is_Empty(userID) || time<1) {return;}

    id allCaCheItem = [[TCDCenter context] fetchRecord:@"LocalCache" predicateFormat:@"userID==%@",userID];
    for (id cdObj in allCaCheItem) {
        [[TCDCenter context] deleteObject:cdObj];
    }
    [TCDCenter saveContext];
}

/// 清除指定用户缓存 (删除索引)
+(void) cleanAllCacheForUserID:(NSString*)userID userIDEx:(NSString*)userIDEx
{
    id allCaCheItem = [[TCDCenter context] fetchRecord:@"LocalCache" predicateFormat:@"userID==%@ && userID==%@",userID,userIDEx];
    for (id cdObj in allCaCheItem) {
        [[TCDCenter context] deleteObject:cdObj];
    }
    [TCDCenter saveContext];
}

/// 合并用户数据 (当 userID 和 userIDEx 同时使用并且优先级相同时,合并数据的操作)
+(void) mergeCacheByUserId:(NSString*)userID userIDEx:(NSString*)userIDEx
{
    if (k_Is_Empty(userID) || k_Is_Empty(userIDEx)) {
        return;
    }

    NSArray* itemsId = [[TCDCenter context] fetchRecord:@"LocalCache" predicateFormat:@"userID==%@ && userIDEx == nil",userID];
    NSArray* itemsIdEx = [[TCDCenter context] fetchRecord:@"LocalCache" predicateFormat:@"userIDEx==%@ && userID == nil",userIDEx];

    if (itemsId && [itemsId count]>0) {
        for (LocalCache* cdObj in itemsId) {
            cdObj.userIDEx = userIDEx;
        }
        [TCDCenter saveContext];
    }

    if (itemsIdEx && [itemsIdEx count]>0) {
        for (LocalCache* cdObj in itemsIdEx) {
            cdObj.userID = userID;
        }
        [TCDCenter saveContext];
    }
}

/// 初始化一条缓存索引记录
+(LocalCache*) newCacheItemBySetting:(TBlock)setBlk
{
    LocalCache* item = [[TCDCenter context] newRecord:@"LocalCache" setting:setBlk];
    NSArray* allItems = [[TCDCenter context] fetchRecord:@"LocalCache" predicateFormat:@"userID==%@ && userIDEx==%@ && reqId==%@ && dataVer==%@ && querys==%@  && pageno==%@",item.userID,item.userIDEx,item.reqId,item.dataVer,item.querys,item.pageno];
    if (allItems && [allItems count]>0) {
        item = nil;
        return [allItems objectAtIndex:0];
    }
    [[TCDCenter context] insertObject:item];
    return item;
}

///  保存索引记录  TCommand:TCommand
+(void) savaCacheBy:(TCommand*)tCmd
{
    __block TCommand* bCmd = tCmd;
    GCD_Main_async((^{

        LocalCache* item = bCmd.cacheItem;
        if (!item) {return;}

        // 如果是列表数据的第一页 清除该请求的所有页数数据
        if ([item.pageno intValue] == 1) {
            NSArray* allItems = [[TCDCenter context] fetchRecord:@"LocalCache" predicateFormat:@"userID==%@ && userIDEx==%@ && reqId==%@ && dataVer==%@ && querys==%@",item.userID,item.userIDEx,item.reqId,item.dataVer,item.querys];
            for (LocalCache* cdObj in allItems) {
                if ([cdObj.pageno intValue]>1 && ![cdObj.pageno isEqualToString:Default_Pageno]) {
                    [[TCDCenter context] deleteObject:cdObj];
                }
            }
        }

        //  保存缓存索引记录
        item.reqDate = [NSDate date];
        [TCDCenter saveContext];
    }));
}

@end
