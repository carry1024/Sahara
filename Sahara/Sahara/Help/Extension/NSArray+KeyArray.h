//
//  NSArray+KeyArray.h
//  Dituibao
//
//  Created by bodecn on 15/11/3.
//  Copyright © 2015年 bodecn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (KeyArray)

//根据某个字段拼接成需要形成的格式
- (NSString *)AllStringWithKey:(NSString *)key byAddString:(NSString *)string;
//返回改字段的数据
- (NSArray *)keyArray:(NSString *)key;
//将数组内以key分割组成字符串
- (NSString *)swithToStringWithKey:(NSString *)key;

@end
