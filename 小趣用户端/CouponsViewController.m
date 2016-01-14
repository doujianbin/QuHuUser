//
//  CouponsViewController.m
//  小趣用户端
//
//  Created by 李禹 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "CouponsViewController.h"

#import "CouponsCell.h"

#import "UIBarButtonItem+Extention.h"

@interface CouponsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *couponsTableView;

@end

@implementation CouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠券";
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self setupInterface];
}

- (void)backItemClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupInterface {

    UIView *chargeView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 75)];
    chargeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chargeView];
    
    UITextField *couponIdText = [[UITextField alloc]initWithFrame:CGRectMake(13, 16, 234, 44)];
    couponIdText.borderStyle = UITextBorderStyleRoundedRect;
    [chargeView addSubview:couponIdText];
    
    UIButton *exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 115, 16, 100, 44);
    
    UIImage *buttonBgImage = [UIImage imageNamed:@"exchangebackground"];
    
    [exchangeButton setBackgroundImage:[buttonBgImage stretchableImageWithLeftCapWidth:buttonBgImage.size.width/2 topCapHeight:buttonBgImage.size.height/2] forState:UIControlStateNormal];
    [exchangeButton setBackgroundImage:[buttonBgImage stretchableImageWithLeftCapWidth:buttonBgImage.size.width/2 topCapHeight:buttonBgImage.size.height/2] forState:UIControlStateHighlighted];
    [chargeView addSubview:exchangeButton];

    [self.view addSubview:chargeView];
    
    UITableView *couponsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,139 , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 139)];
    couponsTableView.backgroundColor = COLOR(245, 246, 247, 1);
    couponsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    couponsTableView.delegate = self;
    couponsTableView.dataSource = self;
    self.couponsTableView = couponsTableView;
    
    [self.view addSubview:couponsTableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cell";
    
    CouponsCell *cell = [self.couponsTableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CouponsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.chargeLabel.text = @"jlkj";
        cell.couponImageView.image = [UIImage imageNamed:@"countbg1"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}



@end
