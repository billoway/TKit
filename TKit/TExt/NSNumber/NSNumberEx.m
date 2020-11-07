//
//  NSNumberEx
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "NSNumberEx.h"

@implementation NSNumber (Ext)

+ (NSNumber *)numberWithString:(NSString *)string
{
    NSNumberFormatter   *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber            *num = [numberFormatter numberFromString:string];
    
    return num;
}

@end