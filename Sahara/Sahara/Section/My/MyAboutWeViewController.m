//
//  MyAboutWeViewController.m
//  Sahara
//
//  Created by heng on 15/12/17.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "MyAboutWeViewController.h"
#import "MyAccountTableViewCell.h"
#import "FeedbackViewController.h"
#import "AgreeMentViewController.h"
@interface MyAboutWeViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *_nameArray;
}
@end

@implementation MyAboutWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addCustomNavBarTitle:@"关于我们" leftBar:nil rigthBar:nil whetherAddBackBar:YES];
    //初始化修改密码界面
    _nameArray = @[@"意见反馈", @"评分", @"用户协议"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _nameArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"IndexTableViewCell";
    MyAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell)
    {
        //        UINib * nib = [UINib nibWithNibName:[MyTableViewCell description] bundle:[NSBundle mainBundle]];
        //        [tableView registerNib:nib forCellReuseIdentifier:Identifier];
        //        cell        = [tableView dequeueReusableCellWithIdentifier:Identifier];
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyAccountTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = _nameArray[indexPath.row];
    cell.phoneNUmber.text = @"";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedbackViewController *feed = [[FeedbackViewController alloc] init];
    AgreeMentViewController *agree = [[AgreeMentViewController alloc] init];
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:feed animated:YES];
        
    }else if (indexPath.row == 1) {
        
        NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1054316896&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if (indexPath.row == 2) {
        [self.navigationController pushViewController:agree animated:YES];
    }
}

@end
