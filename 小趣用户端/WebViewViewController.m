//
//  WebViewViewController.m
//  小趣医生端
//
//  Created by 窦建斌 on 16/2/24.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "WebViewViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface WebViewViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>{
    NJKWebViewProgressView *_webViewProgressView;
    NJKWebViewProgress *_webViewProgress;
}
@property (nonatomic ,strong)UIWebView *webView;

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.translucent = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = self.strTitle;
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.webView];
    self.webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    
    
//    _webViewProgress = [[NJKWebViewProgress alloc] init];
//    _webView.delegate = _webViewProgress;
//    _webViewProgress.webViewProxyDelegate = self;
//    _webViewProgress.progressDelegate = self;
//    
//    
//    CGRect navBounds = self.navigationController.navigationBar.bounds;
//    CGRect barFrame = CGRectMake(0,
//                                 navBounds.size.height - 2,
//                                 navBounds.size.width,
//                                 2);
//    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    [_webViewProgressView setProgress:0 animated:YES];
    [self loadRequest];
//    [self.navigationController.navigationBar addSubview:_webViewProgressView];
}

-(void)loadRequest{
    NSURL *url = [NSURL URLWithString:self.strUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
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
