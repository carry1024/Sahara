//
//  FMDB_Help.m
//  兜捞
//
//  Created by doulao ios1 on 14-12-11.
//  Copyright (c) 2014年 doulao ios1. All rights reserved.
//

#import "FMDB_Help.h"
#import "FMDatabaseQueue.h"

@implementation FMDB_Help
{
    FMDatabaseQueue* queue;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        NSString *dbFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",[self MD5:@"MyDatabase"]]];
        //        NSError *error;
        //        NSFileManager *fileManager = [NSFileManager defaultManager];
        //        if ([fileManager fileExistsAtPath:dbFilePath])
        //        {
        //            [fileManager removeItemAtPath:dbFilePath error:&error];
        //        }
        queue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
        NSLog(@"%@",dbFilePath);
        [self initData];
    }
    return self;
}
+(FMDB_Help *) sharedInstance
{
    static dispatch_once_t pred = 0;
    
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(void)inDatabase:(void(^)(FMDatabase *db))block
{
    [queue inDatabase:^(FMDatabase *DataBase)
     {
         [DataBase open];
         
         if ([DataBase open])
         {
             block(DataBase);
         }
         [DataBase close];
     }];
}
/*
 刷新数据库文件路径
 具体到我们的应用，还有一个特殊问题需要考虑。因为我们的APP可以切换账户，而账户的db文件是独立的。所以当用户重新登录的时候，需要刷新一下Helper的queue
 */
+(void) refreshDatabaseFile
{
    FMDB_Help *instance = [self sharedInstance];
    [instance doRefresh];
}

-(void) doRefresh
{
    NSString *dbFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",[self MD5:@"MyDatabase"]]];
    queue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
    [self initData];
}

#pragma mark --初始化数据库
- (void)initData
{
    //开关数据库
    [self inDatabase:^(FMDatabase *db)
     {
         //跑步临时数据
         [db executeUpdate:
          @"CREATE TABLE IF NOT EXISTS Run (user_id INTEGER PRIMARY KEY AUTOINCREMENT ,'time' text,'distance' text)"];
         //跑步分段临时数据
         [db executeUpdate:
          @"CREATE TABLE IF NOT EXISTS RunNum (user_id INTEGER PRIMARY KEY AUTOINCREMENT ,'number' text,'time' text)"];
         //跑步歌曲临时数据
         [db executeUpdate:
          @"CREATE TABLE IF NOT EXISTS Music (user_id INTEGER PRIMARY KEY AUTOINCREMENT ,'time' text,'start' text,'end' text,'musicId' text,'musicImg' text,'musicName' text,'musicSinger' text,'like' text)"];
         //GPS临时数据
         [db executeUpdate:
          @"CREATE TABLE IF NOT EXISTS GPS (user_id INTEGER PRIMARY KEY AUTOINCREMENT ,'longitude' text,'latitude' text)"];
         
     }];
}

- (NSString *)MD5:(NSString *)key
{
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}


@end

