//
//  TOpenUrl
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOpenUrl : NSObject

/// 打开Url
+ (void)openUrl:(NSString *)url;
/// 打电话
+ (void)openTel:(NSString *)url;


/// 调起APP
+ (void)openApp:(NSString *)url args:(id)args;
/// 打开地图导航
+ (void)openMap:(id)args;

/// 发送EMail
+ (void)openMail:(id)args;
/// 发送短信
+ (void)openSMS:(id)args;

@end