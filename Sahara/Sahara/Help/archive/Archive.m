//
//  Archive.m
//  Sahara
//
//  Created by junzong on 16/1/25.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "Archive.h"

@implementation Archive

+ (NSString *)shareArchiveName:(NSString *)archiveName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:archiveName];
//    return [NSHomeDirectory() stringByAppendingString:archiveName];
}

+(BOOL)saveArchiveRootObject:(NSString *)rootObject archiveName:(NSString *)archiveName
{
    return [NSKeyedArchiver archiveRootObject:rootObject toFile:[Archive shareArchiveName:archiveName]];
}

+ (NSString *)takeUnarchObjectWithName:(NSString *)Name
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Archive shareArchiveName:Name]];
}


@end
