//
//  SettingTableViewController.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "SettingTableViewController.h"
#import "SettingCell.h"
#import "UIBarButtonItem+Extention.h"
#import "OpinionTableViewController.h"
#import "SignInViewController.h"
#import "AppDelegate.h"
#import "WebViewViewController.h"

@interface SettingTableViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong)NSArray *settingDetailArray;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    self.tableView.scrollEnabled = NO;
    if ([LoginStorage isLogin] == YES) {
        
        UIButton *btn_tuichu = [[UIButton alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT - 57 - 25 - 64, SCREEN_WIDTH - 30, 57)];
        [self.tableView addSubview:btn_tuichu];
        [btn_tuichu setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
        [btn_tuichu setTitle:@"退出登录" forState:UIControlStateNormal];
        btn_tuichu.layer.cornerRadius = 3;
        btn_tuichu.layer.masksToBounds = YES;
        [btn_tuichu addTarget:self action:@selector(btnTuiChuAction) forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)backItemClick {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 界面设置相关

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingDetailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellId = @"cell";
    
    SettingCell *settingCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (settingCell == nil) {
        settingCell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    settingCell.settingLabel.text = self.settingDetailArray[indexPath.row];
    
    return settingCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = indexPath.row;
    if (row == 0) {
        WebViewViewController *webVc = [[WebViewViewController alloc]init];
        webVc.strTitle = @"关于我们";
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        NSString *version = [NSString stringWithFormat:@"v%@",appVersion];
        // 生产环境
        NSString *SCurl = [NSString stringWithFormat:@"http://wx.haohushi.me/web/#/commonpage/about/ios/0/%@",version];
        // 测试
//        NSString *CSurl = [NSString stringWithFormat:@"http://ci.haohushi.me/web/#/commonpage/about/ios/0/%@",version];
        webVc.strUrl = SCurl;
        
        [self.navigationController pushViewController:webVc animated:YES];
    }
    if (row == 1) {
        if ([LoginStorage isLogin] == YES) {
            OpinionTableViewController *opinionViewController = [[OpinionTableViewController alloc]init];
            [self.navigationController pushViewController:opinionViewController animated:YES];
            opinionViewController.hidesBottomBarWhenPushed = YES;
            
        }else{
            SignInViewController *vc = [[SignInViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (row == 2) {
        WebViewViewController *webVc = [[WebViewViewController alloc]init];
        webVc.strTitle = @"帮助";
        webVc.strUrl = @"http://wx.haohushi.me/web/#/userCenter/help/ios/0";
        [self.navigationController pushViewController:webVc animated:YES];
    }
    if (row == 3) {
        WebViewViewController *webVc = [[WebViewViewController alloc]init];
        webVc.strTitle = @"用户协议";
        webVc.strUrl = @"http://wx.haohushi.me/web/#/commonpage/agreement/ios/2";
        [self.navigationController pushViewController:webVc animated:YES];
    }
    if (row == 4) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"联系客服" message:[LoginStorage phonenum] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认拨打", nil];
        alert.tag = 11;
        [alert show];
    }
    
}

#pragma mark 懒加载数据
- (NSArray *)settingDetailArray {
    if (!_settingDetailArray) {
        _settingDetailArray = [NSArray arrayWithObjects:@"关于我们",@"意见反馈",@"帮助",@"用户协议",@"联系客服", nil];
    }
    return _settingDetailArray;
}

-(void)btnTuiChuAction{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否确认退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    alert.tag = 12;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 12) {
        
        if (buttonIndex == 1) {
            [LoginStorage saveIsLogin:NO];
            NSUserDefaults *userdefaults = [[NSUserDefaults alloc]init];
            [userdefaults removeObjectForKey:@"nickName"];
            [userdefaults removeObjectForKey:@"photo"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag == 11) {
        if (buttonIndex == 1) {
            NSString *str1 = @"tel://";
            NSString *str2 = [LoginStorage phonenum];
            NSString *stt = [NSString stringWithFormat:@"%@%@",str1,str2];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stt]];
        }
    }
}


@end
