//
//  BaseModel
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TBModel.h"
#import "TExt.h"
#import "TConstants.h"

#pragma mark - -------- TBModel ----------

@implementation TBModel

- (id)init
{
    self = [super init];

    if (self) {
        self.code = @"-1";
        self.message = @"";
        self.pageno = 1;
    }

    return self;
}

- (void)parseValue:(id)param
{
    [self parseProperty:param];
}

- (BOOL)_isSuccess
{
    return ![self.code boolValue];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:
                      @"Model:【%@】code:【%@】",
                      NSStringFromClass([self class]), self.code
                     ];

    return desc;
}

@end
#pragma mark - -------- BCDModel ----------

@implementation BCDModel

@dynamic code;
@dynamic isSuccess;
@dynamic message;
@dynamic pageno;
@synthesize cmd;

- (void)initCDModel
{
    self.code = @"-1";
    self.message = @"";
    self.pageno = 1;
}

- (void)parseValue:(id)param
{
    [self parseProperty:param];
}

- (BOOL)_isSuccess
{
    return ![self.code boolValue];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:
                      @"Model:【%@】code:【%@】",
                      NSStringFromClass([self class]), self.code
                     ];

    return desc;
}

@end

#pragma mark - -------- CustomKVC ----------

@implementation NSObject (CustomKVC)

- (void)setValueEx:(id)value forKey:(NSString *)key
{
    if ([value isEqual:[NSNull null]]) {
        value = @"";
    }

    if (![self contantsKey:key]) {
        return;
    }

    [self setValue:value forKey:key];
}

- (BOOL)contantsKey:(NSString *)key
{
    SEL sel = NSSelectorFromString(key);

    return [self respondsToSelector:sel];
}

@end

@implementation TBModel (parseValue)
/// 解析value param:字典或者数组 valueClass:数据模型 解析到TBModel时 返回自己 无需使用
- (id)parseValue:(id)param valueClass:(Class)cls;
{
    if ([param isKindOfClass:[NSDictionary class]]) {
        id item = [[cls alloc] init];

        for (id key in[param allKeys]) {
            id value = [param objectForKey:key];

            if (![value isKindOfClass:[NSDictionary class]] && ![value isKindOfClass:[NSArray class]]) {
                [item setValueEx:[param objectForKey:key] forKey:[NSString stringWithFormat:@"_%@", key]];
            }
        }

        return item;
    }
    else if ([param isKindOfClass:[NSArray class]]) {
        NSMutableArray *tItems = [NSMutableArray array];

        for (id aItem in param) {
            id item = [self parseValue:aItem valueClass:cls];
            [tItems addObjectEx:item];
        }

        return tItems;
    }

    return nil;
}

/// 解析value ==> 返回到 self._property  param:字典或者数组
- (void)parseProperty:(id)param
{
    if ([param isKindOfClass:[NSDictionary class]]) {
        for (id key in[param allKeys]) {
            id value = [param objectForKey:key];

            if (![value isKindOfClass:[NSDictionary class]] && ![value isKindOfClass:[NSArray class]]) {
                [self setValueEx:[param objectForKey:key] forKey:[NSString stringWithFormat:@"_%@", key]];
            }
        }
    }
}

@end

@implementation BCDModel (parseValue)

/// 解析value param:字典或者数组 valueClass:数据模型
- (id)parseValue:(id)param valueClass:(Class)cls;
{
    if ([param isKindOfClass:[NSDictionary class]]) {
        id item = [[cls alloc] init];

        for (id key in[param allKeys]) {
            [item setValueEx:[param objectForKey:key] forKey:[NSString stringWithFormat:@"%@", key]];
        }

        return item;
    }
    else if ([param isKindOfClass:[NSArray class]]) {
        NSMutableArray *tItems = [NSMutableArray array];

        for (id aItem in param) {
            id item = [self parseValue:aItem valueClass:cls];
            [tItems addObjectEx:item];
        }

        return tItems;
    }

    return nil;
}

/// 解析value ==> 返回到 self._property  param:字典或者数组
- (void)parseProperty:(id)param
{
    if ([param isKindOfClass:[NSDictionary class]]) {
        for (id key in[param allKeys]) {
            id value = [param objectForKey:key];

            if (![value isKindOfClass:[NSDictionary class]] && ![value isKindOfClass:[NSArray class]]) {
                [self setValueEx:[param objectForKey:key] forKey:[NSString stringWithFormat:@"%@", key]];
            }
        }
    }
}

@end