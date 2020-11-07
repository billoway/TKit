//
//  CoreDataCenter
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

// 添加CoreData 类型,根据不同的CoreData 类型, 用不同的CoreData 上下文管理数据
/// CoreData type ,用于管理不同的 CoreData 上下文
typedef NS_OPTIONS(NSUInteger, CDType) {
    CDDefaultType = 100,
    CDType_1,
    CDType_2,
    CDType_3,
    CDType_4,
    CDType_5,
};

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSMOContextEx.h"
#import "TDefine.h"

typedef CDType CustomCDType;

@interface TCDCenter : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext          *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel            *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator    *persistentStoreCoordinator;

+ (TCDCenter *)getInstance;
/// 默认上下文
+ (NSManagedObjectContext *)context;
/// 根据 type 获取 上下文
+ (NSManagedObjectContext *)context:(CDType)type;

/// save 默认上下文
+ (void)saveContext;
/// 根据 type save 上下文
+ (void)saveContext:(CDType)CDType;

/// update 默认上下文
+ (void)updateDB;
/// 根据 type update 上下文
+ (void)updateDB:(CDType)CDType;

@end

@interface TDefine (TCDCenter)
/// 设置默认 CoreData model 名称
+ (void)regist_CDModelFileName:(NSString *)name;
/// 设置默认 CoreData 数据库文件 名称
+ (void)regist_CDDBFileName:(NSString *)name;

@end

