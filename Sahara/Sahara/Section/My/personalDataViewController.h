//
//  personalDataViewController.h
//  Sahara
//
//  Created by heng on 15/12/24.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "FatherViewController.h"

@interface personalDataViewController : FatherViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property(nonatomic, strong)NSString *WHname, *WHsex, *WHbirthday, *WHweight, *WHheight, *WHHeaderImage;
@end
