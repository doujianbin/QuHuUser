//
//  LinkPageViewController.m
//  DouDouDemo
//
//  Created by lixiao on 15/10/9.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "LinkPageViewController.h"

@interface LinkPageViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)NSArray *arr_images;
@property (nonatomic,strong)UIPageControl *pageControl;

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
    scl_back.delegate = self;
    [scl_back setShowsHorizontalScrollIndicator:NO];
    [scl_back setContentSize:CGSizeMake(self.view.frame.size.width * self.arr_images.count, self.view.frame.size.height)];
    [self.view addSubview:scl_back];
    
//    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - 15 - 15, self.view.frame.size.width, 15)];
//    self.pageControl.numberOfPages = self.arr_images.count;
//    self.pageControl.currentPage = 0;
//    [self.view addSubview:self.pageControl];
    
    for (int i = 0; i < self.arr_images.count; i++) {
        UIImageView *iv_image = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i,0, self.view.frame.size.width , self.view.frame.size.height)];
        iv_image.contentMode = UIViewContentModeScaleAspectFit;
        [iv_image setImage:[UIImage imageNamed:[self.arr_images objectAtIndex:i]]];
        [scl_back addSubview:iv_image];
    }
    UIButton *btn_enter = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 4 +self.view.frame.size.width / 2 - 90,self.view.frame.size.height - 30 - 230 , 180, 260)];
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

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    self.pageControl.currentPage = scrollView.contentOffset.x/self.view.frame.size.width;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
