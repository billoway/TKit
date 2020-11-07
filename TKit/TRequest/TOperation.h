//
//  Operation
//  _app
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//


#import "TDefine.h"

@class TCommand, TFileCommand;
@interface TOperation : NSObject;

SINGLETON_FOR_CLASS_HEADER(TOperation);

/// 添加命令
+ (void)addTCommand:(id)cmd;

///// 开始普通请求 tCmd:普通请求命令模型
//- (void)executeRequest:(TCommand *)tCmd;
///// 开始下载请求 tCmd:下载请求命令模型
//- (void)executeDown:(TFileCommand *)tCmd;


/// 完成普通请求 tXml:网络返回报文  tCmd:普通请求命令模型
- (void)executeFinish:(NSString *)tXml cmd:(TCommand *)tCmd;

/// 完成下载请求 tPath:下载文件存储路径  tCmd:下载请求命令模型
- (void)executeDownFinish:(NSString *)tPath cmd:(TFileCommand *)tCmd;

@end