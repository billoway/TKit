//
//  _object
//  _app
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#define f_default_time_out 15

@class TCommand, TFileCommand;

//#ifdef TKIT_LIB
//#import "../Externals/AFNetworking/AFNetworking.h"
//#import "../Externals/Reachability/Reachability.h"
//
//#else
#import "AFNetworking.h"
#import "Reachability.h"

//#endif


#import "TDefine.h"

@interface TNet : NSObject

/// 失败后 重新连接回调
@property (nonatomic, strong)  BBlock           netConnectDone;
/// 网络状态
@property (nonatomic, readonly)  NetworkStatus  _netStatus;


+ (TNet *)getInstance;

/// get 请求
+ (AFHTTPRequestOperation *)doGet:(NSString *)address;
/// post 请求
+ (AFHTTPRequestOperation *)doPost:(NSString *)address param:(NSString *)param;
/// post 请求 支持自定义 HttpHeader
+ (AFHTTPRequestOperation *)doPost:(NSString *)address param:(NSString *)param headerValues:(id)headerValues;

//  [TNet doFormPost:reqUrl param:@{@"file":@"NSURL/NSData",@"file":@{@"fileurl":@"NSURL",@"filedata":@"NSData",@"filename":@"NSString",@"mimetype":@"image/jpeg"}}];
/// form 表单 formValues
+ (AFHTTPRequestOperation *)doFormPost:(NSString *)address param:(NSDictionary *)formValues;
/// form 表单 支持自定义 HttpHeader
+ (AFHTTPRequestOperation *)doFormPost:(NSString *)address param:(NSDictionary*)formValues headerValues:(id)headerValues;

/// 配置超时时间
+ (void)regist_time_out:(float)timeout;
/// 获取超时时间
+ (float)get_registe_time_out;

@end



#define     Log_Connection_Status DLog("   Net_Work_Connection_Status:%@", ([TNet getInstance]._netStatus == NotReachable ? @"==>NO NET" :[TNet getInstance]._netStatus == ReachableViaWiFi ? @"==> WiFi" : @"==>WWAN"))
