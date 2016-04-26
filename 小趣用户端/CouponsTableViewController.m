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
#import "Toast+UIView.h"
#import <MJRefresh/MJRefresh.h>

@interface CouponsTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *couponsTableView;
@property (nonatomic, weak)UITextField *couponIdTextField;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)AFNManager *manager;
@property (nonatomic, strong)UIView *tab_backGroundView;


@end

@implementation CouponsTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠券";
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    
    UIBarButtonItem *item = [UIBarButtonItem barButtonitemWithNormalImageName:@"backArrow" highlightedImageName:@"backArrow" target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItem = item;
    [self.view addSubview:[UIView new]];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    [self setupInterface];
    
    [self makeURLRequest];
}

- (void)makeURLRequest {
//    BeginActivity;
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/coupon/getCouponList",Development];
    
    AFNManager *manager = [[AFNManager alloc] init];
    
    [manager RequestJsonWithUrl:url method:@"POST" parameter:nil result:^(id responseDic) {
//        EndActivity;
        if ([Status isEqualToString:SUCCESS]) {
            
            [self.couponsTableView.mj_header endRefreshing];
            self.couponIdTextField.text = @"";
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:[responseDic objectForKey:@"data"]];
            [self.couponsTableView reloadData];
        }
        NSArray * arr = [responseDic objectForKey:@"data"];
        if (arr.count > 0) {
            [self.couponsTableView setBackgroundView:nil];
        }else{
            [self.couponsTableView setBackgroundView:self.tab_backGroundView];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
//        EndActivity;
        NetError;
        [self.couponsTableView.mj_header endRefreshing];
    }];
}

- (void)backItemClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupInterface {
    UIView *chargeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 75)];
    chargeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chargeView];
    
    UIImageView *imgheng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 74.5, SCREEN_WIDTH, 0.5)];
    [chargeView addSubview:imgheng];
    [imgheng setBackgroundColor:[UIColor colorWithHexString:@"#DBDCDD"]];
    
    UITextField *couponIdTextField = [[UITextField alloc]initWithFrame:CGRectMake(13, 16, [UIScreen mainScreen].bounds.size.width - 141, 44)];
    couponIdTextField.placeholder = @"请输入优惠码";
    couponIdTextField.borderStyle = UITextBorderStyleRoundedRect;
    couponIdTextField.keyboardType = UIKeyboardTypeNumberPad;
    couponIdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    couponIdTextField.font = [UIFont systemFontOfSize:14];
    couponIdTextField.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
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
    
    UITableView *couponsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,140 - 64 , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 139 - 44)];
    couponsTableView.backgroundColor = COLOR(245, 246, 247, 1);
    couponsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    couponsTableView.delegate = self;
    couponsTableView.dataSource = self;
    self.couponsTableView = couponsTableView;
    self.couponsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self makeURLRequest];
    }];
    [self.view addSubview:couponsTableView];
    
    self.tab_backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.couponsTableView.frame.size.width, self.couponsTableView.frame.size.height)];
    UIImageView *img_nothing = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 115) / 2 ,(self.tab_backGroundView.frame.size.height - 127)/2 - 80, 115, 127)];
    [self.tab_backGroundView addSubview:img_nothing];
    [img_nothing setImage:[UIImage imageNamed:@"nothingView"]];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(img_nothing.frame) + 20 , SCREEN_WIDTH, 20)];
    [self.tab_backGroundView addSubview:lab];
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab setText:@"您还没有优惠券哦～"];
    
}

- (void)exchangeButtonClick {
    BeginActivity;
    NSString *url = [NSString stringWithFormat:@"%@/quhu/accompany/user/coupon/bindCoupon",Development];
    
    NSString *couponCode = self.couponIdTextField.text;
    NSDictionary *mdic = @{@"couponCode":couponCode};
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:url method:@"POST" parameter:mdic result:^(id responseDic) {
        EndActivity;
        if ([Status isEqualToString:SUCCESS]) {
            
            [self.couponsTableView.mj_header beginRefreshing];
        }
        [self.view makeToast:Message duration:1.0 position:@"center"];
        
    } fail:^(NSError *error) {
        EndActivity;
        NetError;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count == 0) {
        return 0;
    }else {
        
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cell";
    
    CouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CouponsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    NSLog(@"%@",dic);
    
    NSString *valueString = [[dic objectForKey:@"value"]stringValue];
    
        if ([[dic objectForKey:@"isPast"]isEqualToString:@"1"]) {
            if ([[dic objectForKey:@"type"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                CGFloat cValue = [valueString floatValue] * 10;
                NSString *str = [NSString stringWithFormat:@"%.1f",cValue];
                cell.couponImageView.image = [UIImage imageNamed:@"overtimebg"];
                
                cell.chargeLabel.text = [NSString stringWithFormat:@"%@折",str];
                cell.chargeLabel.textColor = COLOR(74, 74, 74, 1);
                
                cell.couponTypeLabel.text = @"折扣券";
                cell.couponTypeLabel.textColor = COLOR(208, 208, 208, 1);
                NSString *scheduleT = [[dic objectForKey:@"expireTime"] substringToIndex:10];
                cell.endTimeLabel.text = [NSString stringWithFormat:@"有效期至 %@",scheduleT];
                cell.endTimeLabel.textColor = COLOR(208, 208, 208, 1);
                
            }else {
                
                
                cell.couponImageView.image = [UIImage imageNamed:@"countbg1"];
                
                cell.chargeLabel.text = [NSString stringWithFormat:@"%@元",valueString];
                cell.chargeLabel.textColor = COLOR(208, 208, 208, 1);
                
                cell.couponTypeLabel.text = @"抵用券";
                cell.couponTypeLabel.textColor = COLOR(208, 208, 208, 1);
                
                NSString *scheduleT = [[dic objectForKey:@"expireTime"] substringToIndex:10];
                cell.endTimeLabel.text = [NSString stringWithFormat:@"有效期至 %@",scheduleT];
                cell.endTimeLabel.textColor = COLOR(208, 208, 208, 1);
                
            }
            
        }else{
            
            if ([[dic objectForKey:@"type"]isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                CGFloat cValue = [valueString floatValue] * 10;
                NSString *str = [NSString stringWithFormat:@"%.1f",cValue];
                cell.couponImageView.image = [UIImage imageNamed:@"countbg2"];
                
                cell.chargeLabel.text = [NSString stringWithFormat:@"%@折",str];
        
                cell.chargeLabel.textColor = COLOR(74, 74, 74, 1);
                
                cell.couponTypeLabel.text = @"折扣券";
                cell.couponTypeLabel.textColor = COLOR(74, 74, 74, 1);
                
                NSString *scheduleT = [[dic objectForKey:@"expireTime"] substringToIndex:10];
                cell.endTimeLabel.text = [NSString stringWithFormat:@"有效期至 %@",scheduleT];
                cell.endTimeLabel.textColor = COLOR(155, 155, 155, 1);
                
            }else {
                
                cell.couponImageView.image = [UIImage imageNamed:@"countbg1"];
                
                cell.chargeLabel.text = [NSString stringWithFormat:@"%@元",valueString];
                cell.chargeLabel.textColor = COLOR(74, 74, 74, 1);
                
                cell.couponTypeLabel.text = @"抵用券";
                cell.couponTypeLabel.textColor = COLOR(74, 74, 74, 1);
                
                NSString *scheduleT = [[dic objectForKey:@"expireTime"] substringToIndex:10];
                cell.endTimeLabel.text = [NSString stringWithFormat:@"有效期至 %@",scheduleT];
                cell.endTimeLabel.textColor = COLOR(155, 155, 155, 1);                
            
        }

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    return 114.5;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
     [self.view endEditing:YES];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [self.tabBarController.tabBar setHidden:YES];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [self.tabBarController.tabBar setHidden:NO];
//}

@end
