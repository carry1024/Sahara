//
//  ActivityEnrollController.m
//  Sahara
//
//  Created by huangcan on 16/1/13.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "ActivityEnrollController.h"

#import "ActivityEnrollCell.h"
#import "Enroll.h"

static NSString *CellIdentifier = @"ActivityEnrollCell";

@interface ActivityEnrollController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * EnglishDataArr;
@property (strong, nonatomic) NSMutableArray * dataArr;
@property (strong, nonatomic) NSMutableDictionary * postDataDic;
@property (strong, nonatomic) NSMutableArray * enrollArr;

@end

@implementation ActivityEnrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addCustomNavBarTitle:@"填写报名信息" leftBar:nil rigthBar:nil whetherAddBackBar:YES];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UINib * nib = [UINib nibWithNibName:@"ActivityEnrollCell" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    [self loadViewData];
}

- (void)loadViewData {
    
    _dataArr = [[NSMutableArray alloc]init];
    _EnglishDataArr = [[NSMutableArray alloc]init];
    _postDataDic = [[NSMutableDictionary alloc]init];
    _enrollArr = [[NSMutableArray alloc]init];
    [RequestManager PostUrl:URI_ACTIVITY_ARTIVLEGETELEMENT loding:nil dic:@{@"articleId":_EnrollDic[@"articleId"]} isToken:NO response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            
            if ([response[@"ReturnData"] isEqual:[NSNull null]]) {
                return ;
            }
            for (NSString * str in response[@"ReturnData"]) {
                NSString * accord = response[@"ReturnData"][str];
                if ([accord boolValue] == YES) {
                    [_EnglishDataArr addObject:str];
                    Enroll * enroll = [[Enroll alloc]init];
                    enroll.enrollStr = @"";
                    if ([str isEqualToString:@"BloodType"]) {
                        enroll.enrollArr = [NSArray arrayWithArray:[@"A,B,AB,O" componentsSeparatedByString:@","]];
                    } else if ([str isEqualToString:@"ClothingSize"]) {
                        
                        enroll.enrollArr = [NSArray arrayWithArray:[@"XS,S,M,L,XL" componentsSeparatedByString:@","]];
                    } else if ([str isEqualToString:@"Sex"]) {
                        enroll.enrollArr = [NSArray arrayWithArray:[@"不限,男,女" componentsSeparatedByString:@","]];
                    } else {
                        enroll.enrollArr = [NSArray array];
                    }
                    [_enrollArr addObject:enroll];

                    [_dataArr addObject:[self EnglishConversionChinese:str]];
                    
                }
            }
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"ReturnMsg"]]];
        }
    }];
}

- (NSString *)EnglishConversionChinese:(NSString *)english {
    
    if ([english isEqualToString:@"Age"]) {
        return @"年龄:";
    } else if ([english isEqualToString:@"BloodType"]) {
        return @"血型:";
    } else if ([english isEqualToString:@"ClothingSize"]) {
        return @"服装尺码:";
    } else if ([english isEqualToString:@"Email"]) {
        return @"电子邮箱:";
    } else if ([english isEqualToString:@"EmergencyAddress"]) {
        return @"紧急联系地址:";
    } else if ([english isEqualToString:@"EmergencyPeople"]) {
        return @"紧急联系人:";
    } else if ([english isEqualToString:@"EmergencyPhoneNo"]) {
        return @"紧急联系电话号码:";
    } else if ([english isEqualToString:@"IdCard"]) {
        return @"证件号码:";
    } else if ([english isEqualToString:@"Name"]) {
        return @"姓名:";
    } else if ([english isEqualToString:@"PhoneNo"]) {
        return @"手机号码:";
    } else if ([english isEqualToString:@"Sex"]) {
        return @"性别:";
    } else if ([english isEqualToString:@"Unit"]) {
        return @"单位:";
    } else {
        return @"";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//确定
- (IBAction)confirmBtnAction:(UIButton *)sender {
    if (_postDataDic.count == _dataArr.count) {
        
        NSString * data = [RequestManager JsonStr:_postDataDic];
        [RequestManager PostUrl:URI_ACTIVITY_ARTICLEJOINACTIVITY loding:@"报名中..."
                            dic:@{@"articleId":_EnrollDic[@"articleId"],@"data":data}
                        isToken:NO response:^(id response)
        {
           if ([response[@"ReturnCode"] integerValue] == 3){
               
               [SVProgressHUD showSuccessWithStatus:@"报名成功"];
               [self.navigationController popViewControllerAnimated:YES];
           } else {
               [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"ReturnMsg"]]];
           }
        }];
        
    } else {
        
        [SVProgressHUD showInfoWithStatus:@"请输入完成后报名"];
    }
}
//取消
- (IBAction)cancelBtnAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}
// 添加每行显示的内容
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ActivityEnrollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.accordNameLabel.text = _dataArr[indexPath.row];
    cell.activityTextField.tag = indexPath.row +100;
    cell.activityTextField.delegate = self;
    
    Enroll *enroll = _enrollArr[indexPath.row];
    cell.enroll = enroll;
    cell.activityTextField.text = enroll.enrollStr;
    
    if (cell.enroll.enrollArr.count > 0) {
        [cell loadCellData];
    } else  {
        cell.activityTextField.inputView = nil;
        
        if ([cell.accordNameLabel.text isEqualToString:@"年龄:"]) {
            cell.activityTextField.keyboardType = UIKeyboardTypeNumberPad;

        } else if ([cell.accordNameLabel.text isEqualToString:@"电子邮箱:"]) {
            
            cell.activityTextField.keyboardType = UIKeyboardTypeEmailAddress;
        } else if ([cell.accordNameLabel.text isEqualToString:@"紧急联系电话号码:"]) {
            
            cell.activityTextField.keyboardType = UIKeyboardTypePhonePad;
        } else if ([cell.accordNameLabel.text isEqualToString:@"证件号码:"]) {
            
            cell.activityTextField.keyboardType = UIKeyboardTypeEmailAddress;
        } else if ([cell.accordNameLabel.text isEqualToString:@"手机号码:"]) {
            
            cell.activityTextField.keyboardType = UIKeyboardTypePhonePad;
        } else {
            
            cell.activityTextField.keyboardType = UIKeyboardTypeDefault;
        }
    }
    return cell;
}

#pragma mark -- UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    Enroll *enroll = _enrollArr[textField.tag - 100];
    enroll.enrollStr = textField.text;
    
    if (textField.text.length != 0) {
        if (enroll.enrollArr.count > 0 ) {
            [enroll.enrollArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:textField.text]) {
                    
                    [_postDataDic setObject:[NSNumber numberWithInteger:idx]
                                     forKey:_EnglishDataArr[textField.tag - 100]];
                    *stop = YES;
                }
            }];
        } else {
            
            [_postDataDic setObject:textField.text
                             forKey:_EnglishDataArr[textField.tag - 100]];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([_EnglishDataArr[textField.tag - 100] isEqualToString:@"Age"]) {
        if (textField.text.length > 3) return NO;
    } else if ([_EnglishDataArr[textField.tag - 100] isEqualToString:@"Email"]) {
        if (textField.text.length > 30) return NO;
    } else if ([_EnglishDataArr[textField.tag - 100] isEqualToString:@"EmergencyAddress"]) {
        if (textField.text.length > 30) return NO;
    } else if ([_EnglishDataArr[textField.tag - 100] isEqualToString:@"EmergencyPeople"]) {
        if (textField.text.length > 10) return NO;
    } else if ([_EnglishDataArr[textField.tag - 100] isEqualToString:@"EmergencyPhoneNo"]) {
        if (textField.text.length > 13) return NO;
    } else if ([_EnglishDataArr[textField.tag - 100] isEqualToString:@"IdCard"]) {
        if (textField.text.length > 20) return NO;
    } else if ([_EnglishDataArr[textField.tag - 100] isEqualToString:@"Name"]) {
        if (textField.text.length > 5) return NO;
    } else if ([_EnglishDataArr[textField.tag - 100] isEqualToString:@"PhoneNo"]) {
        if (textField.text.length > 13) return NO;
    } else  if ([_EnglishDataArr[textField.tag - 100] isEqualToString:@"Unit"]) {
        if (textField.text.length > 30) return NO;
    } else {
        if (textField.text.length > 30) return NO;
    }
    
    return YES;
}


@end
