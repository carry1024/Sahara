//
//  NSArray+KeyArray.m
//  Dituibao
//
//  Created by bodecn on 15/11/3.
//  Copyright © 2015年 bodecn. All rights reserved.
//

#import "NSArray+KeyArray.h"

@implementation NSArray (KeyArray)

- (NSString *)AllStringWithKey:(NSString *)key byAddString:(NSString *)string {
    return [[self keyArray:key] swithToStringWithKey:string];
}
//取出改字段，形成数组
- (NSArray *)keyArray:(NSString *)key {
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithCapacity:self.count];
    for (NSDictionary *info in self) {
        [mutableArray addObject:[NSString stringWithFormat:@"%@",info[key]]];
    }
    return mutableArray;
}
//转成nsstring
- (NSString *)swithToStringWithKey:(NSString *)key {
    NSString *String = @"";
    for (NSString *name in self) {
        String = [NSString stringWithFormat:@"%@%@%@",String,name,key];
    }
    String = [String stringByReplacingCharactersInRange:NSMakeRange(String.length - 1, 1) withString:@""];
    return String;
}
@end
