//
//  SongSaveCell.m
//  Sahara
//
//  Created by huangcan on 15/12/21.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "SongSaveCell.h"

@implementation SongSaveCell

- (void)drawRect:(CGRect)rect {
    // Drawing code
    _headImg.layer.masksToBounds =YES;
    _headImg.layer.cornerRadius = _headImg.bounds.size.width/2;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)loadCellData:(NSDictionary *)dic {
    
    float distance = [dic[@"end"] floatValue] - [dic[@"start"] floatValue];
    float timer = [dic[@"time"] floatValue];
    _speedLabel.text = [NSString stringWithFormat:@"配速：%.2fmin/km",
                        distance<=0 ?0.00: timer/1000/distance/60];
    _authorLabel.text = [NSString stringWithFormat:@"%@",dic[@"musicSinger"]];
    _songNameLabel.text = [NSString stringWithFormat:@"%@",dic[@"musicName"]];
    [_headImg sd_setImageWithURL:dic[@"musicImg"] placeholderImage:[UIImage imageNamed:@"song_logo"]];
}

- (IBAction)insertRowBtnAction:(UIButton *)sender {
//    [self.delegate insertRowDelegate:sender];
}

@end
