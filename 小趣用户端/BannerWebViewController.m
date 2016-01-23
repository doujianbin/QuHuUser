//
//  BannerWebViewController.m
//  小趣用户端
//
//  Created by lixiao on 16/1/21.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "BannerWebViewController.h"

@interface BannerWebViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView* webView;


@end

@implementation BannerWebViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title= @"推广";
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];

    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    [self.view addSubview:_webView];
    
}

-(void)NavLeftAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.str_url]]];
}

-(void)dealloc
{
    [_webView stopLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



@end
