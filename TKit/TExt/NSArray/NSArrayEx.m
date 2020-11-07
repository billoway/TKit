//
//  NSArrayEx.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "NSArrayEx.h"
#import "TExt.h"
#import "NSString+parse.h"


@implementation NSMutableArray (Ext)

/// 可变数组中元素位置移动
- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from) {
        __strong id obj = [self objectAtIndex:from];
        [self removeObjectAtIndex:from];

        if (to >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:to];
        }
    }
}

/// 往数组中添加元素 为空不崩溃
- (void)addObjectEx:(id)anObject
{
    if (anObject) {
        if ([anObject isKindOfClass:[NSString class]]) {
            if (k_Is_Empty(anObject)) {
                DLog(" [__NSArrayM insertObject:atIndex:] string cannot be empty");
                return;
            }
        }

        [self addObject:anObject];
    } else {
        DLog(" [__NSArrayM insertObject:atIndex:] object cannot be nil");
    }
}

/// 删除 index下标的元素 越界不崩溃
- (void)removeObjectAtIndexEx:(NSUInteger)index
{
    if ((index < self.count)) {
        [self removeObjectAtIndex:index];
    } else {
        DLog(@" [__NSArrayM removeObjectAtIndex:]: index %d beyond bounds [0 .. %d]", index, self.count);
    }
}

@end

@implementation NSArray (Ext)

- (id)objectAtIndexEx:(NSUInteger)index
{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }

    DLog(@" [__NSArrayM objectAtIndex:] index %d beyond bounds [0 .. %d]", index, self.count);
    return nil;
}

- (NSString *)stringAtIndex:(NSUInteger)index
{
    id value = [self objectAtIndexEx:index];

    if (!value || [value isEqual:[NSNull null]]) {
        return @"";
    } else if (![value isKindOfClass:[NSString class]]) {
        return [NSString stringById:value];
    }

    return value;
}

- (NSNumber *)numberAtIndex:(NSUInteger)index
{
    id value = [self objectAtIndexEx:index];

    if (!value || [value isEqual:[NSNull null]]) {
        return @0;
    } else if ([value isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithDouble:[value doubleValue]];
    }

    return value;
}

- (int)intAtIndex:(NSUInteger)index
{
    return [[self objectAtIndexEx:index] intValue];
}

- (BOOL)booleanAtIndex:(NSUInteger)index
{
    return [[self objectAtIndexEx:index] boolValue];
}

@end