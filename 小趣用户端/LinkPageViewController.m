//
//  LinkPageViewController.m
//  DouDouDemo
//
//  Created by lixiao on 15/10/9.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "LinkPageViewController.h"

@interface LinkPageViewController ()

@property (nonatomic,strong)NSArray *arr_images;

@end

@implementation LinkPageViewController

- (instancetype)initWithImageArray:(NSArray *)arr_images{
    self = [self init];
    if (self) {
        self.arr_images = arr_images;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scl_back = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [scl_back setPagingEnabled:YES];
    [scl_back setShowsHorizontalScrollIndicator:NO];
    [scl_back setContentSize:CGSizeMake(self.view.frame.size.width * self.arr_images.count, self.view.frame.size.height)];
    [self.view addSubview:scl_back];
    
    for (int i = 0; i < self.arr_images.count; i++) {
        UIImageView *iv_image = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i,0, self.view.frame.size.width , self.view.frame.size.height)];
        iv_image.contentMode = UIViewContentModeScaleAspectFit;
        [iv_image setImage:[UIImage imageNamed:[self.arr_images objectAtIndex:i]]];
        [scl_back addSubview:iv_image];
    }
    UIButton *btn_enter = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 3 +self.view.frame.size.width / 2 - 90,self.view.frame.size.height - 30 - 230 , 180, 100)];
    [btn_enter addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    [scl_back addSubview:btn_enter];

    
}

- (void)enterAction{
    [self.delegate enterMainViewController];
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
