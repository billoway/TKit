//
//  NSArrayEx.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Ext)

/// 数组内对象位置移动
- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

/// 往数组中添加对象 异常已捕获
- (void)addObjectEx:(id)anObject;

/// 删除 index下标的对象 异常已捕获
- (void)removeObjectAtIndexEx:(NSUInteger)index;

@end

@interface NSArray (Ext)

/// 取对象 异常已捕获
- (id)objectAtIndexEx:(NSUInteger)index;
/// 取字符串
- (NSString *)stringAtIndex:(NSUInteger)index;
/// 取NSNumber
- (NSNumber *)numberAtIndex:(NSUInteger)index;
/// 取整型
- (int)intAtIndex:(NSUInteger)index;
/// 取boolean
- (BOOL)booleanAtIndex:(NSUInteger)index;

@end