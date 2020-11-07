//
//  NSDictionaryEx.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

/// 自定义字典, 可变有序字典
@interface DicExt : NSObject

@property (nonatomic, strong) NSMutableArray    *allKeys;
@property (nonatomic, strong) NSMutableArray    *allValues;

/// 初始化
+ (DicExt *)dicExt;

/// 字典长度
- (NSUInteger)count;
/// add object 如果key 存在 不会覆盖
- (void)addObj:(id)value forKey:(NSString *)key;
/// add 页面数据 没有会自动不显示
- (void)addAutoviewObj:(id)value forKey:(NSString *)key;

/// add un Nil object 如果key 存在 不会覆盖
- (void)addUnNilObj:(id)value forKey:(NSString *)key;
///// set object 如果key 存在 覆盖
// - (void)setObj:(id)value forKey:(NSString *)key;
/// 插入 object
- (void)insertObj:(id)value forKey:(NSString *)key atIndex:(NSInteger)atIndex;
/// 删除 object
- (void)deleteObjAtIndex:(NSInteger)index;
/// key 寻值
- (id)objectForKey:(NSString *)key;
/// key 寻 index
- (NSInteger)indexForKey:(NSString *)key;

/// index 寻值
- (id)objectAtIndex:(NSUInteger)index;
/// index 寻key
- (id)keyAtIndex:(NSUInteger)index;

///  返回value 为空时 的 key
- (NSString *)getNullTitle:(NSInteger)index;
///  返回value 不为数字时的 key
- (NSString *)getUnNumberTitleAtIndex:(NSInteger)index;

///设置key对应的数值

@end

@interface NSDictionary (Ext)

/// 字典拼接json 字符串
- (NSString *)JSONStrEx;

/// 字典 ==> 指定 class 的对象
- (id)objectByClass:(Class)tClass;
/// 对象 ==> 字典
+ (id)dictionaryByObject:(id)object;

/// 取字符串
- (NSString *)stringForKey:(id)aKey;
/// 取number
- (NSNumber *)numberForKey:(id)aKey;
/// 取整形
- (int)intForKey:(id)aKey;
/// 取bool
- (BOOL)booleanForKey:(id)aKey;

@end