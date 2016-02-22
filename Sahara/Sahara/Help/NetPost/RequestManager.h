//
//  RequestManager.h
//  Sahara
//
//  Created by Chen on 15/6/12.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#import "SBJson4.h"
#import "JSONKit.h"

@interface RequestManager : NSObject

+ (void)PostUrl:(NSString *)url
         loding:(NSString *)loding
            dic:(NSDictionary *)dic
        isToken:(BOOL)isToken
       response:(void(^)(id response))response;
+ (void)GETUrl:(NSString *)url
        loding:(NSString *)loding
           dic:(NSDictionary *)dic
      response:(void(^)(id response))response;

//上传图片
+ (void)updatePic:(NSData *)data
         response:(void (^)(id response))callBack;
//上传多张图片
+(void)updatePics:(NSArray *)pics response:(void (^)(id response))callBack;

+ (NSString *)SbJson:(id)obj;
+ (NSString *)JsonStr:(id)obj;
@end
