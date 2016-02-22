//
//  RequestManager.m
//  Sahara
//
//  Created by Chen on 15/6/12.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import "RequestManager.h"
#import <GDataXMLNode.h>

#import "FMDB_Help.h"
@implementation RequestManager

//上传请求
+ (void)PostUrl:(NSString *)url loding:(NSString *)loding dic:(NSDictionary *)dic isToken:(BOOL)isToken response:(void (^)(id))response
{
    /**
     *  @brief  检查是否网络畅通
     */
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status == AFNetworkReachabilityStatusNotReachable) {
             
            [SVProgressHUD showErrorWithStatus:@"无网络连接！"];
             return ;
         }
         //加载图
         if (loding) {
             [SVProgressHUD showWithStatus:loding];
         }

         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
         manager.requestSerializer   = [AFHTTPRequestSerializer serializer];
         manager.requestSerializer.timeoutInterval = 20;
         if (isToken) {
             [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:@"Auth"];
         }
         [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
         //    manager.requestSerializer   = [AFJSONRequestSerializer serializer];
         //    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
         //    [manager.requestSerializer setValue:@"application/json; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
         
         //responseSerializer
         //    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
         AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
         NSSet *acceptContentType = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
         [responseSerializer setAcceptableContentTypes:acceptContentType];
         manager.responseSerializer = responseSerializer;
         //在向服务端发送请求状态栏显示网络活动标志：
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
         
         DLog(@"%@ ********************* %@",url,dic);
         //请求
         [manager POST:url
            parameters:dic
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   [SVProgressHUD dismiss];
                   DLog(@"成功-------%@",responseObject);
                   if ([responseObject[@"ReturnCode"] integerValue] == 5) {
                       
                       [RequestManager cancelData];
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           //通知进入登录
                           [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(NO)];
                       });
                   }
                   
                   //请求结束状态栏隐藏网络活动标志：
                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                   
                   response(responseObject);
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   [SVProgressHUD dismiss];
                   //请求结束状态栏隐藏网络活动标志：
                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                   DLog(@"失败-------%@",error);
                   response(nil);
               }];
     }];
    
    [afNetworkReachabilityManager stopMonitoring];
    
}
+ (void)GETUrl:(NSString *)url
        loding:(NSString *)loding
           dic:(NSDictionary *)dic
      response:(void(^)(id response))response {
    /**
     *  @brief  检查是否网络畅通
     */
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status == AFNetworkReachabilityStatusNotReachable) {
             [SVProgressHUD showErrorWithStatus:@"无网络连接！"];
             return;
         }
     }];
    [afNetworkReachabilityManager stopMonitoring];
    //加载图
    if (loding) {
        [SVProgressHUD showWithStatus:loding];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer   = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.timeoutInterval = 20;
    //responseSerializer
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    NSSet *acceptContentType = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
    [responseSerializer setAcceptableContentTypes:acceptContentType];
    manager.responseSerializer = responseSerializer;
    //在向服务端发送请求状态栏显示网络活动标志：
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //请求
    [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //请求结束状态栏隐藏网络活动标志：
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        response(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        //请求结束状态栏隐藏网络活动标志：
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        response(nil);
    }];
}
//上传图片
+(void)updatePic:(NSData *)data response:(void (^)(id response))callBack
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:@"http://120.24.184.179:8025/Api/BasicInfo/UploadPic"
                                    parameters:nil
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        [formData appendPartWithFileData:data name:@"111" fileName:@"avatar.png" mimeType:@"image/jpeg"];
                                    }
                                    error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]
                                    initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:&progress
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                  
                                                                  if (error)
                                                                  {
                                                                      callBack(nil);
                                                                      
                                                                  } else
                                                                  {
                                                                      callBack(responseObject);
                                                                  }
                                                                  
                                                              }];
    [uploadTask resume];
}
//上传多张图片
+(void)updatePics:(NSArray *)pics response:(void (^)(id response))callBack
{
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:@"http://125.71.215.141:4000/crm/api/v1/attachments/upload"
                                    parameters:nil
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        for (int i = 0;i < pics.count; i++) {
                                            UIImage *image = pics[i];
                                            NSData *data = UIImageJPEGRepresentation(image, 0.3);
                                            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"1%d",i] fileName:@"avatar.png" mimeType:@"image/jpeg"];
                                        }
                                        
                                    }
                                    error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]
                                    initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:&progress
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                  
                                                                  if (error)
                                                                  {
                                                                      callBack(nil);
                                                                      
                                                                  } else
                                                                  {
                                                                      callBack(responseObject);
                                                                  }
                                                                  
                                                              }];
    [uploadTask resume];
}
//上传图片
+(void)AA:(NSData *)data response:(void (^)(id response))callBack
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:@""
                                    parameters:nil
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        [formData appendPartWithHeaders:@{@"Content-Type":@"application/json",
                                                                          @"Accept":@"*/*"}
                                                                   body:data];
                                    }
                                    error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]
                                    initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:&progress
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                  
                                                                  if (error)
                                                                  {
                                                                      callBack(nil);
                                                                      
                                                                  } else
                                                                  {
                                                                      callBack(responseObject);
                                                                  }
                                                                  
                                                              }];
    [uploadTask resume];
}


//
+ (NSString *)JsonStr:(id)obj
{
    //1）NSJSONReadingMutableContaines ,指定解析返回的是可变的数组或字典 ，这个方法还是比较使用的，因为如果json数据需要改，不用管撒
    
    //2）NSJSONReadingMutableLeaves ，指定叶节点是可变的字符串
    
    //3)   NSJSONReadingAllowFragments , 指定顶级节点可以部署数组或字典
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted// Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        DLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSString *)SbJson:(id)obj
{
    SBJson4Writer *jsonParser = [[SBJson4Writer alloc] init];
    return [jsonParser stringWithObject:obj];
}

/*
+ (NSString *)ReWritePostUrl:(NSString *)url obj:(id)obj TheOrder:(NSArray*)order {
    
    if (!obj) {
        return url;
    }
    __block NSString *urlStr = [url stringByAppendingString:@"?"];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = obj;
        if (order.count > 0) {
            [order enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString * key = obj;
                urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[dic objectForKey:key]]];
            }];
        } else {
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
            }];
        }
        
        urlStr = [urlStr stringByReplacingCharactersInRange:NSMakeRange(urlStr.length - 1, 1) withString:@""];
        urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlStr, NULL, NULL,  kCFStringEncodingUTF8));
    }
    return urlStr;
}
*/

/*
+ (NSString *)XMlDictionary:(NSDictionary *)dic {
    __block NSString *string = @"<?xml version='1.0' encoding='UTF-8'?><request>";
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *str = [NSString stringWithFormat:@"<%@>%@</%@>",key,obj,key];
        string = [string stringByAppendingString:str];
    }];
    string = [string stringByAppendingString:@"</request>"];
    DLog(@"%@",string);
//    string = [string JSONString];
//    string = [string dataUsingEncoding:NSUTF8StringEncoding];
    return string;
}
 */

+ (void)cancelData {
    
    [[FMDB_Help sharedInstance] inDatabase:^(FMDatabase *db) {
        
        BOOL run = [db executeUpdate:@"DELETE FROM Run"];
        BOOL runNum = [db executeUpdate:@"DELETE FROM RunNum"];
        BOOL music = [db executeUpdate:@"DELETE FROM Music"];
        BOOL gps = [db executeUpdate:@"DELETE FROM GPS"];
        
        if (run && runNum && music && gps) {
            [SVProgressHUD showErrorWithStatus:@"您的账号在别处登录，登录失效，请重新登录"];
        }
    }];
    
    NSString* appDomain = [[NSBundle mainBundle]bundleIdentifier];
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
    //清除图片
    [[SDImageCache sharedImageCache] cleanDisk];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"statrtPage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
