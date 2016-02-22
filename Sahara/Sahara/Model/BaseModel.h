//
//  BaseModel.h
//  Base
//
//  Created by bodecn on 15/11/9.
//  Copyright © 2015年 bodecn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
+ (instancetype)modelWithDictionary: (NSDictionary *) data;
/**
 *  采用动态赋值，创建model时候，需要将字典里面key设为属性
 */
@property (nonatomic, copy) NSString *name;

@end
