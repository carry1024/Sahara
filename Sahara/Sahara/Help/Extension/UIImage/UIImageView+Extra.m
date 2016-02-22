//
//  UIImageView+Extra.m
//  XinxunIOS
//
//  Created by sunny on 14-10-29.
//  Copyright (c) 2014年 zy168. All rights reserved.
//

#import "UIImageView+Extra.h"

@implementation UIImageView (Extra)

- (void)setRadius {

    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.height/2;
}

- (void)setImage9Grid:(UIImage*)image {
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    [self setImage:image];
}

- (void)loadImageURL:(NSString *)url
{
//    if (![url isKindOfClass:[NSNull class]]) {
//        [self sd_setImageWithURL:[NSURL URLWithString:url]
//                placeholderImage:[UIImage imageNamed:@"默认头像"]
//                         options:SDWebImageRetryFailed];
//    } else {
//        [self sd_setImageWithURL:[NSURL URLWithString:@""]
//                placeholderImage:[UIImage imageNamed:@"默认头像"]
//                         options:SDWebImageRetryFailed];
//    }
}


- (UIImage *) captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
