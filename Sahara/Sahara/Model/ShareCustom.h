//
//  ShareCustom.h
//  Sahara
//
//  Created by huangcan on 16/1/20.
//  Copyright © 2016年 bode. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 自定义的分享类，使用的是类方法，其他地方只要 构造分享内容publishContent就行了
 */
@interface ShareCustom : NSObject

+(void)shareWithContent:(id)publishContent woboContent:(id)woboPublishContent;//自定义分享界面

@end
