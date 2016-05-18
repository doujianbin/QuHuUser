//
//  AdImgViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/5/17.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "AdImgViewController.h"
#import "AppDelegate.h"

@interface AdImgViewController (){

}
@property (nonatomic ,strong)UIImageView *img_adVC;
@end

@implementation AdImgViewController

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.img_adVC = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:_img_adVC];
    [_img_adVC setImage:[UIImage imageNamed:@"750x1334"]];
    
    [self loadData];
    
    //Do any additional setup after loading the view.
}

-(void)loadData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetOneOpenAd];
    NSDictionary *dic = @{@"os":@"ios"};
    AFNManager *manager = [[AFNManager alloc]init];
    [manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        if ([Status isEqualToString:SUCCESS]) {
            if ([[responseDic objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                [(AppDelegate*)[UIApplication sharedApplication].delegate setTabBarRootView];
            }else{
                UIButton *btn_tiaoguo = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 78, 19, 58, 27)];
                [self.view addSubview:btn_tiaoguo];
                btn_tiaoguo.layer.cornerRadius = 2.0f;
                btn_tiaoguo.layer.masksToBounds = YES;
                [btn_tiaoguo setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.6]];
                [btn_tiaoguo setTitle:@"跳过" forState:UIControlStateNormal];
                btn_tiaoguo.titleLabel.font = [UIFont systemFontOfSize:17];
                [btn_tiaoguo setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                [btn_tiaoguo addTarget:self action:@selector(tiaoguoAction) forControlEvents:UIControlEventTouchUpInside];
                [self startTimeCount];
                [_img_adVC sd_setImageWithURL:[NSURL URLWithString:[[responseDic objectForKey:@"data"] objectForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"750x1334"]];
            }
        }else{
            [(AppDelegate*)[UIApplication sharedApplication].delegate setTabBarRootView];
        }
    } fail:^(NSError *error) {
        [(AppDelegate*)[UIApplication sharedApplication].delegate setTabBarRootView];
    }];
}

-(void)startTimeCount{
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(tiaoguoAction)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)tiaoguoAction{
    [(AppDelegate*)[UIApplication sharedApplication].delegate setTabBarRootView];
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
