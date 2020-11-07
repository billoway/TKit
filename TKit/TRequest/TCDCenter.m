//
//  CoreDataCenter
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#define s_DocumentsDir [[[[NSFileManager alloc] init] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]

#import "TCDCenter.h"
#import "TConstants.h"
#import "NSStringEx.h"

@interface TCDCenter ()

@property (strong, nonatomic) NSMutableDictionary *_contexts;

@property (strong, nonatomic) NSString  *_modelFileName;
@property (strong, nonatomic) NSString  *_dbFileName;

@end
@implementation TCDCenter

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


static NSPersistentStoreCoordinator * storeCoordinator = nil;

#pragma mark - -------- 多个CD上下文管理 ----------

+ (NSManagedObjectContext *)context:(CDType)type;
{
    return [[self getInstance] managedObjectContext:type];
}

+ (void)saveContext:(CDType)type;
{
    [[self getInstance].persistentStoreCoordinator lock];
    __autoreleasing NSError *error = nil;
    NSManagedObjectContext  *managedObjectContext = [[self getInstance]._contexts objectForKey:[NSString stringByInt:type]];

    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
#ifdef DEBUG
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
            [self updateDB];
        }
    }
    [[self getInstance].persistentStoreCoordinator unlock];
}

- (NSManagedObjectContext *)managedObjectContext:(CDType)type
{
    NSManagedObjectContext *tContext = [self._contexts objectForKey:[NSString stringByInt:type]];

    if (tContext != nil) {
        return tContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

    if (coordinator != nil) {
        tContext = [[NSManagedObjectContext alloc] init];
        [tContext setPersistentStoreCoordinator:coordinator];
    }

    if (tContext) {
        [self._contexts setObject:tContext forKey:[NSString stringByInt:type]];
    }

    return tContext;
}

#pragma mark - -------- 默认的CD上下文管理 ----------

+ (NSManagedObjectContext *)context
{
    return [[self getInstance] managedObjectContext:CDDefaultType];
}

+ (void)saveContext
{
    [self saveContext:CDDefaultType];
}

/// update 默认上下文
+ (void)updateDB;
{
    [[self context] processPendingChanges];
}
/// 根据 type update 上下文
+ (void)updateDB:(CDType)CDType;
{
    [[self context:CDType] processPendingChanges];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return [self managedObjectContext:CDDefaultType];
}

#pragma mark - -------- CoreData Center ----------

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self._modelFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSString    *fileName = [NSString stringWithFormat:@"%@.db", self._dbFileName];
    NSURL       *storeURL = [s_DocumentsDir URLByAppendingPathComponent:fileName];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    NSString* stroreType;
    stroreType = NSSQLiteStoreType;

#ifndef DEBUG
    if (!Is_Simulator) {
        stroreType = NSBinaryStoreType;
    }
#endif

    if (![_persistentStoreCoordinator addPersistentStoreWithType:stroreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSFileManager* manage = [NSFileManager defaultManager];
        [manage removeItemAtURL:storeURL error:NULL];
        _managedObjectModel = nil;
        return [self persistentStoreCoordinator];
    }
    return _persistentStoreCoordinator;
}

static TCDCenter *kInstance;
+ (TCDCenter *)getInstance
{
    if (!kInstance) {
        kInstance = [[TCDCenter alloc] init];
        kInstance._contexts = [NSMutableDictionary dictionaryWithCapacity:0];
        kInstance._modelFileName = @"DataCenter";
        kInstance._dbFileName = @"Cache_debug.db";

#ifndef DEBUG
#if Is_Simulator
#else
        kInstance._dbFileName = @"Cache.db";
#endif
#endif
    }

    return kInstance;
}

@end

@implementation TDefine (TCDCenter)

+ (void)regist_CDModelFileName:(NSString *)name
{
    if (k_Is_Empty(name)) {
        return;
    }
    
    [TCDCenter getInstance]._modelFileName = name;
}

+ (void)regist_CDDBFileName:(NSString *)name
{
    if (k_Is_Empty(name)) {
        return;
    }

    [TCDCenter getInstance]._dbFileName = name;
}

@end