//
//  TFileCommand.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TProtocols.h"
#import "TDefine.h"


@interface TFileCommand : NSObject

/// 请求模型
@property (nonatomic, strong) NSOperationQueue* _queue;
/// 响应对象
@property (nonatomic, weak) id _sourceSCreen;

/// 下载地址
@property (nonatomic, strong) NSString  *_reqUrl;
/// 本地路径
@property (nonatomic, strong) NSString  *_localPath;
/// 文件hash
@property (nonatomic, strong) NSString  *_fileHash;


- (void)addOperation:(NSOperation *)operation;
- (void)doResponse;

/// 失败 ==> 网络不稳定
- (void) faildNetUnconnect;
/// 失败 ==> 请求超时
- (void) faildRequestTimeout;

@end
