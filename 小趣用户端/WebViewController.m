//
//  WebViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/19.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"预约陪诊";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://web.quyiyuan.com/h5/"]];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    // Do any additional setup after loading the view.
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
