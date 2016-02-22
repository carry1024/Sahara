//
//  RunSongCell.m
//  Sahara
//
//  Created by huangcan on 15/12/25.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "RunSongCell.h"

@implementation RunSongCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)loadCellInfo:(NSDictionary *)dic {
    
    _SongLabel.text   = [NSString stringWithFormat:@"%@首歌",dic[@"SongCount"]];
    _IntroLabel.text = [NSString stringWithFormat:@"%@",dic[@"Intro"]];
    if ([dic[@"Speed"] isEqual:[NSNull null]]) {
        
        _SpeedBtn.hidden = YES;
    } else {
        
        _SpeedBtn.hidden = NO;
    }
    [_SpeedBtn setTitle:[NSString stringWithFormat:@"配速：%@",dic[@"Speed"]] forState:UIControlStateNormal];
    [_CoverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"Cover"]]] placeholderImage:[UIImage imageNamed:@"song_logo"]];
    _listenLabel.text = [NSString stringWithFormat:@"%@人在听歌",dic[@"PlayCount"]];
}

@end
