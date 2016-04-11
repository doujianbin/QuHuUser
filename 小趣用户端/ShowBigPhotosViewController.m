//
//  ShowCertificateBigPhotosViewController.m
//  zlycare-iphone
//
//  Created by lixiao on 14-10-13.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import "ShowBigPhotosViewController.h"
#import "UIImageView+WebCache.h"
@interface ShowBigPhotosViewController ()

@end

@implementation ShowBigPhotosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    float height = self.view.frame.size.height + 64;
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%lu",self.int_index + 1,(unsigned long)self.arr_images.count];
//    UIBarButtonItem *barbtn_cancel = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel:)];
//    self.navigationItem.leftBarButtonItem = barbtn_cancel;
    _sv_showBigPhoto = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, height)];
    _sv_showBigPhoto.userInteractionEnabled = YES;
    _sv_showBigPhoto.delegate = self;
    _sv_showBigPhoto.pagingEnabled = YES;
    _sv_showBigPhoto.userInteractionEnabled = YES;
    _sv_showBigPhoto.showsHorizontalScrollIndicator = NO;
    _sv_showBigPhoto.showsVerticalScrollIndicator = NO;
    _sv_showBigPhoto.bounces = NO;
    [self.view addSubview:_sv_showBigPhoto];
    [_sv_showBigPhoto setContentSize:CGSizeMake(SCREEN_WIDTH * self.arr_images.count, height - 64)];
    [_sv_showBigPhoto setContentOffset:CGPointMake(SCREEN_WIDTH * self.int_index, 0)];
    
    for (int i = 0; i < self.arr_images.count ; i++) {
        _zoomScrollView_showPhoto = [[MRZoomScrollView alloc]init];
        [_zoomScrollView_showPhoto setContentSize:CGSizeMake(SCREEN_WIDTH, height - 64)];
        CGRect frame = self.sv_showBigPhoto.frame;
        frame.origin.x = SCREEN_WIDTH * i;
        frame.origin.y = 0;
        
        _zoomScrollView_showPhoto.frame = frame;
//        [_zoomScrollView_showPhoto.imageView setFrame:frame];
        
        //添加风火轮，图片没有加载完成时显示
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 25)+SCREEN_WIDTH*i,(height - 64)/2 - 25, 50, 50)];
        //设置显示样式,见UIActivityIndicatorViewStyle的定义
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        //设置背景色
        indicator.color = [UIColor grayColor];
        indicator.backgroundColor = [UIColor whiteColor];
        //设置背景透明
        indicator.alpha = 0.5;
        //设置背景为圆角矩形
        indicator.layer.cornerRadius = 8;
        indicator.layer.masksToBounds = YES;
        //开始显示Loading动画
        [indicator startAnimating];
        [self.sv_showBigPhoto addSubview:indicator];
        
        //获取图片的url 并且加载
        NSURL *url = [self.arr_images objectAtIndex:i];
        
//        [_zoomScrollView_showPhoto.imageView sd_setImageWithURL:url placeholderImage:nil];
        [_zoomScrollView_showPhoto.imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [indicator stopAnimating];
            }
        }];
        [_zoomScrollView_showPhoto.imageView setFrame:CGRectMake( SCREEN_WIDTH/2 - 40,(height - 64)/2 - 40,80,80)];
        [UIView animateWithDuration:0.4 animations:^{
            [_zoomScrollView_showPhoto.imageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, height - 64)];
        }];
        [_zoomScrollView_showPhoto.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.sv_showBigPhoto addSubview:_zoomScrollView_showPhoto];
        
    }
}

//显示当前是在第几张图片
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%lu",(int)(_sv_showBigPhoto.contentOffset.x / SCREEN_WIDTH + 1) ,(unsigned long)self.arr_images.count];
}

-(void)cancel:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
