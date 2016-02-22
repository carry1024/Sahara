//
//  MyViewController.m
//  Sahara
//
//  Created by huangcan on 15/12/2.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "MyViewController.h"
#import "MyTableViewCell.h"
#import "MyAboutWeViewController.h"
#import "RunRecordViewController.h"
#import "MyCollectionController.h"
#import "MyAccountViewController.h"
#import "personalDataViewController.h"
#import "FMDB_Help.h"
#import "NSString+FSExtension.h"
#import "IntegralViewController.h"
@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *_nameArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyViewController

- (void)viewDidLayoutSubviews {
    
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sex.hidden = YES;
    [self getData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(changeImage:) name:@"changeImage" object:nil];
    [center addObserver:self selector:@selector(runreloadData:) name:KNOTIFICATION_RUNRELOADDATA object:nil];
    //设置头像圆角
    _headImage.layer.cornerRadius = 40;
    _headImage.layer.masksToBounds = YES;
    NSArray *arrFirst = @[@"我的账户",@"我的收藏",@"跑步记录"];
    NSArray *arrSecond = @[@"关于我们", @"清除缓存"];
    
    _nameArray = [NSArray arrayWithObjects:arrFirst, arrSecond, nil];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

-(void)changeImage:(NSNotificationCenter *)info{
    [self getData];
}
-(void)runreloadData:(NSNotificationCenter *)info{
    [self getData];
}
//获取个人信息
- (void)getData{
    [RequestManager PostUrl:URI_My_AccocuntIndex loding:nil dic:nil isToken:YES response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            
            [_headImage sd_setImageWithURL:response[@"ReturnData"][@"HeadPic"]];
            _cumulative.text = [NSString stringWithFormat:@"%@", response[@"ReturnData"][@"GlobalDistance"]] ;
            
            _longTime.text = [NSString stringWithSeconds:([response[@"ReturnData"][@"FirstTime"] integerValue] / 1000) isHours:YES];
            _longDistance.text = [NSString stringWithFormat:@"%@",response[@"ReturnData"][@"FirstDistance"]];
            _speed.text = [NSString stringWithFormat:@"%@",response[@"ReturnData"][@"FirstSpeed"]];
            _level.text = [NSString stringWithFormat:@"LV%@",response[@"ReturnData"][@"Level"]];
            _name.text = [NSString stringWithFormat:@"%@",response[@"ReturnData"][@"NickName"]];
            if ([[NSString stringWithFormat:@"%@",response[@"ReturnData"][@"Sex"]] isEqualToString:@"1"]) {
//                _sex.text = @"男";
                _sexImage.image = [UIImage imageNamed:@"My男-ic"];
            }
            if ([[NSString stringWithFormat:@"%@",response[@"ReturnData"][@"Sex"]] isEqualToString:@"2"]) {
//                _sex.text = @"女";
                _sexImage.image = [UIImage imageNamed:@"My女.png"];
            }
        }else{
            
        }
        
    }];
    
}
//点击头像、推到个人资料
- (IBAction)headerAction:(UITapGestureRecognizer *)sender {
    personalDataViewController *personalData = [[personalDataViewController alloc] init];
    [self.navigationController pushViewController:personalData animated:YES];
}
//点击等级图片
- (IBAction)levelAction:(UITapGestureRecognizer *)sender {
    IntegralViewController *integral = [[IntegralViewController alloc] init];
    [self.navigationController pushViewController:integral animated:YES];
}

#pragma mark -- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _nameArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _nameArray[section];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"MyTableViewCell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:nil options:nil].firstObject;
    }
    NSArray *imageName = @[@[@"My_我的账户",@"My_我的收藏",@"My_跑步记录"], @[@"My_关于我们",@"My_清除缓存"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.name.text = _nameArray[0][indexPath.row];
        [cell.myImage setImage:[UIImage imageNamed:imageName[0][indexPath.row]]];
    }else {
        cell.name.text = _nameArray[1][indexPath.row];
        [cell.myImage setImage:[UIImage imageNamed:imageName[1][indexPath.row]]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAboutWeViewController    *about = [[MyAboutWeViewController alloc] init];
    RunRecordViewController    *run = [[RunRecordViewController alloc] init];
    MyCollectionController *myCollect = [[MyCollectionController alloc] initWithNibName:@"MyCollectionController" bundle:[NSBundle mainBundle]];
    MyAccountViewController    *myAccount = [[MyAccountViewController alloc] init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:myAccount animated:YES];
            return;
        }
        if (indexPath.row == 1) {
            [self.navigationController pushViewController:myCollect animated:YES];
            return;
        }if (indexPath.row == 2) {
            
            [self.navigationController pushViewController:run animated:YES];
            return;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:about animated:YES];
        }else {
            //清除缓存
            [self clearAllData];
            
        }
    }
    
}
#pragma mark - 删除数据
- (void)clearAllData
{
    [[FMDB_Help sharedInstance] inDatabase:^(FMDatabase *db) {
        
        BOOL run = [db executeUpdate:@"DELETE FROM Run"];
        BOOL runNum = [db executeUpdate:@"DELETE FROM RunNum"];
        BOOL music = [db executeUpdate:@"DELETE FROM Music"];
        BOOL gps = [db executeUpdate:@"DELETE FROM GPS"];
        
        if (run && runNum && music && gps) {
            [SVProgressHUD showSuccessWithStatus:@"缓存清除成功"];
            NSLog(@"数据库数据删除成功");
        }else{
            [SVProgressHUD showErrorWithStatus:@"暂无缓存"];
            NSLog(@"数据库数据删除失败");
        }
    }];
}
@end
