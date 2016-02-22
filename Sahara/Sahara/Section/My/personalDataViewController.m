//
//  personalDataViewController.m
//  Sahara
//
//  Created by heng on 15/12/24.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "personalDataViewController.h"
#import "personalDataTableViewCell.h"
#import "ChangeName.h"
#import "ChangeSex.h"
#import "CustomPickerview.h"
#import "CustomDatePickerview.h"
@interface personalDataViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>{
    UIActionSheet *_myActionSheet;//下拉菜单
    NSArray *_nameArray, *_dataDtate;;
    NSDictionary *_dicData;
    NSString *_strUrl;//图片地址
    ChangeName *_changeName;
    ChangeSex *_changeSex;
}
@property (strong, nonatomic) IBOutlet UIButton *saveInformation;

@end

@implementation personalDataViewController
//视图消失
- (void)viewWillDisappear:(BOOL)animated{
    //跟新跑步数据
    NSNotification * notice = [NSNotification notificationWithName:KNOTIFICATION_RUNRELOADDATA object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _saveInformation.hidden = YES;
    _nameArray = [[NSArray alloc] init];
    _dataDtate = [[NSArray alloc] init];
    _dicData = [[NSDictionary alloc] init];

    [self addCustomNavBarTitle:@"个人资料" leftBar:nil rigthBar:nil whetherAddBackBar:YES];
    
    //设置头像圆角
    _headerImage.layer.cornerRadius = 26;
    _headerImage.layer.masksToBounds = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _nameArray = @[ @[@"昵称", @"生日", @"性别"], @[@"身高", @"体重"]];
    [self storageData];
    //初始化绑定手机视图
    _changeName    = [[[NSBundle mainBundle]loadNibNamed:@"ChangeName" owner:self options:nil]lastObject];
    _changeName.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _changeSex    = [[[NSBundle mainBundle]loadNibNamed:@"ChangeSex" owner:self options:nil]lastObject];
    _changeSex.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //弹出修改密码通知
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    //昵称
    [center addObserver:self selector:@selector(noticeChangeName:) name:@"cancleChangeName" object:nil];
    [center addObserver:self selector:@selector(noticeChangeNameCancle:) name:@"cancleChangeNameCancle" object:nil];
    //性别
    [center addObserver:self selector:@selector(noticeChanegSexMen:) name:@"cancleChangeSexMen" object:nil];
    [center addObserver:self selector:@selector(noticeChanegSexWomen:) name:@"cancleChangeSexWomen" object:nil];
}
//
-(void)storageData{
    [RequestManager PostUrl:URI_My_GetUserInfo loding:nil dic:nil isToken:YES response:^(id response) {
        
        if ([response[@"ReturnCode"] integerValue] == 3) {

            NSString *nameWH = [NSString stringWithFormat:@"%@",response[@"ReturnData"][@"Sex"]];
            _WHname = [NSString stringWithFormat:@"%@",response[@"ReturnData"][@"NickName"]];
            _WHbirthday = [NSString stringWithFormat:@"%@",response[@"ReturnData"][@"BirthDay"]];
            _WHweight = [NSString stringWithFormat:@"%@",response[@"ReturnData"][@"Weight"]];
            _WHheight = [NSString stringWithFormat:@"%@",response[@"ReturnData"][@"Height"]];
            _WHHeaderImage = [NSString stringWithFormat:@"%@",response[@"ReturnData"][@"HeadPic"]];
        
            if ([nameWH isEqualToString:@"1"]) {
                _WHsex = @"男";
                
            }else {
                _WHsex = @"女";
            }
            _dataDtate = @[@[_WHname, _WHbirthday, _WHsex], @[[NSString stringWithFormat:@"%@ cm", _WHheight], [NSString stringWithFormat:@"%@ Kg", _WHweight]]];
            
            
            [_headerImage sd_setImageWithURL:[NSURL URLWithString:_WHHeaderImage]];
            
            _dicData = @{@"header":_WHHeaderImage, @"name":_WHname, @"birthday":_WHbirthday, @"sex":_WHsex, @"height":_WHheight, @"weight":_WHweight};

            
            [_tableView reloadData];
        }else{
            
        }
        
    }];
}
- (IBAction)saveInformationAction:(UIButton *)sender {
    
    [SVProgressHUD showWithStatus:@"更新资料中..."];
    [RequestManager updatePic:UIImageJPEGRepresentation(_headerImage.image, 0.5) response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            _strUrl = [NSString stringWithFormat:@"%@", response[@"ReturnData"]];
            
            [RequestManager PostUrl:URI_My_EditUserInfo loding:nil dic:@{@"BirthDay":_WHbirthday, @"HeadPic":_strUrl, @"Height":_WHheight, @"NickName":_WHname, @"Sex":_WHsex, @"Weight":_WHweight} isToken:YES response:^(id response) {
                if ([response[@"ReturnCode"] integerValue] == 3) {
                    NSLog(@"跟新数据成功");
                    [SVProgressHUD showSuccessWithStatus:@"资料更新成功"];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"资料保存失败"];
                }
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"数据更新失败"];
        }
    }];
}

//处理性别和昵称点击事件
-(void)noticeChangeName:(NSNotification *)info{
    _WHname = info.userInfo[@"name"];
    _dataDtate = @[@[_WHname, _WHbirthday, _WHsex], @[[NSString stringWithFormat:@"%@ cm", _WHheight], [NSString stringWithFormat:@"%@ Kg",_WHweight]]];
    [_tableView reloadData];
    [_changeName removeFromSuperview];
    _saveInformation.hidden = NO;
    
}
//取消修改昵称
-(void)noticeChangeNameCancle:(NSNotification *)info{
    [_changeName removeFromSuperview];
}
//选取男
-(void)noticeChanegSexMen:(NSNotification *)info{
    NSString *nameWH = info.userInfo[@"sex"];
    
    if ([nameWH isEqualToString:@"1"]) {
        _WHsex = @"男";
        
    }else {
        _WHsex = @"女";
    }
    _dataDtate = @[@[_WHname, _WHbirthday, _WHsex], @[[NSString stringWithFormat:@"%@ cm", _WHheight], [NSString stringWithFormat:@"%@ Kg",_WHweight]]];
    [_tableView reloadData];
    [_changeSex removeFromSuperview];
    _saveInformation.hidden = NO;
}
//选取女
-(void)noticeChanegSexWomen:(NSNotification *)info{
    NSString *nameWH = info.userInfo[@"sex"];
    
    if ([nameWH isEqualToString:@"1"]) {
        _WHsex = @"男";
        
    }else {
        _WHsex = @"女";
    }
    _dataDtate = @[@[_WHname, _WHbirthday, _WHsex], @[[NSString stringWithFormat:@"%@ cm", _WHheight], [NSString stringWithFormat:@"%@ Kg",_WHweight]]];
    [_tableView reloadData];
    _saveInformation.hidden = NO;
    [_changeSex removeFromSuperview];
}
#pragma mark -- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _nameArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_nameArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"personalDataTableViewCell";
    personalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"personalDataTableViewCell" owner:nil options:nil].firstObject;
    }
    if (_dataDtate.count != 0) {
        cell.titleData.text = _dataDtate[indexPath.section][indexPath.row];
    }
    cell.title.text = _nameArray[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataDtate.count == 0) {
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.view addSubview:_changeName];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        //生日
        CustomDatePickerview *picker = [[[NSBundle mainBundle]loadNibNamed:@"CustomDatePickerview" owner:self options:nil]lastObject];
        picker.frame = [UIScreen mainScreen].bounds;
        [picker setRequestFinishBlock:^(NSString *str)
         {
             _WHbirthday = str;
             _dataDtate = @[@[_WHname, _WHbirthday, _WHsex], @[[NSString stringWithFormat:@"%@ cm", _WHheight], [NSString stringWithFormat:@"%@ Kg",_WHweight]]];
             [_tableView reloadData];
             _saveInformation.hidden = NO;
         }];
        [self.view.window addSubview:picker];
        
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        //发送通知传到性别界面、处理初始按钮高亮状态
        NSString *sex = _dataDtate[0][2];
        NSNotification *message = [NSNotification notificationWithName:@"sexButtonGaoliang" object:nil userInfo:@{@"sex":sex}];
        [[NSNotificationCenter defaultCenter] postNotification:message];
        [self.view addSubview:_changeSex];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        //身高
        CustomPickerview *picker    = [[[NSBundle mainBundle]loadNibNamed:@"CustomPickerview" owner:self options:nil]lastObject];
        picker.frame                = [[UIScreen mainScreen]bounds];
        picker.pickerType           = pickerType_height;
        [picker.pickerview selectRow:110 inComponent:0 animated:NO];
        [picker setRequestFinishBlock:^(NSString *str)
         {
             _WHheight = str;
             _dataDtate = @[@[_WHname, _WHbirthday, _WHsex], @[[NSString stringWithFormat:@"%@ cm", _WHheight], [NSString stringWithFormat:@"%@ Kg",_WHweight]]];
             [_tableView reloadData];
             _saveInformation.hidden = NO;
         }];

        [[self.view window] addSubview:picker];
        
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
       //
        //体重
        CustomPickerview *picker    = [[[NSBundle mainBundle]loadNibNamed:@"CustomPickerview" owner:self options:nil]lastObject];
        picker.frame                = [[UIScreen mainScreen]bounds];
        picker.pickerType           = pickerType_weight;
        [picker.pickerview selectRow:30 inComponent:0 animated:NO];
        [picker setRequestFinishBlock:^(NSString *str)
         {
             _WHweight = str;
             _dataDtate = @[@[_WHname, _WHbirthday, _WHsex], @[[NSString stringWithFormat:@"%@ cm", _WHheight], [NSString stringWithFormat:@"%@ Kg",_WHweight]]];
             [_tableView reloadData];
             _saveInformation.hidden = NO;
         }];
        [[self.view window] addSubview:picker];
        
    }
}
- (IBAction)grtHeaderImageSecond:(UITapGestureRecognizer *)sender {
    if (_dataDtate.count == 0) {
        return;
    }

    //在这里呼出下方菜单按钮项
    _myActionSheet = [[UIActionSheet alloc]
                      initWithTitle:nil
                      delegate:self
                      cancelButtonTitle:@"取消"
                      destructiveButtonTitle:nil
                      otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [_myActionSheet showInView:self.view];
}

//点击头像图片
- (IBAction)getHeaderImage:(UITapGestureRecognizer *)sender {
    if (_dataDtate.count == 0) {
        return;
    }

    //在这里呼出下方菜单按钮项
    _myActionSheet = [[UIActionSheet alloc]
                      initWithTitle:nil
                      delegate:self
                      cancelButtonTitle:@"取消"
                      destructiveButtonTitle:nil
                      otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [_myActionSheet showInView:self.view];
}
// 用户选择了某个图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 
    if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {

        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        _headerImage.image = originalImage;
        _saveInformation.hidden = NO;
    }
    //上传图片、转换位url
    //更新我的头像
    NSNotification * notice = [NSNotification notificationWithName:@"changeImage" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
//    [RequestManager updatePic:UIImageJPEGRepresentation(_headerImage.image, 0.5) response:^(id response) {
//        if ([response[@"ReturnCode"] integerValue] == 3) {
//            _strUrl = [NSString stringWithFormat:@"%@", response[@"ReturnData"]];
//        }else{
//            [SVProgressHUD showErrorWithStatus:@"数据更新失败"];
//        }
//    }];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
}
//处理上拉菜单
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}
//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"该设备不支持拍照功能");
    }
}
//打开本地相册
-(void)LocalPhoto{
    // 获取支持的媒体格式
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    // 判断是否支持需要设置的sourceType
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        // 1、初始化图片拾取器
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        // 2、设置图片拾取器上的sourceType
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 3、设置支持的媒体格式
        imagePickerController.mediaTypes = @[mediaTypes[0]];
        // 4、其他设置
        imagePickerController.allowsEditing = YES; // 如果设置为NO，当用户选择了图片之后不会进入图像编辑界面。
        imagePickerController.delegate = self;
        // 5、推送图片拾取器控制器
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
}


@end





