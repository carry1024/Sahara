//
//  oneselfData.h
//  Sahara
//
//  Created by heng on 15/12/29.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface oneselfData : NSObject <NSCoding>

@property (strong, nonatomic) NSString     *name;          //名字

@property (strong, nonatomic) NSString     *birthday;      //生日

@property (strong, nonatomic) NSString     *sex;           //性别

@property (strong, nonatomic) NSString     *height;        //身高

@property (strong, nonatomic) NSString     *weight;        //体重

@property(nonatomic, strong)  NSString     *headImage;     //头像图片
@end
