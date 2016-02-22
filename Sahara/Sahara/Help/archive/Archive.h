//
//  Archive.h
//  Sahara
//
//  Created by junzong on 16/1/25.
//  Copyright © 2016年 bode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Archive : NSObject


/**
 *  获取文件路径
 *
 *  @param archiveName 文件名称
 *
 *  @return 文件路径
 */
+ (NSString *)shareArchiveName:(NSString *)archiveName;

/**
 *  保存对象
 *
 *  @param rootObject  对象
 *  @param archiveName 文件名称
 *
 *  @return 是否保存成功
 */
+ (BOOL)saveArchiveRootObject:(NSString *)rootObject archiveName:(NSString *)archiveName;

/**
 *  取出对象
 *
 *  @param Name 文件名称
 *
 *  @return 对象
 */
+ (NSString *)takeUnarchObjectWithName:(NSString *)Name;

@end
