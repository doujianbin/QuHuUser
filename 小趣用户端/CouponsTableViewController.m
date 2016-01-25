//
//  CouponsViewController.m
//  小趣用户端
//
//  Created by 刘宇飞 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "CouponsTableViewController.h"

#import "CouponsCell.h"

#import "UIBarButtonItem+Extention.h"

@interface CouponsTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *couponsTableView;
@property (nonatomic, weak)UITextField *couponIdTextField;

@property (nonatomic, strong)NSArray *dataArray;

@property (nonatomic, strong)AFNManager *manager;


@end

@implementation CouponsTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠券";
    
    self.view.backgroundColor = COLOR(245, 246, 247, 1);
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"Rectangle 91 + Line + Line Copy" highlightedImageName:@"Rectangle 91 + Line + Line Copy" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self setupInterface];
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidKeyBoard)];
//    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self makeURLRequest];
}

- (void)makeURLRequest {
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/coupon/getCouponList",Development];
    
    AFNManager *manager = [AFNManager shareManager];
    
    [manager RequestJsonWithUrl:url method:@"POST" parameter:nil result:^(id responseDic) {
        
        NSArray *mutableArray = [responseDic objectForKey:@"data"];
        
        self.dataArray = mutableArray;
        
        self.manager = manager;
        
        [self.couponsTableView reloadData];
        
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

- (void)hidKeyBoard {
    
//    [self.view endEditing:YES];
}

- (void)backItemClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupInterface {

    UIView *chargeView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 75)];
    chargeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chargeView];
    
    UITextField *couponIdTextField = [[UITextField alloc]initWithFrame:CGRectMake(13, 16, [UIScreen mainScreen].bounds.size.width - 141, 44)];
    couponIdTextField.placeholder = @"请输入优惠码";
    couponIdTextField.borderStyle = UITextBorderStyleRoundedRect;
    couponIdTextField.keyboardType = UIKeyboardTypeNumberPad;
    couponIdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.couponIdTextField = couponIdTextField;
    [chargeView addSubview:couponIdTextField
     ];
    
    UIButton *exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 115, 16, 100, 44);
    
    UIImage *buttonBgImage = [UIImage imageNamed:@"exchangebackground"];
    
    [exchangeButton setBackgroundImage:[buttonBgImage stretchableImageWithLeftCapWidth:buttonBgImage.size.width/2 topCapHeight:buttonBgImage.size.height/2] forState:UIControlStateNormal];
    [exchangeButton addTarget:self action:@selector(exchangeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [chargeView addSubview:exchangeButton];

    [self.view addSubview:chargeView];
    
    UITableView *couponsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,139 , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 139 - 44)];
    couponsTableView.backgroundColor = COLOR(245, 246, 247, 1);
    couponsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    couponsTableView.delegate = self;
    couponsTableView.dataSource = self;
    self.couponsTableView = couponsTableView;
    
    [self.view addSubview:couponsTableView];
    
}

- (void)exchangeButtonClick {
        
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/coupon/bindCoupon",Development];
    
    NSString *couponCode = self.couponIdTextField.text;
    NSDictionary *mdic = @{@"couponCode":couponCode};
    
    [self.manager RequestJsonWithUrl:url method:@"POST" parameter:mdic result:^(id responseDic) {
        
        if ([[responseDic objectForKey:@"status"]isEqualToString:@"SUCCESS"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[responseDic objectForKey:@"message"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }else {
           
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[responseDic objectForKey:@"message"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        }
        
        [self makeURLRequest];
        
    } fail:^(NSError *error) {
        
        NSLog(@"error");
        NSLog(@"%@",error);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cell";
    
    CouponsCell *cell = [self.couponsTableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CouponsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    NSLog(@"%@",dic);
    
    NSString *valueString = [[dic objectForKey:@"value"]stringValue];
    
        if ([[dic objectForKey:@"isPast"]isEqualToString:@"1"]) {
            if ([[dic objectForKey:@"type"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                cell.couponImageView.image = [UIImage imageNamed:@"overtimebg"];
                
                cell.chargeLabel.text = [NSString stringWithFormat:@"%@折",valueString];
                cell.chargeLabel.textColor = COLOR(74, 74, 74, 1);
                
                cell.couponTypeLabel.text = @"折扣券";
                cell.couponTypeLabel.textColor = COLOR(208, 208, 208, 1);
                
                cell.endTimeLabel.text = [dic objectForKey:@"expireTime"];
                cell.endTimeLabel.textColor = COLOR(208, 208, 208, 1);
                
            }else {
                
                cell.couponImageView.image = [UIImage imageNamed:@"countbg1"];
                
                cell.chargeLabel.text = [NSString stringWithFormat:@"￥%@",valueString];
                cell.chargeLabel.textColor = COLOR(208, 208, 208, 1);
                
                cell.couponTypeLabel.text = @"抵用券";
                cell.couponTypeLabel.textColor = COLOR(208, 208, 208, 1);
                
                cell.endTimeLabel.text = [dic objectForKey:@"expireTime"];
                cell.endTimeLabel.textColor = COLOR(208, 208, 208, 1);
                
            }
            
        }else{
            
            if ([[dic objectForKey:@"type"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                cell.couponImageView.image = [UIImage imageNamed:@"countbg2"];
                
                cell.chargeLabel.text = [NSString stringWithFormat:@"%@折",valueString];
                cell.chargeLabel.textColor = COLOR(74, 74, 74, 1);
                
                cell.couponTypeLabel.text = @"折扣券";
                cell.couponTypeLabel.textColor = COLOR(74, 74, 74, 1);
                
                cell.endTimeLabel.text = [dic objectForKey:@"expireTime"];
                cell.endTimeLabel.textColor = COLOR(155, 155, 155, 1);
                
            }else {
                
                cell.couponImageView.image = [UIImage imageNamed:@"countbg1"];
                
                cell.chargeLabel.text = [NSString stringWithFormat:@"￥%@",valueString];
                cell.chargeLabel.textColor = COLOR(74, 74, 74, 1);
                
                cell.couponTypeLabel.text = @"抵用券";
                cell.couponTypeLabel.textColor = COLOR(74, 74, 74, 1);
                
                cell.endTimeLabel.text = [dic objectForKey:@"expireTime"];
                cell.endTimeLabel.textColor = COLOR(155, 155, 155, 1);                
            
        }

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFromOrder) {
        if ([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"isPast"] intValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"过期的优惠券暂时无法使用哦" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            
            NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
            [self.delegate didSelectedCouponsWithDic:dic];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 124.5;
}

@end
