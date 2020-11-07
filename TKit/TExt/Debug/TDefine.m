//
//  Debug.m
//  TExt
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TDefine.h"


@implementation TDefine

SINGLETON_FOR_CLASS(TDefine);

+ (void)DE_TLog:(NSString *)format, ...
{
    if ( (nil == format) || (NO == [format isKindOfClass:[NSString class]]) ) {
        return;
    }

    //    ((@"==> %s [line %d]" fmt), __FUNCTION__, __LINE__,  ##__VA_ARGS__)
    NSMutableString *text = [NSMutableString string];
    va_list args;
    va_start(args, format);

    NSString *content = [[NSString alloc] initWithFormat:(NSString *)format arguments:args];

    if (content && content.length) {
        [text appendString:content];
    }

    va_end(args);

    fprintf(stderr, [text UTF8String], NULL);
    fprintf(stderr, "\n", NULL);
}

-(id) init
{
    self = [super init];
    if (self) {
        Connect_cfg cfg;
        cfg.debug_log_req = YES;
        cfg.debug_log_resp = YES;
        cfg.debug_log_resp_cache = YES;
        self.req_cfg = cfg;
    }
    return self;
}

@end

