//
//  TOpenUrl
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "TOpenUrl.h"
#import "TExt.h"

@interface TOpenUrl () <UIWebViewDelegate>

/// webview 用来呼叫
@property (nonatomic, strong) UIWebView *_webView;
/// 呼叫的电话
@property (nonatomic, strong) NSString *_callNum;

SINGLETON_FOR_CLASS_HEADER(TOpenUrl);

@end

@implementation TOpenUrl

+ (void)openUrl:(NSString *)url
{
    NSString    *tStr = [NSString stringWithFormat:@"%@", url];
    NSURL       *tUrl = [[NSURL alloc] initWithString:tStr];

    [[UIApplication sharedApplication] openURL:tUrl];
}


#pragma mark - -------- 拨打电话 ----------

+ (void)openTel:(NSString *)url
{
    NSURL           *tUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", url]];
    NSURLRequest    *tRequest = [NSURLRequest requestWithURL:tUrl];

    [self getInstance]._callNum = url;
    [[self getInstance] call:tRequest];

    if (Is_Simulator) {
        [[self getInstance] showAlert:url done:@"呼叫" cancel:@"取消" click:^(NSInteger index) { }
        ];
    }
}

+ (void)openUtilDidActive
{
    [self getInstance]._callNum = nil;
}

#pragma mark - -------- 发送短信 ----------
/// 发送短信
+ (void)openSMS:(id)args;
{
    
}
#pragma mark - -------- 发送email ----------

/// 发送EMail
+ (void)openMail:(id)args;
{
    
}


/// 调起APP
+ (void)openApp:(NSString *)url args:(id)args;
{
    
}
/// 打开地图导航
+ (void)openMap:(id)args;
{
    
}

#pragma mark - -------- private ----------

SINGLETON_FOR_CLASS(TOpenUrl);

- (void)call:(NSURLRequest *)tRequest
{
    if (!self._webView) {
        self._webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        self._webView.delegate = self;
    }

    [self._webView loadRequest:tRequest];
}

@end