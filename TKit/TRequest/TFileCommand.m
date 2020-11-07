//
//  TFileCommand.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TFileCommand.h"

@implementation TFileCommand

- (void)addOperation:(NSOperation *)operation
{
    if (!self._queue) {
        self._queue = [NSOperationQueue new];
    }
    GCD_Main_async (^{
        [self._queue addOperation:operation];
    }
                    );
}
- (void)doResponse
{
    if (self._sourceSCreen) {
        __block TFileCommand* bSelf = self;
        GCD_Main_async(^{
            [bSelf._sourceSCreen responseFile:self];
        });
    }
}

- (void)cancelRequest
{
    [self._queue cancelAllOperations];

    if ([self._sourceSCreen respondsToSelector:@selector(responseFile:)]) {
        [self._sourceSCreen responseFile:self];
        self._sourceSCreen = nil;
    }
}

/// 失败 ==> 网络不稳定
- (void) faildNetUnconnect;
{
    
}
/// 失败 ==> 请求超时
- (void) faildRequestTimeout;
{
    
}

@end