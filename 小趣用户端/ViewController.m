//
//  ViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/10.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()

@property (nonatomic ,strong)UIImageView *img_adVC;

@end

@implementation ViewController

-(void)loadView{
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.img_adVC = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:_img_adVC];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}

-(void)loadData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetOneOpenAd];
    AFNManager *manager = [[AFNManager alloc]init];
    [manager RequestJsonWithUrl:strUrl method:@"POST" parameter:nil result:^(id responseDic) {
        if ([Status isEqualToString:SUCCESS]) {
            if ([[responseDic objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                //                [self setTabBarRootView];
            }else{
                
                [_img_adVC sd_setImageWithURL:[NSURL URLWithString:[[responseDic objectForKey:@"data"] objectForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"750x1334"]];
            }
        }else{
            //            [self setTabBarRootView];
        }
    } fail:^(NSError *error) {
        //        [self setTabBarRootView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
