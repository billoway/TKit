//
//  Ext.h
//  APP
//
//  Created by LiuTao on 16/6/30.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//

#ifndef Ext_h
#define Ext_h



#pragma mark - ******** NSArray ********

//#define OBJ_AT_INDEX(arr,index)  

//#define    RM_OBJ_AtIndex

#define     Move_OBJ(arr,from,to)   \
{\
    if (to != from) {\
        __strong id obj = [arr objectAtIndex:from];\
        [arr removeObjectAtIndex:from];\
        if (to >= [arr count]) {\
            [arr addObject:obj];\
        } else {\
            [arr insertObject:obj atIndex:to];\
        }\
    }\
}

#define     Add_OBJ(arr,anObject)\
{\
    if (anObject) { [self addObject:anObject];  }\
    else          { NSLog(@" [__NSArrayM insertObject:atIndex:] object cannot be nil");    }\
}










#endif /* Ext_h */
