//
//  RunSongCell.h
//  Sahara
//
//  Created by huangcan on 15/12/25.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunSongCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *IntroLabel;

@property (strong, nonatomic) IBOutlet UIImageView *CoverImg;
@property (strong, nonatomic) IBOutlet UILabel *SongLabel;
@property (strong, nonatomic) IBOutlet UIButton *SpeedBtn;
@property (strong, nonatomic) IBOutlet UILabel *listenLabel;

- (void)loadCellInfo:(NSDictionary *)dic;

@end
