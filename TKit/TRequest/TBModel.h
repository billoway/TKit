//
//  BaseModel
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TProtocols.h"
#import <CoreData/CoreData.h>

#pragma mark - -------- BaseModel ----------
/// 返回数据模型基类 - 模版
@interface TBModel : NSObject <TBModelProtocol>

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

@end

#pragma mark - -------- BaseModel ----------
/// 返回数据模型基类(CoreData) - 模版
@interface BCDModel : NSManagedObject <TBModelProtocol>

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

@end

#pragma mark - -------- CustomKVC ----------

@interface NSObject (CustomKVC)
- (void)setValueEx:(id)value forKey:(NSString *)key;
- (BOOL)contantsKey:(NSString *)key;

@end
@interface TBModel (parseValue)
/// 解析value ==> 返回到 self._item  param:字典或者数组 valueClass:数据模型
- (id)parseValue:(id)param valueClass:(Class)cls;
/// 解析value ==> 返回到 self._property  param:字典或者数组 valueClass:数据模型
- (void)parseProperty:(id)param;

@end

@interface BCDModel (parseValue)
/// 解析value param:字典或者数组 valueClass:数据模型
- (id)parseValue:(id)param valueClass:(Class)cls;
/// 解析value ==> 返回到 self._property  param:字典或者数组 valueClass:数据模型
- (void)parseProperty:(id)param;

@end