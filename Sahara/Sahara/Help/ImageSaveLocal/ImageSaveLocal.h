//
//  ImageSaveLocal.h
//  Sahara
//
//  Created by junzong on 16/1/20.
//  Copyright © 2016年 bode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSaveLocal : NSObject


/**
 *  获取沙盒路径
 *
 *  @return 沙盒路径
 */
+ (NSString *)directoryPath;


#pragma mark - 保存照片
/**
 *  保存照片到沙盒
 *
 *  @param image     照片image
 *  @param imageName 照片名称
 *  @param extension 照片类型（png，jpg）
 */
+ (void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension;

/**
 *  保存照片到沙盒
 *
 *  @param imageUrl  照片url
 *  @param imageName 照片名称
 *  @param extension 照片类型（png，jpg）
 */
+ (void)saveImageUrl:(NSString *)imageUrl withFileName:(NSString *)imageName ofType:(NSString *)extension;


#pragma mark - 取出照片
/**
 *  从沙盒取出照片
 *
 *  @param imageName 照片名称
 *  @param extension 照片类型（png，jpg）
 *
 *  @return 照片路径
 */
+ (NSString *)takePathWithFileName:(NSString *)imageName ofType:(NSString *)extension;

/**
 *  从沙盒取出照片
 *
 *  @param fileName  照片名称
 *  @param extension 照片类型（png，jpg）
 *
 *  @return 照片image
 */
+ (UIImage *)takeImage:(NSString *)fileName ofType:(NSString *)extension;


#pragma mark - 删除照片
/**
 *  删除照片
 *
 *  @param imageName 照片名称
 *  @param extension 照片类型（png，jpg）
 *
 *  @return 是否删除成功
 */
+ (BOOL)removeImageWithFileName:(NSString *)imageName ofType:(NSString *)extension;

@end
