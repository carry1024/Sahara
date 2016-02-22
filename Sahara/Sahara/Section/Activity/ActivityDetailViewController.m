//
//  ActivityDetailViewController.m
//  Sahara
//
//  Created by huangcan on 16/1/11.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityEnrollController.h"
#import <ShareSDK/ShareSDK.h>
#import "ShareCustom.h"

@interface ActivityDetailViewController ()

@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton * rightBtn = [[UIButton alloc]init];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"share-ic"] forState:UIControlStateNormal];
    
    [self addCustomNavBarTitle:@"活动详情" leftBar:nil rigthBar:rightBtn whetherAddBackBar:YES];
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_detailDic[@"Url"]]];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnAction:(UIButton *)sender
{
    
    //标题
    NSString *title = _detailDic[@"Title"];
    
    //内容
    NSString *content = @"";
    NSString *woboContent = @"";
    if ([_detailDic[@"Title"] isEqual:[NSNull null]]) {
        content = @"";
        woboContent = [NSString stringWithFormat:@"%@",_detailDic[@"Url"]];
    }else{
        content = _detailDic[@"Title"];
        woboContent = [NSString stringWithFormat:@"%@%@",_detailDic[@"Title"],_detailDic[@"Url"]];
    }
    
    
    
    //图片
    id<ISSCAttachment> localAttachment = [ShareSDKCoreService attachmentWithPath:[[NSBundle mainBundle] pathForResource:@"logo180" ofType:@"png"]];
    
    id<ISSContent> publishContent = [ShareSDK content:content defaultContent:nil image:localAttachment title:title url:_detailDic[@"Url"] description:nil mediaType:SSPublishContentMediaTypeNews];
    
    
    
    
    id<ISSContent> woboPublishContent = [ShareSDK content:woboContent defaultContent:nil image:localAttachment title:title url:_detailDic[@"Url"] description:nil mediaType:SSPublishContentMediaTypeNews];
    
    [ShareCustom shareWithContent:publishContent woboContent:woboPublishContent];
    
}

- (IBAction)saveBtnAction:(UIButton *)sender {
    
    ActivityEnrollController * enrollVC = [[ActivityEnrollController alloc]initWithNibName:@"ActivityEnrollController" bundle:[NSBundle mainBundle]];
    enrollVC.EnrollDic = _detailDic;
    [self.navigationController pushViewController:enrollVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
