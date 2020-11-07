//
//  _object
//  _app
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TNet.h"
#import "TCommand.h"
#import "TFileCommand.h"
#import "TOperation.h"
#import "TExt.h"
#import "TLoadingView.h"

@interface TNet ()

/// 监听对象
@property (nonatomic, strong)   Reachability    *_reachability;

@end

@implementation TNet
static int fTimeOut = f_default_time_out;

#define kURLRequest(address) [NSMutableURLRequest requestWithURL : [NSURL URLWithString : address] cachePolicy : NSURLRequestReloadIgnoringLocalCacheData timeoutInterval : fTimeOut]

+ (AFHTTPRequestOperation *)doGet:(NSString *)address
{
    return [self doPost:address param:nil headerValues:nil];
}

+ (AFHTTPRequestOperation *)doPost:(NSString *)address param:(NSString *)param
{
    return [self doPost:address param:param headerValues:nil];
}

+ (AFHTTPRequestOperation *)doPost:(NSString *)address param:(NSString *)param headerValues:(id)headerValues;
{
    address = [address stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    DLog(@" 请求地址: --->> \n%@\n\n", address);

//#ifdef DEBUG
    if (DE_LOG_REQ && !DE_ENCRYPT_REQ) {
        DLog(@" 请求报文: --->>   \n%@\n", param);
    }
//#endif
    NSMutableURLRequest *urlRequest = kURLRequest(address);

    if ( !k_Is_Empty(param) ) {
        [urlRequest setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setHTTPMethod:@"POST"];
    }
    else {
        [urlRequest setHTTPMethod:@"GET"];
    }

    if (headerValues && [headerValues isKindOfClass:[NSDictionary class]]) {
        for (id key in[headerValues allKeys]) {
            if ([[headerValues objectForKey:key] isKindOfClass:[NSString class]]) {
                [urlRequest addValue:[headerValues objectForKey:key] forHTTPHeaderField:key];
            }
        }
    }

    AFHTTPRequestOperation  *request = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    __block TNet            *bSelf = [TNet getInstance];
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [bSelf requestSuccess:operation];
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [bSelf requestFaild:operation error:error];
    }
    ];

    return request;
}

+ (AFHTTPRequestOperation *)doFormPost:(NSString *)address param:(id)formValues;
{
    return [self doFormPost:address param:formValues headerValues:nil];
}

+ (AFHTTPRequestOperation *)doFormPost:(NSString *)address param:(id)formValues headerValues:(id)headerValues;
{
    address = [address stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    DLog(@" 请求地址: --->> \n%@\n\n", address);

//#ifdef DEBUG
    if (DE_LOG_REQ) {
        DLog(@" 请求报文: --->>   \n%@\n", formValues);
    }
//#endif
    
    NSMutableURLRequest *urlRequest = nil;

    if (formValues && [formValues isKindOfClass:[NSDictionary class]]) {
        AFHTTPRequestSerializer *reqSerializer = [AFHTTPRequestSerializer serializer];
        urlRequest = [reqSerializer multipartFormRequestWithMethod:@"POST" URLString:address parameters:nil constructingBodyWithBlock:^(id < AFMultipartFormData > formData) {
            for (id key in[formValues allKeys]) {
                id value = [formValues objectForKey:key];

                if ([value isKindOfClass:[NSString class]]) {
                    [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
                }
                else if ([value isKindOfClass:[NSData class]]) {
                    [formData appendPartWithFormData:value name:key];
                }
                else if ([value isKindOfClass:[NSURL class]]) {
                    [formData appendPartWithFileURL:value name:key error:nil];
                }
                else if ([value isKindOfClass:[NSDictionary class]]) {
                    id fileurl, filedata, filename;
                    id name = key;
                    id mimetype = @"image/jpeg";

                    for (id fKey in[value allKeys]) {
                        if ([[fKey lowercaseString] isEqualToString:@"fileurl"]) {
                            fileurl = [value objectForKey:fKey];
                        }
                        else if ([[fKey lowercaseString] isEqualToString:@"filedata"]) {
                            filedata = [value objectForKey:fKey];
                        }
                        else if ([[fKey lowercaseString] isEqualToString:@"filename"]) {
                            filename = [value objectForKey:fKey];
                        }
                        else if ([[fKey lowercaseString] isEqualToString:@"mimetype"]) {
                            mimetype = [value objectForKey:fKey];
                        }
                        else if ([[fKey lowercaseString] isEqualToString:@"key"]) {
                            name = [value objectForKey:fKey];
                        }
                    }

                    if (filedata) {
                        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimetype];
                    }
                    else if (fileurl) {
                        [formData appendPartWithFileURL:fileurl name:name fileName:filename mimeType:mimetype error:nil];
                    }
                }
            }
        }
                      error:NULL];
    }
    else {
        urlRequest = kURLRequest(address);
        [urlRequest setHTTPMethod:@"GET"];
    }

    if (headerValues && [headerValues isKindOfClass:[NSDictionary class]]) {
        for (id key in[headerValues allKeys]) {
            if ([[headerValues objectForKey:key] isKindOfClass:[NSString class]]) {
                [urlRequest addValue:[headerValues objectForKey:key] forHTTPHeaderField:key];
            }
        }
    }

    AFHTTPRequestOperation  *request = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    __block TNet            *bSelf = [TNet getInstance];
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [bSelf requestSuccess:operation];
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [bSelf requestFaild:operation error:error];
    }
    ];

    return request;
}

#define kRespString(request) [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding]

- (void)requestSuccess:(id)request
{
    __block TOperation *bOperation = [TOperation getInstance];
    __block AFHTTPRequestOperation* bRequest = request;

    GCD_Back_async (^{
        id cmd = [[bRequest userInfo] objectForKey:@"cmd"];
        [bRequest setUserInfo:nil];
        
        NSString    *tRespContent = kRespString(bRequest);
        NSString    *rspCmdName = nil;
        
        if ([cmd isKindOfClass:[TCommand class]]) {
            rspCmdName = [NSStringFromClass([[cmd _reqObject] class]) stringByReplacingOccurrencesOfString:@"Param" withString:@""];
            
            //        GCD_Back_async (^{
            [bOperation executeFinish:tRespContent cmd:cmd];
            //        });
            //        [bOperation executeFinish:tRespContent cmd:cmd];
        }
        else if ([cmd isKindOfClass:[TFileCommand class]]) { }
        else { }
      
//#ifdef DEBUG
        if (DE_LOG_RESP && !DE_ENCRYPT_REQ) {
            DLog(@"---> 网络返回报文: ==>  cmd:%@ \n\n%@ ", rspCmdName, [@"\n\n " appendStr:[tRespContent deleteSpaceAndLine]]);
        }
//#endif
        
    });
}

- (void)requestFaild:(id)request error:(NSError *)error
{
    id cmd = [[request userInfo] objectForKey:@"cmd"];
    [request setUserInfo:nil];

    DLog(@"---> ERROR: ==> code:%d description:%@\n\n ", [error code], [request error]);

    if ([cmd isKindOfClass:[TCommand class]]) {
        //        4 是取消请求 其他都可认为请求超时  参考 ASINetworkErrorType
        if ([[request error] code] != 4) {
            if ([[request error] code] == 1) {
                [cmd faildNetUnconnect];
            }
            else {
                [cmd faildRequestTimeout];
            }
        }
    }
    else if ([cmd isKindOfClass:[TFileCommand class]]) { }
}

+ (void)regist_time_out:(float)timeout;
{
    fTimeOut = timeout;
}
+ (float)get_registe_time_out;
{
    return fTimeOut;
}

static TNet *kInstance;
+ (TNet *)getInstance
{
    if (!kInstance) {
        kInstance = [[TNet alloc] init];
        [kInstance addConnectNotification];
    }

    return kInstance;
}

#pragma mark - -------- 网络连接监听 ----------

- (void)reachabilityIsChanged:(NSNotification *)notify
{
    Reachability    *curReach = [notify object];
    NetworkStatus networkStatus = [curReach currentReachabilityStatus];

    [self set_netStatus:networkStatus];

    if (networkStatus == NotReachable) {
        [TLoadingView showAlert:@"网络连接已断开"];
    }
    else {
        if (self.netConnectDone) {
            [TLoadingView showAlert:@"网络已连接"];
            self.netConnectDone(networkStatus != NotReachable);
            self.netConnectDone = NULL;
        }
    }

    Log_Connection_Status;
}

- (void)addConnectNotification
{
    self._reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];

    self._netStatus = self._reachability.currentReachabilityStatus;
    [self._reachability startNotifier];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityIsChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void)removeConnectNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];

    if (self._reachability) {
        [self._reachability stopNotifier]; // 关闭网络检测
        self._reachability = nil;
    }
}

- (void)set_netStatus:(NetworkStatus)netStatus
{
    __netStatus = netStatus;
}

@end