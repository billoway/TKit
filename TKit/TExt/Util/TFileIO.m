//
//  TFileIO
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TFileIO.h"
#import "TDefine.h"
#import "NSDataEx.h"

@implementation TFileIO

#pragma mark - -------- Write_To_Path ----------

/// 字符串写入(本地加密) filePath:文件的完整路径
+ (void)writeEncryStrToPath:(NSString *)filePath content:(NSString *)content;
{
    if (![self createDirectoryForFilePath:filePath] || !content) {
        return;
    }

#ifdef DEBUG
    [self doWrite:[content dataUsingEncoding:NSUTF8StringEncoding] filePath:filePath];
#else
    [self doWrite:[[content dataUsingEncoding:NSUTF8StringEncoding] EncryptDES:@"DES"] filePath:filePath];
#endif
}

/// 字符串写入           filePath:文件的完整路径
+ (void)writeStrToPath:(NSString *)filePath content:(NSString *)content;
{
    if (![self createDirectoryForFilePath:filePath] || !content) {
        return;
    }

    [self doWrite:[content dataUsingEncoding:NSUTF8StringEncoding] filePath:filePath];
}

/// Plist流写入(字典, 数组) filePath:文件的完整路径
+ (void)writePlistToPath:(NSString *)filePath content:(id)content;
{
    if (![self createDirectoryForFilePath:filePath] || !content) {
        return;
    }

    BOOL isSuccess = [content writeToFile:filePath atomically:YES];

    if (!isSuccess) {
        DLog("--- (%@)缓存写入失败", filePath);
    }
}

/// 文件流写入       filePath:文件的完整路径
+ (void)writeDataToPath:(NSString *)filePath content:(NSData *)content;
{
    if (![self createDirectoryForFilePath:filePath] || !content) {
        return;
    }

    [self doWrite:content filePath:filePath];
}

/// 图片写入        filePath:文件的完整路径
+ (void)writeImgToPath:(NSString *)filePath content:(UIImage *)content;
{
    if (![self createDirectoryForFilePath:filePath]) {
        return;
    }

    NSData *imgData = UIImageJPEGRepresentation(content, 1.0);
    [self doWrite:imgData filePath:filePath];
}

#pragma mark - -------- Read_From_Path ----------

/// 读取字符串(本地加密) filePath:文件的完整路径
+ (NSString *)readEncryStrFromPath:(NSString *)filePath;
{
    NSData *reader = [NSData dataWithContentsOfFile:filePath];

#ifndef DEBUG
    reader = [reader DecryptDES:@"DES"];
#endif
    NSString *content = [[NSString alloc] initWithData:[reader subdataWithRange:NSMakeRange(0, reader.length)] encoding:NSUTF8StringEncoding];

    return content;
}

/// 读取字符串 filePath:文件的完整路径
+ (NSString *)readStrFromPath:(NSString *)filePath;
{
    NSData *reader = [NSData dataWithContentsOfFile:filePath];

    NSString *content = [[NSString alloc] initWithData:[reader subdataWithRange:NSMakeRange(0, reader.length)] encoding:NSUTF8StringEncoding];

    return content;
}

/// 读取文件流 filePath:文件的完整路径
+ (NSData *)readDataFromPath:(NSString *)filePath;
{
    return [NSData dataWithContentsOfFile:filePath];
}

/// 读取Plist filePath:文件的完整路径
+ (id)readPlistFromPath:(NSString *)filePath;
{
    id result = [NSArray arrayWithContentsOfFile:filePath];

    if (result) {
        return [NSMutableArray arrayWithArray:result];
    }

    result = [NSDictionary dictionaryWithContentsOfFile:filePath];

    if (result) {
        return [NSMutableDictionary dictionaryWithDictionary:result];
    }

    return nil;
}


#pragma mark - -------- 删除 【目录或文件】----------

/// 删除文件    filePath:文件路径，可以包括路径和文件名称
+ (void)deleteFileAtPath:(NSString *)filePath;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    [fileManager changeCurrentDirectoryPath:[NSHomeDirectory() stringByExpandingTildeInPath]];

    // 删除目录或者文件
    __autoreleasing NSError *tError = nil;

    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:&tError];

        if (tError) {
            DLog(" ---- (%@) 缓存删除失败  \n  %@", filePath, tError);
        }
    }
}


/// 读取文件夹大小
+ (float)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];

    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }

    NSEnumerator    *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString        *fileName;
    long long folderSize = 0;

    while ( (fileName = [childFilesEnumerator nextObject]) != nil ) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
//        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        folderSize += [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
    }

    return folderSize / (1024.0 * 1024.0);
}

/// 读取文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }

    return 0;
}

#pragma mark - -------- private ----------

+ (void)doWrite:(NSData *)content filePath:(NSString *)filePath
{
    NSMutableData *writer = [[NSMutableData alloc] init];

    [writer appendData:content];
    BOOL isSuccess = [writer writeToFile:filePath atomically:YES];

    if (!isSuccess) {
        DLog("--- (%@)缓存写入失败", filePath);
    }
}

+ (BOOL)createDirectoryForFilePath:(NSString *)path
{
    if (!path || ![path hasPrefix:@"/"]) {
        DLog("--- (%@) 路径无效 缓存写入失败", path);
        return NO;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager changeCurrentDirectoryPath:[NSHomeDirectory() stringByExpandingTildeInPath]];

    // 创建目录
    NSString *directory = [path stringByDeletingLastPathComponent];

    if (directory && ![fileManager fileExistsAtPath:directory]) {
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }

    // 创建文件缓冲区
    [fileManager createFileAtPath:path contents:nil attributes:nil];
    return YES;
}

@end