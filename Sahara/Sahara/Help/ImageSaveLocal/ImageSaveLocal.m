//
//  ImageSaveLocal.m
//  Sahara
//
//  Created by junzong on 16/1/20.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "ImageSaveLocal.h"

@implementation ImageSaveLocal

//沙盒路径
+ (NSString *)directoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

//传入image保存照片到沙盒
+ (void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension
{
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[[ImageSaveLocal directoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]] options:NSAtomicWrite error:nil];
    }else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]){
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[[ImageSaveLocal directoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageName]] options:NSAtomicWrite error:nil];
    }else{
        UIAlertView *alertVew = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入的照片格式不匹配(仅支持png，jpg)" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertVew show];
    }
}

//传入imageUrl保存照片到沙盒
+ (void)saveImageUrl:(NSString *)imageUrl withFileName:(NSString *)imageName ofType:(NSString *)extension
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage *image = [UIImage imageWithData:data];
    [ImageSaveLocal saveImage:image withFileName:imageName ofType:extension];
}


//取出照片路径
+ (NSString *)takePathWithFileName:(NSString *)imageName ofType:(NSString *)extension
{
    return [NSString stringWithFormat:@"%@/%@.%@",[ImageSaveLocal directoryPath],imageName,extension];
}

//取出照片
+ (UIImage *)takeImage:(NSString *)fileName ofType:(NSString *)extension
{
    return [UIImage imageWithContentsOfFile:[ImageSaveLocal takePathWithFileName:fileName ofType:extension]];
}

//删除照片
+ (BOOL)removeImageWithFileName:(NSString *)imageName ofType:(NSString *)extension
{
    return [[NSFileManager defaultManager] removeItemAtPath:[ImageSaveLocal takePathWithFileName:imageName ofType:extension] error:nil];
}

@end
