//
//  RunFragementCell.h
//  Sahara
//
//  Created by huangcan on 15/12/22.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RunFragementCell : UITableViewCell

{
    float width;
    float currTime;
}

@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) NSString * timerStr;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *largestLayout;
@property (nonatomic) NSInteger maxTime;

- (void)loadCellData:(NSDictionary *)dic;

@end
