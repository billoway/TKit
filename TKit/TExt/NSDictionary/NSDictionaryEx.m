//
//  NSDictionaryEx.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "NSDictionaryEx.h"
#import "TExt.h"
#include <objc/runtime.h>

@implementation DicExt

+ (DicExt *)dicExt
{
    return [[DicExt alloc] init];
}

- (id)init
{
    self = [super init];

    if (self) {
        self.allKeys = [NSMutableArray array];
        self.allValues = [NSMutableArray array];
    }

    return self;
}

- (void)addObj:(id)value forKey:(NSString *)key
{
    if (!key) {
        return;
    }

    if (!value) {
        value = @"";
    }

    [self.allKeys addObject:key];
    [self.allValues addObject:value];
}

- (void)addAutoviewObj:(id)value forKey:(NSString *)key
{
    if (k_Is_Empty(key) || k_Is_Empty(value)) {
        return;
    }

    [self.allKeys addObject:key];
    [self.allValues addObject:value];
}

- (void)addUnNilObj:(id)value forKey:(NSString *)key
{
    if (!key) {
        return;
    }

    if (!value || [value isEqualToString:@""]) {
        value = @" ";
    }

    [self.allKeys addObject:key];
    [self.allValues addObject:value];
}

// - (void)setObj:(id)value forKey:(NSString *)key
// {}

- (void)insertObj:(id)value forKey:(NSString *)key atIndex:(NSInteger)atIndex
{
    if (!key) {
        return;
    }

    if (!value) {
        value = @"";
    }

    [self.allKeys insertObject:key atIndex:atIndex];
    [self.allValues insertObject:value atIndex:atIndex];
}

- (void)deleteObjAtIndex:(NSInteger)index
{
    if (self.count <= index) {
        return;
    }

    [self.allKeys removeObjectAtIndex:index];
    [self.allValues removeObjectAtIndex:index];
}

// 获取指定的key 对应的value
- (id)objectForKey:(NSString *)key
{
    if (!key || [key isEqualToString:@""] || ![self.allKeys containsObject:key]) {
        return nil;
    }

    NSInteger index = [self.allKeys indexOfObject:key];
    return [self.allValues objectAtIndex:index];
}

// key 寻 index
- (NSInteger)indexForKey:(NSString *)key
{
    NSInteger index = -1;

    if (key && ![key isEqualToString:@""] && [self.allKeys containsObject:key]) {
        index = [self.allKeys indexOfObject:key];
    }

    return index;
}

// 获取指定下标的value
- (id)objectAtIndex:(NSUInteger)index
{
    if (self.count <= index) {
        return nil;
    }

    return [self.allValues objectAtIndex:index];
}

// 获取指定下标的key
- (id)keyAtIndex:(NSUInteger)index
{
    if (self.count <= index) {
        return nil;
    }

    return [self.allKeys objectAtIndex:index];
}

- (NSString *)getNullTitle:(NSInteger)index
{
    if (self.count <= index) {
        return nil;
    }

    NSString *value = [self.allValues objectAtIndex:index];

    if (!value || [value isEqualToString:@""]) {
        return [@"请填写" appendStr :[self.allKeys objectAtIndex:index]];
    } else if ([value isContain:@"请选择"]) {
        return [@"请选择" appendStr :[self.allKeys objectAtIndex:index]];
    }

    return nil;
}

- (NSString *)getUnNumberTitleAtIndex:(NSInteger)index
{
    if (self.count <= index) {
        return nil;
    }

    NSString *value = [self.allValues objectAtIndex:index];

    if (![value isNumber]) {
        return [@"请填写正确的" appendStr :[self.allKeys objectAtIndex:index]];
    }

    return nil;
}

- (NSUInteger)count
{
    return self.allKeys.count;
}

@end

@implementation NSDictionary (Ext)

#pragma mark - -------- dic => json ----------
- (NSString *)JSONStrEx
{
    NSMutableString *json = [NSMutableString string];

    [json addStr:@"{"];

    id          allKeys = [self allKeys];
    NSInteger   count = [allKeys count];

    for (int i = 0; i < count; i++) {
        NSString *key = [allKeys objectAtIndex:i];
        [json addStr:k_Json_Str([key deleteSpaceAndLine], [[self objectForKey:key] deleteSpaceAndLine])];

        if (i != count - 1) {
            [json addStr:@","];
        }
    }

    [json addStr:@"}"];
    return json;
}

/// 字典 ==> 指定 class 的对象
- (id)objectByClass:(Class)tClass;
{
    id value = [[tClass alloc] init];

    for (id key in [self allKeys]) {
        if ([value respondsToSelector:NSSelectorFromString(key)]) {
            [value setValue:[self objectForKey:key] forKey:key];
        }
    }

    return value;
}

/// 对象 ==> 字典
+ (id)dictionaryByObject:(id)object
{
    Class           clazz = [object class];
    u_int           count;
    objc_property_t *properties = class_copyPropertyList(clazz, &count);

    NSMutableArray  *propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray  *valueArray = [NSMutableArray arrayWithCapacity:count];

    for (int i = 0; i < count; i++) {
        objc_property_t prop = properties[i];
        const char      *propertyName = property_getName(prop);

        id key = [NSString stringWithUTF8String:propertyName];

        if (![key isEqualToString:@"description"] && ![key isEqualToString:@"debugDescription"]) {
            [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];

            //            id value = [object performSelector:NSSelectorFromString(key)];
            id value;
            SuppressPerformSelectorLeakWarning(value = [object performSelector:NSSelectorFromString(key)]);

            if (value == nil) {
                [valueArray addObject:@""];
            } else {
                [valueArray addObject:value];
            }
        }
    }

    free(properties);

    return [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
}

#pragma mark - -------- objectForKey Ex ----------

- (NSString *)stringForKey:(id)aKey
{
    id value = [self objectForKey:aKey];

    if (!value || [value isEqual:[NSNull null]]) {
        return @"";
    } else if (![value isKindOfClass:[NSString class]]) {
        return [NSString stringById:value];
    }

    return value;
}

- (NSNumber *)numberForKey:(id)aKey
{
    id value = [self objectForKey:aKey];

    if (!value || [value isEqual:[NSNull null]]) {
        return @0;
    } else if ([value isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithDouble:[value doubleValue]];
    }

    return value;
}

- (int)intForKey:(id)aKey
{
    return [[self objectForKey:aKey] intValue];
}

- (BOOL)booleanForKey:(id)aKey
{
    return [[self objectForKey:aKey] boolValue];
}

@end