//
//  BaseParam
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TProtocols.h"

#import "TConstants.h"
#import "TCommand.h"
#import "TFileCommand.h"

/// 请求数据模型基类 - 模版
@interface TBParam : NSObject <TBParamProtocol>

///  栏目 id
@property (nonatomic, strong) NSString *_dataId;
///  栏目 消息版本
@property (nonatomic, strong) NSString *_dataVer;
///  栏目 分页数
@property (nonatomic, strong) NSString *_pageno;
///  缓存目录
@property (nonatomic, strong) NSString *cachePath;
/// 请求标识符
@property (nonatomic, strong) NSString *cmd;
/// 请求标识符
@property (nonatomic, readonly) TReqCfg reqCfg;
/// 是否取缓存控制 ==> YES:网络  NO:缓存 优先缓存,没有时取网络
@property BOOL _isFlash;
/// 是否显示等待框
@property BOOL _isWaiting;

/// 获取请求报文
- (NSString *)getReqBody;

/// 封装请求报文头部,子类调用  containToken	是否包含鉴权令牌
- (NSString *)getReqHeader:(BOOL)containToken;

///  发起普通网络请求 子类调用,可重写 cmd:普通请求命令
- (void)doNetRequest:(id)cmd;

/// 设置分页数
@property (nonatomic, assign) NSInteger pageno;
/// 分页数 和 是否刷缓存
- (void)setPageno:(NSInteger)pageno refresh:(BOOL)refresh;


#pragma mark - -------- 添加加密和解密接口 ----------
/// 请求报文加密接口 ==> 项目自己实现
- (NSString *)reqBodyEncrypt:(NSString *)param;
/// 请求报文加密接口 ==> 项目自己实现
- (NSString *)rspBodyDeCrypt:(NSString *)param;

@end

#define Default_Pageno @"10000"