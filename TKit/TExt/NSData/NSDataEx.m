//
//  NSData+AES.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "NSDataEx.h"
#import "TExt.h"

@implementation NSData (Ext)

#pragma mark - -------- AES ----------

- (NSData *)EncryptDES:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256 + 1];

    bzero(keyPtr, sizeof(keyPtr));

    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF16StringEncoding];
    size_t numBytesEncrypted = 0;

    NSUInteger dataLength = [self length];

    size_t  bufferSize = dataLength + kCCBlockSizeAES128;
    void    *buffer = malloc(bufferSize);

    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
            keyPtr, kCCKeySizeAES256,
            NULL,
            [self bytes], [self length],
            buffer, bufferSize,
            &numBytesEncrypted);

    if (result == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }

    CFRelease(buffer);

    return nil;
}

- (NSData *)DecryptDES:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256 + 1];

    bzero(keyPtr, sizeof(keyPtr));

    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF16StringEncoding];

    size_t numBytesEncrypted = 0;

    NSUInteger dataLength = [self length];

    size_t  bufferSize = dataLength + kCCBlockSizeAES128;
    void    *buffer_decrypt = malloc(bufferSize);

    CCCryptorStatus result = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
            keyPtr, kCCKeySizeAES256,
            NULL,
            [self bytes], [self length],
            buffer_decrypt, bufferSize,
            &numBytesEncrypted);

    if (result == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer_decrypt length:numBytesEncrypted];
    }

    return nil;
}

#pragma mark - -------- AES ----------

- (NSData *)AES256EncryptWithKey:(NSString *)key options:(CCOptions)options iv:(NSString *)iv
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128 + 1];  // room for terminator (unused)

    bzero(keyPtr, sizeof(keyPtr));      // fill with zeroes (for padding)

    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [self length];

    // See the doc: For block ciphers, the output size will always be less than or
    // equal to the input size plus the size of one block.
    // That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    // ( kCCBlockSizeAES128-dataLength%kCCBlockSizeAES128);
    void *buffer = malloc(bufferSize);

    // --- 手动填0
    size_t  bufferSizeCp = dataLength + (kCCBlockSizeAES128 - dataLength % kCCBlockSizeAES128);
    void    *bufferCp = malloc(bufferSizeCp);
    memset(bufferCp, 0, bufferSizeCp);
    memcpy(bufferCp, [self bytes], dataLength);
    //    memccpy(bufferCp, [self bytes], 0, dataLength);

    size_t          numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, options,
            keyPtr, kCCKeySizeAES128,
            [iv UTF8String] /* initialization vector (optional) */,
            bufferCp, bufferSizeCp, /* input */
            buffer, bufferSize,     /* output */
            &numBytesEncrypted);
    free(bufferCp);                 // free the buffer;

    if (cryptStatus == kCCSuccess) {
        // the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }

    free(buffer); // free the buffer;
    return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key options:(CCOptions)options iv:(NSString *)iv
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    //	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    char keyPtr[kCCKeySizeAES128 + 1];  // room for terminator (unused)

    bzero(keyPtr, sizeof(keyPtr));      // fill with zeroes (for padding)

    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [self length];

    // See the doc: For block ciphers, the output size will always be less than or
    // equal to the input size plus the size of one block.
    // That's why we need to add the size of one block here
    size_t  bufferSize = dataLength + kCCBlockSizeAES128;
    void    *buffer = malloc(bufferSize);

    size_t          numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, options,
            keyPtr, kCCKeySizeAES128,
            [iv UTF8String] /* initialization vector (optional) */,
            [self bytes], dataLength,                           /* input */
            buffer, bufferSize,                                 /* output */
            &numBytesDecrypted);

    if (cryptStatus == kCCSuccess) {
        // 遍历buffer 除0
        for (NSInteger i = numBytesDecrypted - 1; i >= 0; i--) {
            if (((char *)buffer)[i] != 0) {
                numBytesDecrypted = i + 1;
                break;
            }
        }

        // the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }

    free(buffer); // free the buffer;
    return nil;
}

#pragma mark - -------- Base64 ----------
/// data 2 base64String
- (NSString *)base64String
{
    if (Is_up_Ios_7) {
        return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }

    return [self base64Encoding];
}

/// base64String 2 data
+ (id)dataWithBase64String:(NSString *)base64Strig
{
    if (Is_up_Ios_7) {
        return [[[self class] alloc] initWithBase64EncodedString:base64Strig options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }

    return [[[self class] alloc] initWithBase64Encoding:base64Strig];
}

#pragma mark - -------- UTF8 string ----------

- (NSString *)stringWithUTF8Encoding
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString *)stringWithEncoding:(NSStringEncoding)encoding
{
    return [[NSString alloc] initWithData:self encoding:encoding];
}

@end