//
//  NSTimerEx.h
//  TKit
//
//  Created by bill on 15-9-7.
//  Copyright (c) 2015年 bill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Ext)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

-(void)pauseTimer;
-(void)resumeTimer;

@end



@interface CADisplayLink (Ext)

/// 初始化 timer: CADisplayLink
+(CADisplayLink*) newTimer:(float)timeInterval target:(id)target sel:(SEL)sel;

@end