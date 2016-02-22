//
//  FMDB_Help.h
//  兜捞
//
//  Created by doulao ios1 on 14-12-11.
//  Copyright (c) 2014年 doulao ios1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import <CommonCrypto/CommonDigest.h>

@interface FMDB_Help : NSObject
+(FMDB_Help *) sharedInstance;
-(void) inDatabase:(void(^)(FMDatabase *db))block;
+(void) refreshDatabaseFile;
@end
