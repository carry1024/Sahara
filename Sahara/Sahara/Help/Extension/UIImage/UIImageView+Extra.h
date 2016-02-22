//
//  UIImageView+Extra.h
//  XinxunIOS
//
//  Created by sunny on 14-10-29.
//  Copyright (c) 2014年 zy168. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extra)
/**
 * 设置视图为圆形
 */
-(void)setRadius;

/**
 * 请求网络图片的URL
 */

-(void)loadImageURL:(NSString *)url;

/**
 *  @brief  截屏
 *
 *  @return image
 */
- (UIImage *)captureScreen;
@end
