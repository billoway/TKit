//
//  BaseParam
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TBParam.h"
#import "TNet.h"

@interface TBParam ()

@end

@implementation TBParam

- (id)init
{
    self = [super init];
    self._isFlash = NO;
    self._isWaiting = YES;

    self._dataId = @"xxx";
    self._dataVer = @"xxx";
    self._pageno = Default_Pageno;

    return self;
}

///  分页数 和 是否刷缓存
- (void)setPageno:(NSInteger)pageno refresh:(BOOL)refresh
{
    self._pageno = [NSString stringByInt:(int)pageno];
    self._isFlash = refresh;
}
- (void)setPageno:(NSInteger)pageno
{
    self._pageno = [NSString stringByInt:(int)pageno];
}


/// 请求报文加密接口 ==> 项目自己实现
- (NSString *)reqBodyEncrypt:(NSString *)param
{
    return param;
}
/// 请求报文加密接口 ==> 项目自己实现
- (NSString *)rspBodyDeCrypt:(NSString *)param
{
    return param;
}

/// 封装请求报头
- (NSString *)getReqHeader:(BOOL)containToken
{
    NSString *headerXml = [NSString stringWithFormat:@"{%@", k_Json_Str(@"cmd", self.cmd)];

    if (containToken) {
        headerXml = [headerXml stringByAppendingFormat:@",%@", k_Json_Str(@"token", @"token")];
    }

    return headerXml;
}

/// 封装请求报文,子类必须重写
- (NSString *)getReqBody
{
    /******** 报文
     *   cmd		请求命令（必填）
     *   token	鉴权token,登陆时返回（必填）
     ********/

    NSMutableString *tReqXml = [[NSMutableString alloc] initWithCapacity:0];

    [tReqXml addStr:[self getReqHeader:YES]];
    [tReqXml addStr:@"}"];

    return tReqXml;
}

- (TReqCfg)reqCfg
{
    TReqCfg tCfg;
    return tCfg;
}

/// 发起普通网络请求
- (void)doNetRequest:(TCommand *)cmd
{
    // 请求报文
    NSString *reqParam = [self getReqBody];
    // 请求地址
    NSString *reqUrl = [NSString stringWithUTF8String:cmd.reqCfg.reqUrl];
    
    if (k_Is_Empty(reqUrl)) {
        reqUrl = [TConstants memCacheForKey:@"url"];
    }
#ifdef DEBUG
    if (DE_LOG_REQ && DE_ENCRYPT_REQ) {
        DLog(@" 请求地址: --->>   \n%@\n", reqUrl);
        DLog(@" 请求报文: --->>   \n%@\n", reqParam);
    }
#endif
    
    AFHTTPRequestOperation *request = [TNet doPost:reqUrl param:[self reqBodyEncrypt:reqParam]];
    [request setUserInfo:@{@"cmd":cmd}];
    [cmd addOperation:request];
}

@end