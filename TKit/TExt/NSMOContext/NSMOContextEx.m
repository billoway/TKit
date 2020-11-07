//
//  NSManagedObjectContextEx.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "NSMOContextEx.h"

#define k_ARR(args) args ? @[args] : nil

@implementation NSMObjectContextEx

@end

#pragma mark - -------- 扩展 ----------

@implementation NSManagedObjectContext (EasyFetch)

#pragma mark - -------- Insert Record ----------

/// insert 记录
- (void)insertObjectEx:(NSManagedObject *)object
{
    [self insertObject:object];
    [self save:NULL];
}

/// insert 记录
- (id)insertRecord:(NSString *)name
{
    return [self insertRecord:name setting:NULL];
}

/// insert 记录
- (id)insertEntityByClass:(Class)entityClass
{
    return [self insertRecord:NSStringFromClass(entityClass)];
}

/// insert 记录 setting:设置block
- (id)insertRecord:(NSString *)name setting:(TBlock)setting
{
    NSManagedObject *tModel = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];

    if (setting) {
        TBlock tSetting = [setting copy];
        tSetting(tModel);
    }

    return tModel;
}

#pragma mark - -------- New Record ----------
/// new 记录
- (id)newRecord:(NSString *)name
{
    return [self newRecord:name setting:NULL];
}

/// new 记录 setting:设置block
- (id)newRecord:(NSString *)name setting:(TBlock)setting
{
    id model = [NSEntityDescription entityForName:name inManagedObjectContext:self];
    NSManagedObject *tModel = model;

    if ([model isKindOfClass:[NSEntityDescription class]]) {
        tModel = [[NSManagedObject alloc] initWithEntity:model insertIntoManagedObjectContext:nil];
    }

    if (setting) {
        TBlock tSetting = [setting copy];
        tSetting(tModel);
    }

    return tModel;
}

#pragma mark - -------- Delete Record ----------

/// Delete all records
- (BOOL)deleteRecord:(NSString *)name
{
    NSArray *records = [self fetchRecord:name];

    for (NSManagedObject *object in records) {
        [self deleteObject:object];
    }

    return [self save:NULL];
}

/// Delete object
- (BOOL)deleteObjectEx:(NSManagedObject *)object
{
    [self deleteObject:object];
    return [self save:NULL];
}

#pragma mark - -------- Fetch Record ----------

/// 根据实体name, query 记录
- (id)firstRecord:(NSString *)name
{
    return [[self fetchRecord:name] firstObject];
}

/// 根据实体name, query 记录
- (id)lastRecord:(NSString *)name
{
    return [[self fetchRecord:name] lastObject];
}

/// 根据实体name, query 记录
- (NSArray *)fetchRecord:(NSString *)name
{
    return [self fetchRecord:name sortWith:nil predicate:nil];
}

/// 根据实体name, query 记录
- (NSArray *)fetchRecord:(NSString *)name sortKey:(NSString *)key ascending:(BOOL)ascending
{
    return [self fetchRecord:name sortKey:key ascending:ascending predicate:nil];
}

- (NSArray *)fetchRecord:(NSString *)name sortWith:(NSArray *)sortDescriptors
{
    return [self fetchRecord:name sortWith:sortDescriptors predicate:nil];
}

/// 根据实体name, query 记录
- (NSArray *)fetchRecord:(NSString *)name predicate:(NSPredicate *)predicate
{
    return [self fetchRecord:name sortWith:nil predicate:predicate];
}

/// 根据实体name, query 记录
- (NSArray *)fetchRecord:(NSString *)name predicateFormat:(NSString *)format, ...
{
    va_list variadicArguments;
    va_start(variadicArguments, format);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format arguments:variadicArguments];
    va_end(variadicArguments);

    return [self fetchRecord:name sortWith:nil predicate:predicate];
}

#pragma mark - -------- Fetch Record and sorted ----------

- (NSArray *)fetchRecord:(NSString *)name sortKey:(NSString *)key ascending:(BOOL)ascending predicateFormat:(NSString *)format, ...
{
    va_list variadicArguments;
    va_start(variadicArguments, format);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format arguments:variadicArguments];
    va_end(variadicArguments);

    return [self fetchRecord:name sortKey:key ascending:ascending predicate:predicate];
}

- (NSArray *)fetchRecord:(NSString *)name sortKey:(NSString *)key ascending:(BOOL)ascending predicate:(NSPredicate *)predicate
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];

#if !__has_feature(objc_arc)
    [sort autorelease];
#endif

    id arrSorts = k_ARR(sort);

    return [self fetchRecord:name sortWith:arrSorts predicate:predicate];
}

- (NSArray *)fetchRecord:(NSString *)name sortWith:(NSArray *)sortDescriptors predicate:(NSPredicate *)predicate
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:self];
    NSFetchRequest      *request = [[NSFetchRequest alloc] init];

#if !__has_feature(objc_arc)
    [request autorelease];
#endif

    [request setEntity:entity];

    if (predicate) {
        [request setPredicate:predicate];
    }

    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }

    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];

    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [NSException raise:NSGenericException format:@"%@", [error description]];
    }

    return results;
}

- (NSArray *)fetchRecord:(NSString *)name sortWith:(NSArray *)sortDescriptors predicateFormat:(NSString *)format, ...
{
    va_list variadicArguments;
    va_start(variadicArguments, format);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format arguments:variadicArguments];
    va_end(variadicArguments);

    return [self fetchRecord:name sortWith:sortDescriptors predicate:predicate];
}

#pragma mark - -------- Fetch Record with equals & contains----------
/// 根据实体name, query 记录  equals:包含键值
- (NSArray *)fetchRecord:(NSString *)name where:(NSString *)key contains:(id)value
{
    return [self fetchRecord:name where:key contains:value sortDescriptor:nil];
}

/// 根据实体name, query 记录  equals:包含键值
- (NSArray *)fetchRecord:(NSString *)name where:(NSString *)key contains:(id)value sortDescriptor:(NSSortDescriptor *)descriptor
{
    NSPredicate *predicate = nil;

    if (key && value) {
        NSString *predicateString = [NSString stringWithFormat:@"self.%@ contains[c] \"%@\"", key, value];
        predicate = [NSPredicate predicateWithFormat:predicateString];
    }

    return [self fetchRecord:name sortWith:k_ARR(descriptor)];
}

/// 根据实体name, query 记录  equals:与键值相等
- (NSArray *)fetchRecord:(NSString *)name where:(NSString *)key equals:(id)value
{
    return [self fetchRecord:name where:key equals:value sortDescriptor:nil];
}

/// 根据实体name, query 记录  equals:与键值相等
- (NSArray *)fetchRecord:(NSString *)name where:(NSString *)key equals:(id)value sortDescriptor:(NSSortDescriptor *)descriptor
{
    if (key && value) {
        if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSDate class]]) {
            NSPredicate *predicate;

            if (key && value) {
                predicate = [NSPredicate predicateWithFormat:@"self.%@ == %@", key, value];
            }

            return [self fetchRecord:name sortWith:k_ARR(descriptor) predicate:predicate];
        }
        else {
            NSArray *allObjects = [self fetchRecord:name sortWith:k_ARR(descriptor)];

            NSMutableArray *filteredArray = [[NSMutableArray alloc] init];

            for (NSManagedObject *object in allObjects) {
                if ([[object valueForKey:key] isEqual:value]) {
                    [filteredArray addObject:object];
                }
            }

            return filteredArray;
        }
    }
    else {
        return [self fetchRecord:name sortWith:k_ARR(descriptor)];
    }
}

@end