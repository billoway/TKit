//
//  TFileIO
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFileIO : NSObject

#pragma mark - -------- Write_To_Path ----------

/// 字符串写入(本地加密) filePath:文件的完整路径
+ (void)writeEncryStrToPath:(NSString *)filePath content:(NSString *)content;

/// 字符串写入           filePath:文件的完整路径
+ (void)writeStrToPath:(NSString *)filePath content:(NSString *)content;

/// Plist流写入(字典, 数组) filePath:文件的完整路径
+ (void)writePlistToPath:(NSString *)filePath content:(id)content;

/// 文件流写入       filePath:文件的完整路径
+ (void)writeDataToPath:(NSString *)filePath content:(NSData *)content;

/// 图片写入        filePath:文件的完整路径
+ (void)writeImgToPath:(NSString *)filePath content:(UIImage *)content;

#pragma mark - -------- Read_From_Path ----------

/// 读取字符串(本地加密) filePath:文件的完整路径
+ (NSString *)readEncryStrFromPath:(NSString *)filePath;

/// 读取字符串 filePath:文件的完整路径
+ (NSString *)readStrFromPath:(NSString *)filePath;

/// 读取文件流 filePath:文件的完整路径
+ (NSData *)readDataFromPath:(NSString *)filePath;

/// 读取Plist filePath:文件的完整路径
+ (id)readPlistFromPath:(NSString *)filePath;


#pragma mark - -------- fileAtttbuite ----------

/// 读取文件夹大小
+ (float)folderSizeAtPath:(NSString *)folderPath;
/// 读取文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath;

#pragma mark - -------- 删除 【目录或文件】----------

/// 删除文件    filePath:文件路径，可以包括路径和文件名称
+ (void)deleteFileAtPath:(NSString *)filePath;

@end