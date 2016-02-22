//
//  RunFragementCell.m
//  Sahara
//
//  Created by huangcan on 15/12/22.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "RunFragementCell.h"

@implementation RunFragementCell


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    width = _barView.frame.size.width;
    _largestLayout.constant = width * (1 -  (currTime / _maxTime));
}

- (void)loadCellData:(NSDictionary *)dic
{
    
    currTime = [dic[@"time"] floatValue];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
