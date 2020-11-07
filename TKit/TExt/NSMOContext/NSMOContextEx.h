//
//  NSManagedObjectContextEx
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

/// 获取实例名称
#define k_EntityName(tClass)            NSStringFromClass([tClass class])
/// 获取描述查询fmt  key:属性名   tValue:目标值
#define k_Predicate_fmt(key, tValue)    [NSString stringWithFormat : "%@ == %@", key, tValue]

#import <CoreData/CoreData.h>
#import "TDefine.h"

@interface NSMObjectContextEx : NSManagedObjectContext

@end

#pragma mark - -------- 扩展 ----------

@interface NSManagedObjectContext (EasyFetch)

/// insert 记录
- (void)insertObjectEx:(NSManagedObject *)object;

/// insert 记录
- (id)insertRecord:(NSString *)name;

/// insert 记录
- (id)insertEntityByClass:(Class)entityClass;

/// insert 记录 setting:设置block
- (id)insertRecord:(NSString *)name setting:(TBlock)setting;

#pragma mark - -------- New Record ----------
/// new 记录
- (id)newRecord:(NSString *)name;

/// new 记录 setting:设置block
- (id)newRecord:(NSString *)name setting:(TBlock)setting;

#pragma mark - -------- Delete Record ----------

/// Delete all records
- (BOOL)deleteRecord:(NSString *)name;

/// Delete object
- (BOOL)deleteObjectEx:(NSManagedObject *)object;

#pragma mark - -------- Fetch Record ----------

/// 根据实体name, query 记录
- (id)firstRecord:(NSString *)name;

/// 根据实体name, query 记录
- (id)lastRecord:(NSString *)name;

/// 根据实体name, query 记录
- (NSArray *)fetchRecord:(NSString *)name;

/// 根据实体name, query 记录
- (NSArray *)fetchRecord:(NSString *)name sortKey:(NSString *)key ascending:(BOOL)ascending;

- (NSArray *)fetchRecord:(NSString *)name sortWith:(NSArray *)sortDescriptors;

/// 根据实体name, query 记录
- (NSArray *)fetchRecord:(NSString *)name predicate:(NSPredicate *)predicate;

/// 根据实体name, query 记录
- (NSArray *)fetchRecord:(NSString *)name predicateFormat:(NSString *)format, ...;

#pragma mark - -------- Fetch Record and sorted ----------

- (NSArray *)fetchRecord:(NSString *)name sortKey:(NSString *)key ascending:(BOOL)ascending predicateFormat:(NSString *)format, ...;

- (NSArray *)fetchRecord:(NSString *)name sortKey:(NSString *)key ascending:(BOOL)ascending predicate:(NSPredicate *)predicate;

- (NSArray *)fetchRecord:(NSString *)name sortWith:(NSArray *)sortDescriptors predicate:(NSPredicate *)predicate;

- (NSArray *)fetchRecord:(NSString *)name sortWith:(NSArray *)sortDescriptors predicateFormat:(NSString *)format, ...;

#pragma mark - -------- Fetch Record with equals & contains----------
/// 根据实体name, query 记录  equals:包含键值
- (NSArray *)fetchRecord:(NSString *)name where:(NSString *)key contains:(id)value;

/// 根据实体name, query 记录  equals:包含键值
- (NSArray *)fetchRecord:(NSString *)name where:(NSString *)key contains:(id)value sortDescriptor:(NSSortDescriptor *)descriptor;

/// 根据实体name, query 记录  equals:与键值相等
- (NSArray *)fetchRecord:(NSString *)name where:(NSString *)key equals:(id)value;

/// 根据实体name, query 记录  equals:与键值相等
- (NSArray *)fetchRecord:(NSString *)name where:(NSString *)key equals:(id)value sortDescriptor:(NSSortDescriptor *)descriptor;

@end