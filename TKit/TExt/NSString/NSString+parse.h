//
//  NSString+libxml.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//#ifdef TKIT_LIB
//#import "../../Externals/GDataXML-HTML/GDataXMLNode.h"
//#import "../../Externals/GCJSONKit/JSONKit.h"
//
//#else
#import "GDataXMLNode.h"
#import "JSONKit.h"

//#endif

@interface NSString (parse)

/// 解析XML  【param: xml 数据】  【returns: 字典或者数组】
- (id)XML2Value;

/// 解析JSON 【param: json 数据】 【returns: 字典或者数组】
- (id)JSON2Value;

@end


@interface GDataXMLNode (children)

- (BOOL)hasSameChild;

@end