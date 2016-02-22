//
//  AgreeMentViewController.m
//  Sahara
//
//  Created by bodecn on 15/10/30.
//  Copyright © 2015年 bodecn. All rights reserved.
//

#import "AgreeMentViewController.h"

@interface AgreeMentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AgreeMentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addCustomNavBarTitle:@"用户注册协议" leftBar:nil rigthBar:nil whetherAddBackBar:YES];
    self.textView.layoutManager.allowsNonContiguousLayout = NO;//处理文字显示不是从最开始显示问题
    self.textView.text = @"使用Sahara(下称“Sahara”或“我们”)，您必须同意遵守以下条款：\n一、基本条款\n1、您必须为自己注册用户下的行为负责。\n2、您有责任妥善保存你的密码。\n3、您不能使用Sahara的服务来进行任何非法或者未经授权的行为。国际用户同意遵守当地有关约束互联网行为和内容的法律。\n4、本站点上张贴的内容和禁止内容：\n（1）除了可识别个人的信息之外，任何您在此网站上公布的资料都将视为非机密和非专有的。 我们对该类资料将不承担责任。我们和我们指定的人员可自由复制、披露、散布、整合和以其他方式使用该类资料和所有数据、图像、声音、文本和其中包含的其他内容，以用作任何和全部商业或非商业目的。\n（2）Sahara有权审查并删除任何内容、邮件、照片或文本（统称为“内容”），只要Sahara经过合理判断，认为该类内容违反了本协议，或具有攻击性、违法性，或侵犯权利，损害或威胁会员安全。\n（3）您声称并保证您在任何时候公布的内容是 (a) 未违反本协议 (b) 不会伤害到任何其他人。\n（4）通过将内容公布到Sahara的公共区域，表示您同意，您自动授予，并且你声称并保证您有权授予Sahara一项不可取消的、永久的、非独占的、完全付费的、世界范围的许可，以使用、复制、执行、显示并散布该类信息和内容，也可准备该类信息和内容的衍生作品或整合到其他作品中，以及授予上述权利的再授权。\n5、以下是违法的或Sahara禁止内容的部分列表：\n（1）Sahara保留以下权利：随时修改该列表、根据自己独立的判断对违反本规定的任何人进行调查并采取适当的法律行动，包括但不限于，从本服务上删除侮辱性言论和终止该类侵犯者的会员身份。\n（2）包括的内容有：对在线社区有明显攻击性，如宣传对任何团体或个人的种族歧视、偏见、憎恨或对任何群组或个人带来实际伤害的内容。\n（3）未经第三人允许，构建其档案或使用其照片。\n（4）骚扰或鼓动对其他人进行骚扰；\n（5）参与传播“垃圾邮件”、“连锁信”或未经请求的大量邮件或“兜售信息”；\n（6）宣传您知道是错误的、误导性信息，或宣传违法活动，或宣扬辱骂的、威胁性、猥亵、诽谤或损害他人名誉的行为；\n（7）宣传其他人受版权保护作品的违法的、未经授权的副本，如提供盗版计算机程序或这些程序的链接、提供如何规避制造商所安装之副本保护设备的信息、或提供盗版音乐或这些盗版音乐文件夹的链接；\n（8）包含受限的或需要密码才可访问的页面，或隐藏页面或图像（未链接至或未链接自其他可访问页面）；\n（9）提供以性或暴力的方式利用 18周岁以下青少年的资料，或从低于 18 周岁的人那里索取个人信息；\n（10）提供关于违法活动的指导性信息，如制造或购买非法武器、侵犯他人隐私、提供或制造计算机病毒；\n（11）从其他用户处索取密码或个人标识信息，用作商业或非法之目的；\n（12）以及未经我们事先书面许可，参加商业活动和/或销售活动，如竞赛、赌_博、交易、广告和金字塔计划。\n（13）以下几类图片一旦发现我们将立即删除，并且封号，并可能根据监管部门要求提供发布者的ip地址,请您上传前务必注意:\n（14）带明显的挑逗性质的；\n（15）泳装女性臀部面对镜头、做性暗示动作及表情的；\n（16）露点及用很小遮盖物防露点的；\n（17）用朦胧的方式表达色情的；\n（18）穿着SM或成人性质的衣物或成人用品的；\n（19）故意走光的；\n（20）特写女性或男性下体的等；\n（21）各类色情文字、漫画，卖_淫、嫖_娼、赌_博信息等；\n（22）涉及政治, 胡乱军事特写，邪教类等；\n（23）国外禁播MTV片断；\n（24）带性暗示的广告片断；\n（25）三级及AV片中的诱惑性片断；\n（26）枪支弹药；非法药物,如麻_醉_药,迷_魂_药等。\n（27）使用本服务时，您必须遵守任何和全部的中华人民共和国适用法律、法规和行为守则。\n（28）您不应从事通过本服务向其他会员推销或请求其购买或出售任何产品或服务的行为，也不应因商业目的参加团体或其他社会活动或网络。 您不可以传播任何连锁信或垃圾邮件给其他会员。\n二、一般条款\n1、我们保留在任何时候改变这些服务条款的权利。如果对使用条款有重大的改变，我们将通过您帐户中最常用的电子邮件通知您。什么是“重大改变”取决于我们的诚信，使用常识和合理判断。\n2、我们保留在任何时候，以任何理由向任何人拒绝提供服务的权利。\n3、用户可以把Sahara上的图片和文字发布到外部网站。我们许可并鼓励这种方式。但是，发布到其它网站上的资料必须显示有返回到Sahara的链接。\n4、我们保留收回企业或个人拥有法律权利或商标权的用户名称的权利。\n";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
