//
//  CollectionSaveCell.m
//  Sahara
//
//  Created by heng on 15/12/24.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "CollectionSaveCell.h"

@implementation CollectionSaveCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    _headImg.layer.masksToBounds =YES;
    _headImg.layer.cornerRadius = _headImg.bounds.size.width/2;
}
- (void)loadCellData:(NSDictionary *)dic {
    
    _authorLabel.text = [NSString stringWithFormat:@"%@",dic[@"SingerName"]];
    _songNameLabel.text = [NSString stringWithFormat:@"%@",dic[@"SongName"]];
    
    [_headImg sd_setImageWithURL:dic[@"SongPic"] placeholderImage:[UIImage imageNamed:@"song_logo"]];
}
- (IBAction)toolBtnAction:(UIButton *)sender {
    [self.delegate insertRowDelegate:sender];
}
@end
