//
//  SongingController.h
//  Sahara
//
//  Created by huangcan on 16/1/15.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "FatherViewController.h"

@interface SongingController : FatherViewController

@property (nonatomic, copy) NSArray *tracks;

@property (nonatomic, assign) NSUInteger currentTrackIndex;
@end
