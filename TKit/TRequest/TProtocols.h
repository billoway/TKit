//
//  TProtocols.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - -------- TBParamProtocol ----------

typedef NS_OPTIONS(NSUInteger, TRspDataType) {
    TRspJson = 1,
    TRspXml,
    TRspUnKnow,
};
typedef struct TReqCfg TReqCfg;

@protocol TBParamProtocol <NSObject>
@required

///  栏目 id ==> 用于缓存
@property (nonatomic, strong) NSString *_dataId;
///  栏目 版本 ==> 用于缓存
@property (nonatomic, strong) NSString *_dataVer;
///  栏目 分页数 ==> 用于缓存、列表数据
@property (nonatomic, strong) NSString *_pageno;
///  缓存文件路径  ==> 用于缓存
@property (nonatomic, strong) NSString *cachePath;
    /// 请求标识符
@property (nonatomic, strong) NSString *cmd;
    /// 请求配置数据
@property (nonatomic, readonly) TReqCfg reqCfg;
    /// 是否取缓存控制 ==> YES:网络  NO:缓存 优先缓存,没有时取网络
@property BOOL _isFlash;
/// 是否显示等待框
@property BOOL _isWaiting;

/// 请求报文加密接口 ==> 项目自己实现
-(NSString*) reqBodyEncrypt:(NSString*)param;
/// 请求报文加密接口 ==> 项目自己实现
-(NSString*) rspBodyDeCrypt:(NSString*)param;

/// 获取请求报文
- (NSString *)getReqBody;

/// 封装请求报文头部,子类调用  containToken	是否包含鉴权令牌
- (NSString *)getReqHeader:(BOOL)containToken;

///  发起普通网络请求 子类调用,可重写 cmd:普通请求命令
- (void)doNetRequest:(id)cmd;

@end

#pragma mark - -------- TBModelProtocol ----------
@protocol TBModelProtocol <NSObject>

@required
/// 响应码
@property (nonatomic, strong) NSString *code;
/// 响应消息
@property (nonatomic, strong) NSString *message;
/// 请求成功 返回的页面
@property (nonatomic, assign) int16_t pageno;
/// 是否请求成功
@property (nonatomic, assign, readonly) BOOL isSuccess;
/// 请求cmd
@property (nonatomic, weak) id cmd;


/// 解析 param:为字典或者数组等
- (void)parseValue:(id)param;

@optional
/// 请求返回的 param 字典或者数组等
@property (nonatomic, strong) id rspDic;
/// 初始化 CoreData 数据模型
- (void)initCDModel;

@end

struct TReqCfg {
//        /// 请求数据模型类名
//    Class reqClass;
        /// 返回数据模型类名
    Class rspClass;
        /// 请求命令
    const char *reqCmd;
        /// 请求名称
    const char *reqName;
        /// 请求地址
    const char *reqUrl;
        /// 返回数据类型
    TRspDataType rspDataType;
        /// 是否为基础数据
    BOOL isBaseData;
        /// 是否为公用数据 ==> YES:公有  NO:公有(不存储于用户目录)
    BOOL isPublic;
        /// 不缓存数据
    BOOL isUnChche;
        /// CoreData管理数据
    BOOL isCoreData;
};


#pragma mark - -------- TRespProtocol ----------

@protocol TProgressProtocol;
@protocol TResponseProtocol;
@protocol TFileResponseProtocol;

@class TCommand, TFileCommand;

/// 进度条协议
@protocol TProgressProtocol<NSObject>
@required
/// 进度百分比 (小于等于1)
@property (nonatomic, assign) float progress;

@end

/// 普通请求回调协议
@protocol TResponseProtocol<NSObject>
@required
/// 普通请求 事件回调 cmd	请求命令
- (void)responseEvent:(TCommand *)cmd;

@end

/// 文件下载回调协议
@protocol TFileResponseProtocol<NSObject>
@required
/// 文件下载请求 事件回调 cmd	请求命令
- (void)responseFile:(TFileCommand *)cmd;

@end


