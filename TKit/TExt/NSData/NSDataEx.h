//
//  NSData+AES.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface NSData (Ext)

#pragma mark - -------- DES ----------
/// DES 加密
- (NSData *)EncryptDES:(NSString *)key;
/// DES 解密
- (NSData *)DecryptDES:(NSString *)key;

#pragma mark - -------- AES ----------
/// aes 加密
- (NSData *)AES256EncryptWithKey:(NSString *)key options:(CCOptions)options iv:(NSString *)iv;
/// aes 解密
- (NSData *)AES256DecryptWithKey:(NSString *)key options:(CCOptions)options iv:(NSString *)iv;

#pragma mark - -------- Base64 ----------
/// ==> data 2 base64String
- (NSString *)base64String;
/// ==> base64String 2 data
+ (id)dataWithBase64String:(NSString *)base64Strig;

#pragma mark - -------- UTF8 string ----------
/// ==> data 2 string by utf8String
- (NSString *)stringWithUTF8Encoding;
/// ==> data 2 string by encoding
- (NSString *)stringWithEncoding:(NSStringEncoding)encoding;

@end