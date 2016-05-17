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
#import "CouponsEntity.h"
#import "CouponsTableViewCell.h"

@interface CouponsTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *couponsTableView;
@property (nonatomic, strong)UITextField *couponIdTextField;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)AFNManager *manager;
@property (nonatomic, strong)UIView *tab_backGroundView;
@property (nonatomic ,strong)NSMutableArray *arr_weiguoqi;
@property (nonatomic ,strong)NSMutableArray *arr_guoqi;


@end

@implementation CouponsTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc]init];
        self.arr_weiguoqi = [[NSMutableArray alloc]init];
        self.arr_guoqi = [[NSMutableArray alloc]init];
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
    if (self.isFromOrder) {
        // 从下单界面进入
        NSString *url = [NSString stringWithFormat:@"%@%@",Development,QueryUserCouponsByAreaIdAndOrderType];
                NSDictionary *dic = @{@"orderType":@"2",@"areaId":@"110100"};
        AFNManager *manager = [[AFNManager alloc] init];
        
        [manager RequestJsonWithUrl:url method:@"POST" parameter:dic result:^(id responseDic) {
            //        EndActivity;
            [self.couponsTableView.mj_header endRefreshing];
            if ([Status isEqualToString:SUCCESS]) {
                self.couponIdTextField.text = @"";
                [self.arr_weiguoqi removeAllObjects];
                [self.arr_guoqi removeAllObjects];
                [self.dataArray removeAllObjects];
                
                for (NSDictionary *dic in [responseDic objectForKey:@"data"]) {
                    if ([[dic objectForKey:@"useable"] intValue] == 1) {
                        [self.arr_weiguoqi addObject:dic];
                    }if ([[dic objectForKey:@"useable"] intValue] == 0){
                        [self.arr_guoqi addObject:dic];
                    }
                }
                
                if (self.arr_weiguoqi.count > 0) {
                    [self.dataArray addObject:self.arr_weiguoqi];
                }
                if (self.arr_guoqi.count > 0) {
                    [self.dataArray addObject:self.arr_guoqi];
                }
                
                NSArray * arr = [responseDic objectForKey:@"data"];
                if (arr.count > 0) {
                    [self.couponsTableView setBackgroundView:nil];
                    [self.couponsTableView reloadData];
                }else{
                    [self.couponsTableView setBackgroundView:self.tab_backGroundView];
                }
            }else{
                [self.view makeToast:Message duration:1.0 position:@"center"];
            }
            
        } fail:^(NSError *error) {
            NSLog(@"%@",error);
            //        EndActivity;
            NetError;
            [self.couponsTableView.mj_header endRefreshing];
        }];

        }else{
                
                NSString *url = [NSString stringWithFormat:@"%@%@",Development,QueryUserCouponsAll];
//                NSDictionary *dic = @{@"orderType":@"2",@"areaId":@"110100"};
                AFNManager *manager = [[AFNManager alloc] init];
                
                [manager RequestJsonWithUrl:url method:@"POST" parameter:nil result:^(id responseDic) {
                    //        EndActivity;
                    [self.couponsTableView.mj_header endRefreshing];
                    if ([Status isEqualToString:SUCCESS]) {
                        self.couponIdTextField.text = @"";
                        [self.arr_weiguoqi removeAllObjects];
                        [self.arr_guoqi removeAllObjects];
                        [self.dataArray removeAllObjects];
                        
                        for (NSDictionary *dic in [responseDic objectForKey:@"data"]) {
                            if ([[dic objectForKey:@"useable"] intValue] == 1) {
                                [self.arr_weiguoqi addObject:dic];
                            }if ([[dic objectForKey:@"useable"] intValue] == 0){
                                [self.arr_guoqi addObject:dic];
                            }
                        }
                        
                        if (self.arr_weiguoqi.count > 0) {
                            [self.dataArray addObject:self.arr_weiguoqi];
                        }
                        if (self.arr_guoqi.count > 0) {
                            [self.dataArray addObject:self.arr_guoqi];
                        }
                        
                        NSArray * arr = [responseDic objectForKey:@"data"];
                        if (arr.count > 0) {
                            [self.couponsTableView setBackgroundView:nil];
                            [self.couponsTableView reloadData];
                        }else{
                            [self.couponsTableView setBackgroundView:self.tab_backGroundView];
                        }
                    }else{
                        [self.view makeToast:Message duration:1.0 position:@"center"];
                    }
                    
                } fail:^(NSError *error) {
                    NSLog(@"%@",error);
                    //        EndActivity;
                    NetError;
                    [self.couponsTableView.mj_header endRefreshing];
                }];

        }
    
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
    
    self.couponsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,140 - 64 , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 76 - 64)];
    self.couponsTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F9"];
    self.couponsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.couponsTableView.delegate = self;
    self.couponsTableView.dataSource = self;

    self.couponsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self makeURLRequest];
    }];
    [self.view addSubview:self.couponsTableView];
    
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

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"11";
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.dataArray objectAtIndex:section] count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *viewS = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120) / 2, 28, 120, 14)];
    [viewS addSubview:lab];
    [lab setTextColor:[UIColor colorWithHexString:@"#A4A4A4"]];
    [lab setFont:[UIFont systemFontOfSize:14]];
    [lab setText:@"不可用优惠券"];
    [lab setTextAlignment:NSTextAlignmentCenter];
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 34, (SCREEN_WIDTH - 130) / 2 - 15, 0.7)];
    [viewS addSubview:img1];
    [img1 setBackgroundColor:[UIColor colorWithHexString:@"#cccccc"]];
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - (SCREEN_WIDTH - 130) / 2 + 15, 34, (SCREEN_WIDTH - 130) / 2 - 15, 0.7)];
    [viewS addSubview:img2];
    [img2 setBackgroundColor:[UIColor colorWithHexString:@"#cccccc"]];
    
    if (self.dataArray.count == 2) {
        if (section == 0) {
            return nil;
        }
        if (section == 1) {
            return viewS;
        }
    }
    if (self.dataArray.count == 1) {
        if (self.arr_guoqi == 0) {
            return nil;
        }
        if (self.arr_weiguoqi == 0) {
            return viewS;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cell";
    
    CouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CouponsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    NSDictionary *dic = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"useable"] intValue] == 1) {
        [cell.img_backGround setImage:[UIImage imageNamed:@"折扣券"]];
        [cell.lab_couponsName setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [cell.lab_expireTimeDesc setTextColor:[UIColor colorWithHexString:@"#666666"]];
        [cell.lab_value setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
        [cell.lab_type setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
    }
    if ([[dic objectForKey:@"useable"] intValue] == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.img_backGround setImage:[UIImage imageNamed:@"不可用优惠券"]];
        [cell.lab_couponsName setTextColor:[UIColor colorWithHexString:@"#CCCCCC"]];
        [cell.lab_expireTimeDesc setTextColor:[UIColor colorWithHexString:@"#CCCCCC"]];
        [cell.lab_value setTextColor:[UIColor colorWithHexString:@"#CCCCCC"]];
        [cell.lab_type setTextColor:[UIColor colorWithHexString:@"#CCCCCC"]];
    }
    [cell.lab_couponsName setText:[dic objectForKey:@"name"]];
    [cell.lab_expireTimeDesc setText:[dic objectForKey:@"expireTimeDesc"]];
    [cell.lab_usageDesc setText:[dic objectForKey:@"usageDesc"]];
    [cell.lab_value setText:[dic objectForKey:@"typeDesc"]];
    [cell.lab_type setText:[dic objectForKey:@"discountDesc"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isFromOrder) {
        if ([[[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"useable"] intValue] == 0) {
            // 过期的不可点
        }else{
            
            NSDictionary *dic = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [self.delegate didSelectedCouponsWithDic:dic];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count == 2) {
        if (section == 0) {
            return 0;
        }
        if (section == 1) {
            return 40;
        }
    }
    if (self.dataArray.count == 1) {
        if (self.arr_guoqi == 0) {
            return 0;
        }
        if (self.arr_weiguoqi == 0) {
            return 40;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 131;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
     [self.view endEditing:YES];
}



@end
