//
//  ShareViewController.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "ShareViewController.h"

#import "UIBarButtonItem+Extention.h"

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐有礼";
    
//界面布局
    [self setupInterface];
    
    self.view.backgroundColor = [UIColor whiteColor];
//设置返回UIBarButtonItem
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setupInterface {

    UIView *backgroundview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundview.backgroundColor = COLOR(255, 250, 235, 1);
    
    UIImageView *shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    shareImageView.contentMode = UIViewContentModeCenter;
    shareImageView.image =[UIImage imageNamed:@"group"];
    [backgroundview addSubview:shareImageView];
    
    UILabel *giftLibel = [[UILabel alloc]initWithFrame:CGRectMake(31, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width - 62, 51.5)];
    NSMutableAttributedString *giftString = [[NSMutableAttributedString alloc]initWithString:@"送给朋友99元大礼包，您将也获得99元 优惠券！"];
    [giftString addAttribute:NSForegroundColorAttributeName value:COLOR(250, 98, 98, 1) range:NSMakeRange(4, 2)];
    [giftString addAttribute:NSForegroundColorAttributeName value:COLOR(250, 98, 98, 1) range:NSMakeRange(16, 2)];
    giftLibel.attributedText = giftString;
    giftLibel.numberOfLines = 2;
    giftLibel.textAlignment = NSTextAlignmentCenter;
    [backgroundview addSubview:giftLibel];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(19.5, [UIScreen mainScreen].bounds.size.width + 90, [UIScreen mainScreen].bounds.size.width - 39, 44);
    [shareButton setTitle:@"分享到社交圈" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"redbackground"];
    [shareButton setBackgroundImage:[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2] forState:UIControlStateNormal];
//    [shareButton setBackgroundImage:[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundview addSubview:shareButton];
    
    [self.view addSubview:backgroundview];
    
    
}

- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonClick {

    NSLog(@"shareButtonClick");
}

@end
