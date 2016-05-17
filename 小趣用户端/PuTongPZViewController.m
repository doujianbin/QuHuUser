//
//  PuTongPZViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/11.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PuTongPZViewController.h"
#import "BaseTableViewCell.h"
#import "SelectFamilyViewController.h"
#import "TwoLevelViewController.h"
#import "PTSureOrderViewController.h"
#import "CouponsTableViewController.h"
#import "SignInViewController.h"
#import "Toast+UIView.h"
#import "TalkingData.h"

@interface PuTongPZViewController ()<UITableViewDataSource,UITableViewDelegate,SelectFamilyViewControllerDelegate,TwoLevelViewControllerDegelate,CouponsTableViewControllerDegelate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>{
    UITableView *tableView1;
    UITableView *tableView2;
}


@property (nonatomic,strong)NSDictionary *hospitalDic;

@property (nonatomic ,retain)UIView *backView;
@property (nonatomic ,retain)UIView *btnView;
@property (nonatomic ,retain)UIPickerView  *picker;
@property (nonatomic ,retain)UIButton *btn_cancel;
@property (nonatomic ,retain)UIButton *btn_sure;
@property (nonatomic ,retain)NSString *str_startTime;// 显示给用户看的lab
@property (nonatomic ,retain)NSString *str_time;     // 传给服务端用的
@property (nonatomic ,retain)AFNManager *manager;
@property (nonatomic ,strong)NSDictionary *dic_coupon;
@property (nonatomic ,strong)NSDictionary *partnerDic;
@property (nonatomic ,strong)UIButton *btn_xiadan;
@property (nonatomic ,strong)UIView *backV;
@property (nonatomic ,strong)UIView *v_backPick;
@property (nonatomic ,strong)UILabel *lab_yugujine;

@property (nonatomic,strong)NSMutableArray  *arr_day;
@property (nonatomic,strong)NSMutableArray  *arr_dataDay;
@property (nonatomic,strong)NSMutableArray  *arr_hour;
@property (nonatomic,strong)NSMutableArray  *arr_min;

@property (nonatomic,assign)int   int_dayIndex;
@property (nonatomic,assign)int   int_hourIndex;
@property (nonatomic,assign)int   int_minIndex;

@property(nonatomic, assign) UIWindow *awindow;

@property (nonatomic ,strong)UIButton *btn_yunfu;
@property (nonatomic ,strong)UIButton *btn_NoYunfu;
@property (nonatomic,assign)int   int_isyunfu;   // 0 为是孕妇  1 为不是孕妇
@property (nonatomic ,strong)NSString *zhifu_orderID; // 引导跳转支付传的订单Id(风控)
@end

@implementation PuTongPZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    self.arr_dataDay = [NSMutableArray array];
    self.arr_day = [NSMutableArray array];
    self.arr_hour = [NSMutableArray array];
    self.arr_min = [NSMutableArray array];
    
    self.title = @"预约陪诊";
    
//    self.navigationController.navigationBar.translucent = NO;
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *bv = [[UIView alloc]init];
    [self.view addSubview:bv];
    
    [self addTableView];
    [self addTimeData];
    // Do any additional setup after loading the view.
    [self addTimeSelect];

    self.int_isyunfu = 1;
}

-(void)addTimeData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,GetSelectiveAccompanyTimeSchedule];
    AFNManager *manager = [[AFNManager alloc]init];
    [manager RequestJsonWithUrl:strUrl method:@"POST" parameter:nil result:^(id responseDic) {
        if ([Status isEqualToString:SUCCESS]) {
            NSArray *arr_all = [[responseDic objectForKey:@"data"] objectForKey:@"timeList"];
            for (NSDictionary *dic in arr_all) {
                [self.arr_day addObject:[dic objectForKey:@"dayDesc"]];
                [self.arr_dataDay addObject:[dic objectForKey:@"day"]];
                [self.arr_hour addObject:[dic objectForKey:@"hourList"]];
                NSDictionary *dic_min = [dic objectForKey:@"minListMap"];
                NSMutableArray *arr_keys = [NSMutableArray arrayWithArray:[dic_min allKeys]];
                NSMutableArray *arr_values = [NSMutableArray arrayWithArray:[dic_min allValues]];
                for (int i = 0; i < arr_keys.count - 1; i++)
                {//走iDataNum-1趟
                    for (int j = 0; j < arr_keys.count - i - 1; j++)
                    {
                        if ([arr_keys[j] integerValue] > [arr_keys[j + 1] integerValue])
                        {
                            NSString *str_one = [arr_keys objectAtIndex:j];
                            NSString *str_two = [arr_keys objectAtIndex:j + 1];
                            NSArray *arr_one = [arr_values objectAtIndex:j];
                            NSArray *arr_two = [arr_values objectAtIndex:j + 1];
                            [arr_keys replaceObjectAtIndex:j withObject:str_two];
                            [arr_keys replaceObjectAtIndex:j + 1 withObject:str_one];
                            [arr_values replaceObjectAtIndex:j withObject:arr_two];
                            [arr_values replaceObjectAtIndex:j + 1 withObject:arr_one];
                        }
                    }
                }
                [self.arr_min addObject:arr_values];
            }
        }
    } fail:^(NSError *error) {
        
    }];
    
}


-(void)addTableView{

    
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 57 * 4 ) style:UITableViewStylePlain];
    [self.view addSubview:tableView1];
    [tableView1 setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    //    tableView1.rowHeight = 57;
    tableView1.scrollEnabled = NO;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView1 registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"tableView1"];
    
    tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tableView1.frame) + 10, SCREEN_WIDTH, 57) style:UITableViewStylePlain];
    [self.view addSubview:tableView2];
    [tableView2 setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    //    tableView2.rowHeight = 57;
    tableView2.scrollEnabled = NO;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView2 registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"tableView2"];
    
    UIView *v_orderMsg = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tableView2.frame) + 10, SCREEN_WIDTH, 84)];
    [self.view addSubview:v_orderMsg];
    [v_orderMsg setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *img_line = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 0.5) / 2, 22, 0.5, 40)];
    [v_orderMsg addSubview:img_line];
    [img_line setBackgroundColor:[UIColor colorWithHexString:@"eaeaea"]];
    
    UILabel *lab_price = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH / 2, 20)];
    [v_orderMsg addSubview:lab_price];
    lab_price.textAlignment = NSTextAlignmentCenter;
    lab_price.font = [UIFont systemFontOfSize:17];
    [lab_price setTextColor:[UIColor colorWithHexString:@"#929292"]];
    [lab_price setText:@"价格"];
    
    UILabel *lab_chaoshi = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 20, SCREEN_WIDTH / 2, 20)];
    [v_orderMsg addSubview:lab_chaoshi];
    lab_chaoshi.textAlignment = NSTextAlignmentCenter;
    lab_chaoshi.font = [UIFont systemFontOfSize:17];
    [lab_chaoshi setTextColor:[UIColor colorWithHexString:@"#929292"]];
    [lab_chaoshi setText:@"超时费"];
    
    UILabel *lab_price1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab_price.frame) + 10, SCREEN_WIDTH / 2, 20)];
    [v_orderMsg addSubview:lab_price1];
    NSString *price = [[LoginStorage GetCommonOrderDic] objectForKey:@"info"];
    [lab_price1 setText:[NSString stringWithFormat:@"%@ 元/4 小时",price]];
    lab_price1.font = [UIFont systemFontOfSize:17];
    [lab_price1 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
    lab_price1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab_chaoshi1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH /2, CGRectGetMaxY(lab_price.frame) + 10, SCREEN_WIDTH / 2, 20)];
    [v_orderMsg addSubview:lab_chaoshi1];
    [lab_chaoshi1 setText:@"25 元 / 半小时"];
    lab_chaoshi1.font = [UIFont systemFontOfSize:17];
    [lab_chaoshi1 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
    lab_chaoshi1.textAlignment = NSTextAlignmentCenter;
    
    UIButton *btn_fuwu = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, CGRectGetMaxY(v_orderMsg.frame) + 10, 55, 20)];
    [self.view addSubview:btn_fuwu];
    [btn_fuwu setTitle:@"服务详情" forState:UIControlStateNormal];
    [btn_fuwu setTitleColor:[UIColor colorWithHexString:@"4a90e2"] forState:UIControlStateNormal];
    btn_fuwu.titleLabel.font = [UIFont systemFontOfSize:13];
    btn_fuwu.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn_fuwu addTarget:self action:@selector(btnxiangqingAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.lab_yugujine = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 79 - 64, SCREEN_WIDTH, 20)];
    [self.view addSubview:self.lab_yugujine];
    self.lab_yugujine.font = [UIFont systemFontOfSize:17];
    NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预估金额：%@ 元",[[LoginStorage GetCommonOrderDic] objectForKey:@"info"]]];
    [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a4a4a"] range:NSMakeRange(0, 5)];
    [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, 5)];
    [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fa6262"] range:NSMakeRange(5, myStr.length - 5)];
    [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(5, myStr.length - 5)];
    [self.lab_yugujine setAttributedText:myStr];
    self.lab_yugujine.textAlignment = NSTextAlignmentCenter;
    
    self.btn_xiadan = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 64, SCREEN_WIDTH, 44)];
    [self.view addSubview:self.btn_xiadan];
    [self.btn_xiadan setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    [self.btn_xiadan setTitle:@"确认下单" forState:UIControlStateNormal];
    self.btn_xiadan.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.btn_xiadan addTarget:self action:@selector(btnxiadanAction) forControlEvents:UIControlEventTouchUpInside];
    
    if ([LoginStorage isFirstMakeOrder] == NO) {
        [self btnxiangqingAction];
        [LoginStorage saveFirstMakeOrder:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tableView1) {
        return 4;
    }
    if (tableView == tableView2) {
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableView1) {
        
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView1"];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lab_left.alpha = 0.6;
        if (indexPath.row == 0) {
            [cell.lab_left setFrame:CGRectMake(15, 0, SCREEN_WIDTH, 57)];
            [cell.lab_right setFrame:CGRectMake(SCREEN_WIDTH - 280, 0, 250, 57)];
            [cell.lab_left setText:@"医院"];
            if (self.str_hospitalName.length > 0) {
                [cell.lab_hospitalName setText:self.str_hospitalName];
                [cell.lab_hospitalAddress setText:self.str_hospitalAddress];
                [cell.lab_right setText:@""];
            }else{
                [cell.lab_right setFrame:CGRectMake(SCREEN_WIDTH - 280, 0, 250, 57)];
                [cell.lab_right setText:@"选择医院"];
                [cell.lab_right setAlpha:0.6];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
            }
            
        }
        if (indexPath.row == 1) {
            [cell.lab_left setText:@"时间"];
            if (self.str_startTime.length > 0) {
                [cell.lab_right setText:self.str_startTime];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
                cell.lab_right.alpha = 1;
            }else{
                [cell.lab_right setFrame:CGRectMake(SCREEN_WIDTH - 280, 0, 250, 57)];
                [cell.lab_right setText:@"选择时间"];
                [cell.lab_right setAlpha:0.6];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
            }
        }
        if (indexPath.row == 2) {
            [cell.lab_left setText:@"就诊人"];
            if (self.entity.userName.length == 0) {
                [cell.lab_right setFrame:CGRectMake(SCREEN_WIDTH - 280, 0, 250, 57)];
                [cell.lab_right setText:@"选择就诊人"];
                [cell.lab_right setAlpha:0.6];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
            }else{
                [cell.lab_right setFrame:CGRectMake(SCREEN_WIDTH - 280, 0, 250, 57)];
                [cell.lab_right setText:self.entity.userName];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
                cell.lab_right.alpha = 1;
            }
        }
        if (indexPath.row == 3) {
            [cell.img_jiantou setHidden:YES];
            [cell.lab_left setText:@"是否孕妇"];
            self.btn_yunfu = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 17, 23, 23)];
            [cell addSubview:self.btn_yunfu];
            [self.btn_yunfu setBackgroundImage:[UIImage imageNamed:@"normarl"] forState:UIControlStateNormal];
            [self.btn_yunfu addTarget:self action:@selector(btn_yunfuAction) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *lab_yes = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.btn_yunfu.frame) + 10, 20, 16, 16)];
            [lab_yes setText:@"是"];
            [lab_yes setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
            [lab_yes setFont:[UIFont systemFontOfSize:16]];
            [cell addSubview:lab_yes];
            
            self.btn_NoYunfu = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 63, 17, 23, 23)];
            [cell addSubview:self.btn_NoYunfu];
            [self.btn_NoYunfu setBackgroundImage:[UIImage imageNamed:@"Oval 70 + Oval 70"] forState:UIControlStateNormal];
            [self.btn_NoYunfu addTarget:self action:@selector(btn_NoYunfuAction) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *lab_no = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.btn_NoYunfu.frame) + 9, 20, 16, 16)];
            [lab_no setText:@"否"];
            [lab_no setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
            [lab_no setFont:[UIFont systemFontOfSize:16]];
            [cell addSubview:lab_no];
            
        }
        return cell;
    }
    if (tableView == tableView2) {
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView2"];

        if (indexPath.row == 0) {
            [cell.lab_left setText:@"优惠券"];
            if ([[[self.dic_coupon objectForKey:@"id"] stringValue] length] > 0) {
                if ([[self.dic_coupon objectForKey:@"type"] intValue] == 1) {
                    CGFloat discount = [[self.dic_coupon objectForKey:@"value"] floatValue] * 10;
                    [cell.lab_right setText:[NSString stringWithFormat:@"%.f折",discount]];
                    [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                    cell.lab_right.alpha = 1.0;
                }
                if ([[self.dic_coupon objectForKey:@"type"] intValue] == 2) {
                    [cell.lab_right setText:[NSString stringWithFormat:@"-%@元",[self.dic_coupon objectForKey:@"value"]]];
                    [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                    cell.lab_right.alpha = 1.0;
                }
                if ([[self.dic_coupon objectForKey:@"type"] intValue] == 3) {
                    [cell.lab_right setText:@"免套餐券"];
                    [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                    cell.lab_right.alpha = 1.0;
                }
            }else{
                [cell.lab_right setText:@"选择优惠券"];
                [cell.lab_right setAlpha:0.6];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
                [cell.lab_right setFrame:CGRectMake(SCREEN_WIDTH - 280, 0, 250, 57)];
                
            }
        }
        //        if (indexPath.row == 3) {
        //
        //            [cell.lab_left setText:@"合计金额"];
        //            cell.lab_left.alpha = 0.8;
        //            cell.lab_right.alpha = 1.0;
        //            if ([[self.dic_coupon objectForKey:@"type"] intValue] == 1) {
        //                CGFloat totalPrice = [[[LoginStorage GetCommonOrderDic] objectForKey:@"info"] floatValue];
        //                CGFloat discount = [[self.dic_coupon objectForKey:@"value"] floatValue];
        //                CGFloat price = totalPrice * discount / 10;
        //                if (price < 0) {
        //                   [cell.lab_right setText:@"¥0.00"];
        //                }else{
        //
        //                    [cell.lab_right setText:[NSString stringWithFormat:@"¥%.2f",price]];
        //                }
        //            }else if ([[self.dic_coupon objectForKey:@"type"] intValue] == 2){
        //                CGFloat totalPrice = [[[LoginStorage GetCommonOrderDic] objectForKey:@"info"] floatValue];
        //                CGFloat discount = [[self.dic_coupon objectForKey:@"value"] floatValue];
        //                CGFloat price = totalPrice - discount;
        //                if (price < 0) {
        //                    [cell.lab_right setText:@"¥0.00"];
        //                }else{
        //
        //                    [cell.lab_right setText:[NSString stringWithFormat:@"¥%.2f",price]];
        //                }
        //            }else{
        //                [cell.lab_right setText:[NSString stringWithFormat:@"¥%@",[[LoginStorage GetCommonOrderDic] objectForKey:@"info"]]];
        //            }
        //            [cell.lab_left setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
        //            [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
        //            [cell.img_jiantou setHidden:YES];
        //        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == tableView1) {
        if (indexPath.row == 0) {
            TwoLevelViewController *vc = [[TwoLevelViewController alloc]init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            [self selectTime];
        }
        if (indexPath.row == 2) {
            if ([LoginStorage isLogin] == YES) {
                
                SelectFamilyViewController *seletView = [[SelectFamilyViewController alloc]init];
                seletView.delegate = self;
                [self.navigationController pushViewController:seletView animated:YES];
            }else{
                SignInViewController *sign = [[SignInViewController alloc]init];
                [self.navigationController pushViewController:sign animated:YES];
            }
        }
    }
    if (tableView == tableView2) {
        if (indexPath.row == 0) {
            if ([LoginStorage isLogin] == YES) {
                CouponsTableViewController *vc_cou = [[CouponsTableViewController alloc]init];
                vc_cou.isFromOrder = YES;
                vc_cou.delegate =self;
                vc_cou.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc_cou animated:YES];
            }else{
                SignInViewController *sign = [[SignInViewController alloc]init];
                [self.navigationController pushViewController:sign animated:YES];
            }
        }
    }
}

- (void)selectTime{
    [self.backView setFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    [UIView animateWithDuration:0.6 animations:^{
        [self.v_backPick setFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    }];
    [self.view.window addSubview:self.backView];
    [self.view.window addSubview:self.v_backPick];
}

-(void)addTimeSelect{
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.backView setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.5]];
    
    self.v_backPick = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.v_backPick setBackgroundColor:[UIColor clearColor]];
    
    self.btnView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 258.5, SCREEN_WIDTH, 44)];
    [self.v_backPick addSubview:self.btnView];
    [self.btnView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *img_xian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
    [self.btnView addSubview:img_xian];
    [img_xian setBackgroundColor:[UIColor colorWithHexString:@"#cdcdcd"]];
    
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 214.5, SCREEN_WIDTH, 214.5)];
    self.picker.backgroundColor = [UIColor whiteColor];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    [self.v_backPick addSubview:self.picker];
    
    self.btn_cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 43.5)];
    [self.btnView addSubview:self.btn_cancel];
    [self.btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.btn_cancel setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
    self.btn_cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.btn_cancel addTarget:self action:@selector(btn_cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn_sure = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 0, 70, 43.5)];
    [self.btnView addSubview:self.btn_sure];
    [self.btn_sure setTitle:@"确定" forState:UIControlStateNormal];
    [self.btn_sure setTitleColor:[UIColor colorWithHexString:@"#FA6262"] forState:UIControlStateNormal];
    self.btn_sure.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.btn_sure addTarget:self action:@selector(btn_sureAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.arr_day.count;
            break;
        case 1:
            return [[self.arr_hour objectAtIndex:self.int_dayIndex] count];
            break;
        case 2:
            return [[[self.arr_min objectAtIndex:self.int_dayIndex] objectAtIndex:self.int_hourIndex] count];
            break;
        default:
            break;
    }
    return 0;
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    switch (component) {
//        case 0:
//            return SCREEN_WIDTH/2;
//            break;
//        case 1:
//            return SCREEN_WIDTH/4;
//            break;
//        case 2:
//            return SCREEN_WIDTH/4;
//            break;
//        default:
//            break;
//    }
//    return 0;
//}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return SCREEN_WIDTH/2 + 10;
            break;
        case 1:
            return SCREEN_WIDTH/4 - 15;
            break;
        case 2:
            return SCREEN_WIDTH/4 - 30;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [self.arr_day objectAtIndex:row];
            break;
        case 1:
            return [[self.arr_hour objectAtIndex:self.int_dayIndex] objectAtIndex:row];
            break;
        case 2:
            return [[[self.arr_min objectAtIndex:self.int_dayIndex] objectAtIndex:self.int_hourIndex] objectAtIndex:row];
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)componen
{
    switch (componen) {
        case 0:
            self.int_dayIndex = (int)row;
            if (self.int_hourIndex >= [[self.arr_hour objectAtIndex:self.int_dayIndex]  count]) {
                self.int_hourIndex = (int)[[self.arr_hour objectAtIndex:self.int_dayIndex]  count] - 1;
            }
            if (self.int_minIndex >= [[[self.arr_min objectAtIndex:self.int_dayIndex]  objectAtIndex:self.int_hourIndex] count]) {
                self.int_minIndex = (int)[[[self.arr_min objectAtIndex:self.int_dayIndex]  objectAtIndex:self.int_hourIndex] count] - 1;
            }
            [self.picker reloadComponent:1];
            [self.picker reloadComponent:2];
            break;
        case 1:
            self.int_hourIndex = (int)row;
            if (self.int_minIndex >= [[[self.arr_min objectAtIndex:self.int_dayIndex]  objectAtIndex:self.int_hourIndex] count]) {
                self.int_minIndex = (int)[[[self.arr_min objectAtIndex:self.int_dayIndex]  objectAtIndex:self.int_hourIndex] count] - 1;
            }
            [self.picker reloadComponent:2];
            break;
        case 2:
            self.int_minIndex = (int)row;
            break;
        default:
            break;
    }
    
}

-(void)btn_cancelAction:(UIButton *)sender{
    [self.backView setFrame:CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT)];
    [UIView animateWithDuration:0.6 animations:^{
        [self.v_backPick setFrame:CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT)];
    }];
}

-(void)btn_sureAction:(UIButton *)sender{
    
    self.str_startTime = [NSString stringWithFormat:@"%@ %@:%@",[self.arr_day objectAtIndex:self.int_dayIndex],[[self.arr_hour objectAtIndex:self.int_dayIndex] objectAtIndex:self.int_hourIndex],[[[self.arr_min objectAtIndex:self.int_dayIndex] objectAtIndex:self.int_hourIndex] objectAtIndex:self.int_minIndex]];
    self.str_time = [NSString stringWithFormat:@"%@ %@:%@",[self.arr_dataDay objectAtIndex:self.int_dayIndex],[[self.arr_hour objectAtIndex:self.int_dayIndex] objectAtIndex:self.int_hourIndex],[[[self.arr_min objectAtIndex:self.int_dayIndex] objectAtIndex:self.int_hourIndex] objectAtIndex:self.int_minIndex]];
    [self.backView setFrame:CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT)];
    [UIView animateWithDuration:0.6 animations:^{
        [self.v_backPick setFrame:CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT)];
    }];
    [tableView1 reloadData];
}

- (void)didSelectedMemberWithEntity:(MemberEntity *)memberEntity{
    self.entity = memberEntity;
    [tableView1 reloadData];
}

- (void)didSelectedHospitalWithEntity:(NSDictionary *)hospitalDic{
    self.hospitalDic = hospitalDic;
    self.str_hospitalName = [hospitalDic objectForKey:@"hospitalName"];
    self.str_hospitalAddress = [hospitalDic objectForKey:@"address"];
    self.str_hospitalId = [hospitalDic objectForKey:@"hospitalId"];
    [tableView1 reloadData];
}

- (void)didSelectedCouponsWithDic:(NSDictionary *)couponsDic{
    self.dic_coupon = couponsDic;
    [tableView2 reloadData];
    
    if ([[self.dic_coupon objectForKey:@"type"] intValue] == 1) {
        CGFloat totalPrice = [[[LoginStorage GetCommonOrderDic] objectForKey:@"info"] floatValue];
        CGFloat discount = [[self.dic_coupon objectForKey:@"value"] floatValue];
        CGFloat price = totalPrice * discount;
        if (price < 0) {
            NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc] initWithString:@"预估金额：0 元"];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a4a4a"] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fa6262"] range:NSMakeRange(5, 3)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(5, 3)];
            [self.lab_yugujine setAttributedText:myStr];
            self.lab_yugujine.textAlignment = NSTextAlignmentCenter;
//            [self.lab_yugujine setText:@"¥0.00"];
        }else{
            NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预估金额：%.f 元",price]];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a4a4a"] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fa6262"] range:NSMakeRange(5, myStr.length - 5)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(5, myStr.length - 5)];
            [self.lab_yugujine setAttributedText:myStr];
            self.lab_yugujine.textAlignment = NSTextAlignmentCenter;
//            [self.lab_yugujine setText:[NSString stringWithFormat:@"¥%.2f",price]];
        }
    }if ([[self.dic_coupon objectForKey:@"type"] intValue] == 2){
        CGFloat totalPrice = [[[LoginStorage GetCommonOrderDic] objectForKey:@"info"] floatValue];
        CGFloat discount = [[self.dic_coupon objectForKey:@"value"] floatValue];
        CGFloat price = totalPrice - discount;
        if (price < 0) {
            NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc] initWithString:@"预估金额：0 元"];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a4a4a"] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fa6262"] range:NSMakeRange(5, 3)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(5, 3)];
            [self.lab_yugujine setAttributedText:myStr];
            self.lab_yugujine.textAlignment = NSTextAlignmentCenter;
        }else{
            
            NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预估金额：%.f 元",price]];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a4a4a"] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fa6262"] range:NSMakeRange(5, myStr.length - 5)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(5, myStr.length - 5)];
            [self.lab_yugujine setAttributedText:myStr];
            self.lab_yugujine.textAlignment = NSTextAlignmentCenter;
        }
    }if ([[self.dic_coupon objectForKey:@"type"] intValue] == 3){
        NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc] initWithString:@"预估金额：0 元"];
        [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a4a4a"] range:NSMakeRange(0, 5)];
        [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, 5)];
        [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fa6262"] range:NSMakeRange(5, 3)];
        [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(5, 3)];
        [self.lab_yugujine setAttributedText:myStr];
        self.lab_yugujine.textAlignment = NSTextAlignmentCenter;
    }
}

-(void)btn_yunfuAction{
    self.int_isyunfu = 0;
    [self.btn_yunfu setBackgroundImage:[UIImage imageNamed:@"Oval 70 + Oval 70"] forState:UIControlStateNormal];
    [self.btn_NoYunfu setBackgroundImage:[UIImage imageNamed:@"normarl"] forState:UIControlStateNormal];
}

-(void)btn_NoYunfuAction{
    self.int_isyunfu = 1;
    [self.btn_NoYunfu setBackgroundImage:[UIImage imageNamed:@"Oval 70 + Oval 70"] forState:UIControlStateNormal];
    [self.btn_yunfu setBackgroundImage:[UIImage imageNamed:@"normarl"] forState:UIControlStateNormal];
}

-(void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnxiadanAction{
    if (self.str_hospitalId == nil) {
        [self.view makeToast:@"请选择医院" duration:1.0 position:@"center"];
    }else if (self.str_time == nil || [self.str_time isEqualToString:@""]){
        [self selectTime];
        
    }else if (self.entity.userId == nil){
        [self.view makeToast:@"请选择就诊人" duration:1.0 position:@"center"];
    }else{
        [TalkingData trackEvent:@"用户点击下单按钮"];
        [self UploadCommonOrder];
    }
    //    PTSureOrderViewController *vc = [[PTSureOrderViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)UploadCommonOrder{
    self.manager = [[AFNManager alloc]init];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,CreateCommonOrder];
    NSString *strSetId;
    if (self.int_isyunfu == 0) {
        strSetId = @"23";
    }else{
        strSetId = @"21";
    }
//    NSString *strSetId = [[LoginStorage GetCommonOrderDic] objectForKey:@"id"];
    
    if ([[[self.dic_coupon objectForKey:@"id"] stringValue] length] > 0) {
        NSString *couponId = [NSString stringWithFormat:@"%@",[self.dic_coupon objectForKey:@"id"]];
        self.partnerDic = @{@"setId":strSetId,@"hospitalId":self.str_hospitalId,@"patientId":self.entity.userId,@"scheduleTime":self.str_time,@"couponId":couponId};
    }else{
        
        self.partnerDic = @{@"setId":strSetId,@"hospitalId":self.str_hospitalId,@"patientId":self.entity.userId,@"scheduleTime":self.str_time};
    }
    self.btn_xiadan.enabled = NO;
    BeginActivity;
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:self.partnerDic result:^(id responseDic) {
        NSLog(@"下单(普通)返回:%@",responseDic);
        EndActivity;
        self.btn_xiadan.enabled = YES;
        if ([Status isEqualToString:SUCCESS]) {
            
            PTSureOrderViewController *orderView = [[PTSureOrderViewController alloc]init];
            orderView.str_OrderId = [[responseDic objectForKey:@"data"] objectForKey:@"orderId"];
            orderView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderView animated:YES];
        }else{
            self.zhifu_orderID = [responseDic objectForKey:@"data"];
            if (![[responseDic objectForKey:@"errorCode"] isKindOfClass:[NSNull class]] && [[responseDic objectForKey:@"errorCode"] isEqualToString:@"A301"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:Message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"支付", nil];
                alert.tag = 101;
                alert.delegate = self;
                [alert show];
            }else{
                
                [self.view makeToast:Message duration:1.0 position:@"center"];
            }
        }
    } fail:^(NSError *error) {
        EndActivity;
        self.btn_xiadan.enabled = YES;
        NetError;
    }];
}

-(void)btnxiangqingAction{
    self.backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backV];
    [self.backV setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.5]];
    
    UIImageView *img_fuwu = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.133, SCREEN_HEIGHT * 0.17, SCREEN_WIDTH * 0.734, SCREEN_HEIGHT * 0.562)];
    [self.backV addSubview:img_fuwu];
    [img_fuwu setImage:[UIImage imageNamed:@"组-7"]];
    img_fuwu.layer.cornerRadius = 4.0f;
    img_fuwu.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [self.backV addGestureRecognizer:tgr];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            PTSureOrderViewController *vc = [[PTSureOrderViewController alloc]init];
            vc.str_OrderId = self.zhifu_orderID;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)removeView{
    [self.backV removeFromSuperview];
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
