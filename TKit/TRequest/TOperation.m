//
//  Operation
//  _app
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TOperation.h"

#import "TNet.h"

#import "TBParam.h"
#import "TCommand.h"
#import "TFileCommand.h"

#import "TCDCenter.h"
#import "TConstants.h"
#import "TLoadingView.h"
#import "TDefine.h"

@implementation TOperation

SINGLETON_FOR_CLASS(TOperation);

#pragma mark - -------- 普通请求 ----------

// --- 普通请求
- (void)executeRequest:(TCommand *)tCmd
{
    TReqCfg reqCfg = tCmd.reqCfg;

    id <TBParamProtocol> tParam = tCmd._reqObject;
    tParam.cmd = [NSString stringWithUTF8String:reqCfg.reqCmd];

    if (k_Is_Empty(tParam.cmd)) {
        DLog(" ------->> (%@) 请求命令未知",NSStringFromClass([tParam class]));
        return;
    }

    // ----------- 处理判断缓存
    NSString *tRspXml = nil;

    if ([TNet getInstance]._netStatus == NotReachable) {
        [tCmd faildNetUnconnect];
        return;
    }

    // 未刷新或者断网 时读取本地缓存
    if (!tParam._isFlash) { // || [TConstants getInstance]._netStatus == NotReachable
#ifndef DEBUG_UN_CACHE
            tRspXml = [TFileIO readEncryStrFromPath:tParam.cachePath];
#endif
    }

//#ifdef DE_UN_NETWORK
//        tRspXml = [TFileIO readDataFromPath:tParam.cachePath];
//#endif

    // ----------- 发起请求
    if (k_Is_Empty(tRspXml)) {
        // 网络请求
        [tParam doNetRequest:tCmd];
    } else {
        tCmd.cacheType = 1;
        [self executeFinish:tRspXml cmd:tCmd];
    }
}

///  普通请求返回
- (void)executeFinish:(NSString *)tXml cmd:(TCommand *)tCmd
{
    TReqCfg         reqCfg = tCmd.reqCfg;
    TRspDataType    rspDataType = reqCfg.rspDataType;
    id              value;

    // 如果网络获取的数据 需要解密
        if (!tCmd.cacheType) {
            if (DE_ENCRYPT_REQ) {
                id tmptXml = [tCmd._reqObject rspBodyDeCrypt:tXml];
//#ifdef DEBUG
                if (DE_LOG_RESP) {
                    NSLog(@"---> 网络返回报文: ==>  %@ \n\n%@ ", [NSString stringWithUTF8String:tCmd.reqCfg.reqCmd], tmptXml);
                    if (k_Is_Empty(tmptXml)) {
                        NSLog(@"--->解密失败  网络返回报文: ==>  %@ \n\n%@ ",[NSString stringWithUTF8String:tCmd.reqCfg.reqCmd],tXml);
                    }
                }
//#endif
                tXml = tmptXml;
            }
        }
//#ifdef DEBUG
        else {
            if (DE_LOG_RESP_CACHE) {
                NSLog(@"---> 本地读取报文: ==>  %@ \n\n%@ ", [NSString stringWithUTF8String:tCmd.reqCfg.reqCmd], tXml);
            }
        }
//#endif
    
    @try {
        if (rspDataType == TRspJson) {
            value = [tXml JSON2Value];
        } else if (rspDataType == TRspXml) {
            value = [tXml XML2Value];
        } else {
            value = [tXml JSON2Value];
        }
    }
    @catch(NSException *e) {
        DLog("----- %@", e);
    }

    @finally {}

    if (reqCfg.isCoreData) {
        __block TOperation *bSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
                [bSelf parseAndResp:tCmd value:value tXml:tXml];
            });
    } else {
        [self parseAndResp:tCmd value:value tXml:tXml];
    }
}

- (void)parseAndResp:(TCommand *)tCmd value:(id)value tXml:(NSString *)tXml
{
    TReqCfg reqCfg = tCmd.reqCfg;

    id <TBParamProtocol> tParam = tCmd._reqObject;
    id <TBModelProtocol> tModel;

    if (reqCfg.isCoreData) {
        tModel = [[TCDCenter context] newRecord:NSStringFromClass(reqCfg.rspClass)];
    } else {
        tModel = [[reqCfg.rspClass alloc] init];
    }

    @try {
        [tModel setCmd:tCmd];
        [tModel parseValue:value];
    }
    @catch(NSException *e) {
        DLog("--->> %@", e);

        tModel.code = @"-100";
        [tCmd doResponse];
    }

    @finally {}
    
    tCmd._rspObject = tModel;

    // ----------- 命令回调
    if (tParam._isWaiting) {
        [TLoadingView dissLoading];
    }

    if (tModel.isSuccess) {
        [tModel setPageno:[tParam._pageno intValue]];

//#ifdef DEBUG
//        reqCfg.isUnChche = NO;
//#endif

        // ----------- 缓存处理 CoreData 索引方式
        // 缓存 && 有路径 && 网络 时存储缓存
        if (!reqCfg.isUnChche && tCmd._reqObject.cachePath && (tCmd.cacheType == 0)) {
            [TFileIO writeEncryStrToPath:tCmd._reqObject.cachePath content:tXml];
            [LocalCache savaCacheBy:tCmd];
        }
    }

    [tCmd doResponse];
}

#pragma mark - -------- 文件下载请求 ----------

- (void)executeDown:(TFileCommand *)tCmd
{}

/// 文件下载返回
- (void)executeDownFinish:(NSString *)tPath cmd:(TFileCommand *)tCmd
{}


#pragma mark - -------- 全局请求 ----------

/// 添加命令
+ (void)addTCommand:(id)tCmd
{
    if (tCmd) {
        __block TOperation* bSelf = [self getInstance];
        __block id bCmd = tCmd;

        GCD_Back_async(^{
            if ([bCmd isMemberOfClass:[TCommand class]]) {               // 普通请求
                [bSelf doOperation:bCmd];
            } else if ([bCmd isMemberOfClass:[TFileCommand class]]) {    // 下载请求
                [bSelf doDownOperation:bCmd];
            }
        });
    }
}


/// 普通请求操作
- (void)doOperation:(TCommand *)tCmd
{
    @try {
        if (tCmd._reqObject._isWaiting) {
            __block TCommand* bCmd = tCmd;
            [TLoadingView showLoadingWithCancel:^{
                [bCmd cancelRequest];
            }];
        }
        
        [self executeRequest:tCmd];
    }
    @catch(NSException *e) {
        DLog(@"-------------  NSException\n   Name: %@\n   Reason: %@", [e name], [e reason]);
        
        id <TBModelProtocol>tModel = [[tCmd.reqCfg.rspClass alloc]init];
        tModel.code = [e reason];
        tModel.message = [e name];
        tCmd._rspObject = tModel;
        [tCmd doResponse];
        tCmd._sourceSCreen = nil;
    }
    
    @finally {}
}

/// 下载请求操作
- (void)doDownOperation:(TFileCommand *)tCmd
{
    @try {
        [self executeDown:tCmd];
    }
    @catch(NSException *e) {
        DLog(@"-------------  NSException\n   Name: %@\n   Reason: %@", [e name], [e reason]);
        
        if ([tCmd._sourceSCreen respondsToSelector:@selector(responseFile:)]) {
            [tCmd._sourceSCreen responseFile:tCmd];
            tCmd._sourceSCreen = nil;
        }
    }
    
    @finally {}
}

@end


