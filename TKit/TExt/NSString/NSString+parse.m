//
//  NSString+libxml.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "NSString+parse.h"

@implementation NSString (parse)

- (id)JSON2Value
{
    return [self objectFromJSONString];
//    NSError *error = nil;
//    NSData  *data = [self dataUsingEncoding:NSUTF8StringEncoding];
//    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//
//    if (error != nil) {
//        return nil;
//    }
//
//    return result;
}


- (id)XML2Value
{
    NSError             *error = NULL;
//        NSData              *xmlData = [self dataUsingEncoding:NSUTF8StringEncoding];
//        GDataXMLDocument    *GDoc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    GDataXMLDocument    *GDoc = [[GDataXMLDocument alloc] initWithXMLString:self error:&error];

    if (error) {
        NSLog(@" 初始化  GDataXMLDocument 失败：（%@）", [error domain]);
    }

    GDataXMLElement *rootElement = [GDoc rootElement];
    id result = [self parseNode:rootElement];

    return result;
}

- (id)parseNode:(GDataXMLElement *)tElement
{
    GDataXMLNodeKind kind = [tElement kind];

    if ( (kind == GDataXMLTextKind) || (kind == GDataXMLAttributeKind) ) {
        return [tElement stringValue];     // [NSDictionary dictionaryWithObject:[tElement stringValue] forKey:[tElement localName]];
    }

    NSArray *attributes = [tElement attributes];
    NSArray *children = [tElement children];
    NSArray *namespaces = [tElement namespaces];

    if ( (children.count > 0) && (attributes.count < 1) && (namespaces.count < 1) && [tElement hasSameChild] ) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];

        for (GDataXMLElement *element in children) {
            if ([element kind] == GDataXMLElementKind) {
                [result addObject:[NSDictionary dictionaryWithObject:[self parseNode:element] forKey:[element localName]]];
            }
            else {
                [result addObject:[NSDictionary dictionaryWithObject:[element stringValue] forKey:[element localName]]];
            }
        }

        return result;
    }
    else if ([tElement kind] != GDataXMLElementKind) {
        return [tElement stringValue];
    }
    else {
        // ------ 解析子节点
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:0];

        for (GDataXMLElement *element in children) {
            if ([element kind] == GDataXMLElementKind) {
                [result setObject:[self parseNode:element] forKey:[element localName]];
            }
            else {
                //                [result setObject:[element stringValue] forKey:[element localName]];
                return [element stringValue];
            }
        }

        // ------ 节点属性
        NSMutableDictionary *attDic = [NSMutableDictionary dictionaryWithCapacity:0];

        for (GDataXMLElement *element in attributes) {
            [attDic setObject:[self parseNode:element] forKey:[element localName]];
        }

        if (attDic.count > 0) {
            [result setObject:attDic forKey:@"attributes"];
        }

        // ------ 解析接点命名空间
        NSMutableDictionary *nameDic = [NSMutableDictionary dictionaryWithCapacity:0];

        for (GDataXMLElement *element in namespaces) {
            [nameDic setObject:[self parseNode:element] forKey:[element localName]];
        }

        if (nameDic.count > 0) {
            [result setObject:nameDic forKey:@"namespaces"];
        }

        return result;
    }
}

@end

@implementation GDataXMLNode (children)

- (BOOL)hasSameChild
{
    NSArray *children = [self children];

    if (children.count < 2) {
        return NO;
    }

    for (int i = 0; i < children.count; ) {
        GDataXMLElement *iEle = [children objectAtIndex:i];

        for (int j = ++i; j < children.count; j++) {
            GDataXMLElement *jEle = [children objectAtIndex:j];

            if ([[iEle localName] isEqualToString:[jEle localName]]) {
                return YES;
            }
        }
    }

    return NO;
}

@end