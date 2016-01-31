//
//  PTSureOrderViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/12.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PTSureOrderViewController.h"
#import "BaseTableViewCell.h"
#import "CommonOrderEntity.h"
#import "HospitalAddressTableViewCell.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "WXApi.h"
#import "SelectDoctorViewController.h"

@interface PTSureOrderViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableView1;
    UITableView *tableView2;
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    UIScrollView *scl_back;
}

@property (nonatomic ,strong)AFNManager *manager;
@property (nonatomic ,strong)CommonOrderEntity *commonOrderEntity;
@end

@implementation PTSureOrderViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        arr1 = [[NSMutableArray alloc]initWithObjects:@"订单号",@"下单时间",@"地址",@"时间",@"成员", nil];
        arr2 = [[NSMutableArray alloc]initWithObjects:@"服务",@"价格",@"优惠券",@"合计金额", nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.title = @"确认订单";
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    scl_back = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 54)];
    [self.view addSubview:scl_back];
    // Do any additional setup after loading the view.
//    [self addtableView];
    [self loadData];
}

-(void)loadData{
    NSString *strUrl = [NSString stringWithFormat:@"%@/quhu/accompany/user/queryOrderDetails?id=%@",Development,self.str_OrderId];
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:nil result:^(id responseDic) {
        NSLog(@"订单详情:%@",responseDic);
        if ([Status isEqualToString:SUCCESS]) {
            self.commonOrderEntity = [CommonOrderEntity parseCommonOrderListEntityWithJson:[responseDic objectForKey:@"data"]];
            [self addtableView];
        }
    } fail:^(NSError *error) {
        NSLog(@"error == %@",error);
    }];

}

-(void)addtableView{
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10.5, SCREEN_WIDTH, 0.5)];
    [scl_back addSubview:img1];
    [img1 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 296 + 64) style:UITableViewStylePlain];
    [scl_back addSubview:tableView1];
    [tableView1 setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.scrollEnabled = NO;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 296 + 11 + 10.5, SCREEN_WIDTH, 0.5)];
    [scl_back addSubview:img2];
    [img2 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 296 + 11 + 11, SCREEN_WIDTH, 57 * 4) style:UITableViewStylePlain];
    [scl_back addSubview:tableView2];
    [tableView2 setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.scrollEnabled = NO;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.commonOrderEntity.orderType == 0) {
        [self addCommonOrderDownView];
    }else{
        [self addSpecialOrderDownView];
        
    }
    
    [tableView1 reloadData];
    [tableView2 reloadData];

}

-(void)addCommonOrderDownView{
    
    UILabel *lab_remark = [[UILabel alloc]initWithFrame:CGRectMake(15, 557, 300, 12.5)];
    [scl_back addSubview:lab_remark];
    [lab_remark setText:@"备注：陪诊超时按照小时收费（￥25/小时）"];
    [lab_remark setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
    lab_remark.font = [UIFont systemFontOfSize:12];
    [scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, 640 - 54)];
    
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 54, SCREEN_WIDTH, 54)];
    [self.view addSubview:upView];
    [upView setBackgroundColor:[UIColor whiteColor]];
   
    if (self.commonOrderEntity.orderStatus == 0 || self.commonOrderEntity.orderStatus == 3) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(14.5, 17, 20, 20)];
        [upView addSubview:img];
        [img setImage:[UIImage imageNamed:@"Oval 91 + Path 52"]];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(42, 16.5, 120, 21)];
        [upView addSubview:lab];
        if (self.commonOrderEntity.orderStatus == 0) {
            
            [lab setText:@"等待护士接单"];
        }
        if (self.commonOrderEntity.orderStatus == 3) {
            [lab setText:@"等待支付"];
        }
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [UIColor colorWithHexString:@"#FA6262"];
        
        UIButton *btn_commonOrderzhifu = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 54)];
        [upView addSubview:btn_commonOrderzhifu];
        [btn_commonOrderzhifu setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
        if (self.commonOrderEntity.orderStatus == 0) {
            
            [btn_commonOrderzhifu setTitle:@"取消订单" forState:UIControlStateNormal];
        }
        if (self.commonOrderEntity.orderStatus == 3) {
            [btn_commonOrderzhifu setTitle:@"支付" forState:UIControlStateNormal];
        }
        btn_commonOrderzhifu.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn_commonOrderzhifu addTarget:self action:@selector(btnCommonOrderZhiFu:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.commonOrderEntity.orderStatus == 1 || self.commonOrderEntity.orderStatus == 2) {
        // 护士已经接单   ｜｜    陪诊中
        UIImageView *img_NurseHeadPic = [[UIImageView alloc]initWithFrame:CGRectMake(15.5, 7, 40, 40)];
        [upView addSubview:img_NurseHeadPic];
        if ([[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"] isKindOfClass:[NSNull class]]) {
            [img_NurseHeadPic setImage:[UIImage imageNamed:@"ic_个人中心"]];
        }else{
            NSURL *url_NurseHeadPic = [NSURL URLWithString:[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"]];
            [img_NurseHeadPic sd_setImageWithURL:url_NurseHeadPic placeholderImage:[UIImage imageNamed:@"ic_个人中心"]];
        }
        UILabel *lab_nurseName = [[UILabel alloc]initWithFrame:CGRectMake(70.5, 8.5, 70, 21)];
        [upView addSubview:lab_nurseName];
        lab_nurseName.font = [UIFont systemFontOfSize:15];
        [lab_nurseName setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [lab_nurseName setText:[self.commonOrderEntity.nurse objectForKey:@"nurseName"]];
        UILabel *lab_orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(70.5, 31, 80, 14)];
        [upView addSubview:lab_orderStatus];
        lab_orderStatus.font = [UIFont systemFontOfSize:10];
        lab_orderStatus.textColor = [UIColor colorWithHexString:@"#FA6262"];
        
        UIButton *btn_commonOrderCallNurse = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 54)];
        [upView addSubview:btn_commonOrderCallNurse];
        [btn_commonOrderCallNurse setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
        btn_commonOrderCallNurse.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn_commonOrderCallNurse setTitle:@"联系护士" forState:UIControlStateNormal];
        [btn_commonOrderCallNurse addTarget:self action:@selector(btn_commonOrderCallNurseAction) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.commonOrderEntity.orderStatus == 1) {
            [lab_orderStatus setText:@"护士已接单"];
            UIButton *btn_quxiao = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 0, 100, 54)];
            [upView addSubview:btn_quxiao];
            [btn_quxiao setBackgroundColor:[UIColor colorWithHexString:@"#E3E3E6"]];
            btn_quxiao.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn_quxiao setTitle:@"取消订单" forState:UIControlStateNormal];
            [btn_quxiao setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
            [btn_quxiao addTarget:self action:@selector(btnCommonOrderZhiFu:) forControlEvents:UIControlEventTouchUpInside];

        }else{
            [lab_orderStatus setText:@"陪诊中"];
        }
    }
    
}

-(void)addSpecialOrderDownView{
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 54, SCREEN_WIDTH, 54)];
    [self.view addSubview:upView];
    [upView setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    
    UIButton *btn_right = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 54)];
    [upView addSubview:btn_right];
    [btn_right setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    btn_right.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_right addTarget:self action:@selector(btn_rightAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn_left = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 0, 100, 54)];
    [upView addSubview:btn_left];
    [btn_left setBackgroundColor:[UIColor colorWithHexString:@"#E3E3E6"]];
    btn_left.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_left setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
    [btn_left addTarget:self action:@selector(btn_leftAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.commonOrderEntity.orderStatus == 0) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(14.5, 17, 20, 20)];
        [upView addSubview:img];
        [img setImage:[UIImage imageNamed:@"Oval 91 + Path 52"]];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(42, 16.5, 120, 21)];
        [upView addSubview:lab];
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [UIColor colorWithHexString:@"#FA6262"];
        
        if (self.commonOrderEntity.payStatus == 0) {
            [lab setText:@"等待支付"];
            [btn_left setTitle:@"取消订单" forState:UIControlStateNormal];
            [btn_right setTitle:@"支付" forState:UIControlStateNormal];
        }
        if (self.commonOrderEntity.payStatus == 1) {
            [lab setText:@"等待护士接单"];
            [btn_left setHidden:YES];
            [btn_right setTitle:@"取消订单" forState:UIControlStateNormal];
        }
    }
    if (self.commonOrderEntity.orderStatus == 1) {
        
        UIImageView *img_NurseHeadPic = [[UIImageView alloc]initWithFrame:CGRectMake(15.5, 7, 40, 40)];
        [upView addSubview:img_NurseHeadPic];
        if ([[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"] isKindOfClass:[NSNull class]]) {
            [img_NurseHeadPic setImage:[UIImage imageNamed:@"ic_个人中心"]];
        }else{
            NSURL *url_NurseHeadPic = [NSURL URLWithString:[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"]];
            [img_NurseHeadPic sd_setImageWithURL:url_NurseHeadPic placeholderImage:[UIImage imageNamed:@"ic_个人中心"]];
        }
        UILabel *lab_nurseName = [[UILabel alloc]initWithFrame:CGRectMake(70.5, 8.5, 70, 21)];
        [upView addSubview:lab_nurseName];
        lab_nurseName.font = [UIFont systemFontOfSize:15];
        [lab_nurseName setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [lab_nurseName setText:[self.commonOrderEntity.nurse objectForKey:@"nurseName"]];
        UILabel *lab_orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(70.5, 31, 80, 14)];
        [upView addSubview:lab_orderStatus];
        lab_orderStatus.font = [UIFont systemFontOfSize:10];
        lab_orderStatus.textColor = [UIColor colorWithHexString:@"#FA6262"];
        [lab_orderStatus setText:@"护士已接单"];
        [btn_left setTitle:@"取消订单" forState:UIControlStateNormal];
        [btn_right setTitle:@"联系护士" forState:UIControlStateNormal];
    }
    if (self.commonOrderEntity.orderStatus == 2) {
        UIImageView *img_NurseHeadPic = [[UIImageView alloc]initWithFrame:CGRectMake(15.5, 7, 40, 40)];
        [upView addSubview:img_NurseHeadPic];
        if ([[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"] isKindOfClass:[NSNull class]]) {
            [img_NurseHeadPic setImage:[UIImage imageNamed:@"ic_个人中心"]];
        }else{
            NSURL *url_NurseHeadPic = [NSURL URLWithString:[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"]];
            [img_NurseHeadPic sd_setImageWithURL:url_NurseHeadPic placeholderImage:[UIImage imageNamed:@"ic_个人中心"]];
        }
        UILabel *lab_nurseName = [[UILabel alloc]initWithFrame:CGRectMake(70.5, 8.5, 70, 21)];
        [upView addSubview:lab_nurseName];
        lab_nurseName.font = [UIFont systemFontOfSize:15];
        [lab_nurseName setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [lab_nurseName setText:[self.commonOrderEntity.nurse objectForKey:@"nurseName"]];
        UILabel *lab_orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(70.5, 31, 80, 14)];
        [upView addSubview:lab_orderStatus];
        lab_orderStatus.font = [UIFont systemFontOfSize:10];
        lab_orderStatus.textColor = [UIColor colorWithHexString:@"#FA6262"];
        [lab_orderStatus setText:@"陪诊中"];
        
        [btn_left setHidden:YES];
        [btn_right setTitle:@"联系护士" forState:UIControlStateNormal];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableView1) {
        if (indexPath.row == 2) {
            return 70;
        }else{
            return 57;
        }
    }
    if (tableView == tableView2) {
        return 57;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tableView1) {
        return 5;
    }
    if (tableView == tableView2) {
        return 4;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableView1) {
        if (indexPath.row == 2) {
            static NSString *CellIdentifier = @"AddressCell";
            HospitalAddressTableViewCell *cell = (HospitalAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell){
                cell = [[HospitalAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.lab_left.text = [arr1 objectAtIndex:indexPath.row];
            
            cell.lab_hospital.text = [self.commonOrderEntity.hospital objectForKey:@"hospitalName"];
            cell.lab_addressDetail.text = [self.commonOrderEntity.hospital objectForKey:@"address"];
            return cell;
        }else{
            static NSString *CellIdentifier = @"tableViewUpCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell){
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.img_jiantou setHidden:YES];
            [cell.lab_left setText:[arr1 objectAtIndex:indexPath.row]];
            switch (indexPath.row) {
                case 0:
                    [cell.lab_right setText:self.commonOrderEntity.orderNo];
                    break;
                case 1:
                    [cell.lab_right setText:self.commonOrderEntity.createTime];
                    break;
                case 3:
                    [cell.lab_right setText:self.commonOrderEntity.scheduleTime];
                    break;
                case 4:
                    [cell.lab_right setText:[self.commonOrderEntity.patient objectForKey:@"patientName"]];
                    break;
                default:
                    break;
            }
            return cell;
        }
    }
    if (tableView == tableView2) {
        static NSString *CellIdentifier = @"tableViewDownCell";
        BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell){
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.img_jiantou setHidden:YES];
        [cell.lab_left setText:[arr2 objectAtIndex:indexPath.row]];
        switch (indexPath.row) {
            case 0:
                if (self.commonOrderEntity.orderType == 0) {
                    [cell.lab_right setText:@"普通陪诊"];
                }else{
                    [cell.lab_right setText:@"特需陪诊"];
                }
                [cell.lab_left setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A90E2"]];
                break;
            case 1:
                [cell.lab_left setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
                [cell.lab_right setText:[NSString stringWithFormat:@"￥%@/4小时",self.commonOrderEntity.setAmount]];
                break;
            case 2:
                if (self.commonOrderEntity.couponType == 1) {
                    [cell.lab_right setText:[NSString stringWithFormat:@"%.f折",self.commonOrderEntity.couponValue]];
                }else if (self.commonOrderEntity.couponType == 2){
                    [cell.lab_right setText:[NSString stringWithFormat:@"-￥%d",(int)self.commonOrderEntity.couponValue]];
                }else{
                    [cell.lab_right setText:@"暂未使用优惠券"];
                }
                [cell.lab_left setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                break;
            case 3:
                [cell.lab_left setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                [cell.lab_right setText:[NSString stringWithFormat:@"￥%@",self.commonOrderEntity.totalAmount]];
                break;
            default:
                break;
        }

        return cell;
    }
    return nil;
}

-(void)btnCommonOrderZhiFu:(UIButton *)sender{

    if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        [self cancalOrder];
    }
    if ([sender.titleLabel.text isEqualToString:@"支付"]) {
        [self weixinPay];
    }
}

-(void)btn_commonOrderCallNurseAction{
    NSString *str1 = @"tel://";
    NSString *str2 = [self.commonOrderEntity.nurse objectForKey:@"nursePhone"];
    NSString *stt = [NSString stringWithFormat:@"%@%@",str1,str2];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stt]];
}


-(void)btn_leftAction{
    [self cancalOrder];
}

-(void)btn_rightAction:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        [self cancalOrder];
    }
    if ([sender.titleLabel.text isEqualToString:@"支付"]) {
        // 支付
        [self weixinPay];
    }
    if ([sender.titleLabel.text isEqualToString:@"联系护士"]) {
        NSString *str1 = @"tel://";
        NSString *str2 = [self.commonOrderEntity.nurse objectForKey:@"nursePhone"];
        NSString *stt = [NSString stringWithFormat:@"%@%@",str1,str2];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stt]];
    }
}

-(void)cancalOrder{
    NSString *strUrl = [NSString stringWithFormat:@"%@/quhu/accompany/user/order/cancelOrder?orderId=%@",Development,self.str_OrderId];
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"GET" parameter:nil result:^(id responseDic) {
        NSLog(@"取消订单结果 :%@",responseDic);
        if ([Status isEqualToString:SUCCESS]) {
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:Message];
        }
        [NSTimer scheduledTimerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(NavLeftAction)
                                       userInfo:nil
                                        repeats:NO];
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
    }];
}

-(void)weixinPay{
    [SVProgressHUD showWithStatus:@"下单中"];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,CreateWeiXinPay];
    NSString *DeviceIp = [self deviceIPAdress];
    NSDictionary *dic = @{@"appid":@"wxca05a9ac9c6686df",@"mch_id":@"1308372701",@"body":@"商品描述",@"out_trade_no":self.commonOrderEntity.orderNo,@"spbill_create_ip":DeviceIp,@"trade_type":@"APP",@"pay_type":@"0",@"notify_url":@"www.haohushi.me"};
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        NSLog(@"微信预付订单生成结果:%@",responseDic);
        [SVProgressHUD dismiss];
        if ([Status isEqualToString:SUCCESS]) {

            PayReq *request = [[PayReq alloc] init];
            
            request.partnerId = [[responseDic objectForKey:@"data"] objectForKey:@"partnerid"];
            request.nonceStr = [[responseDic objectForKey:@"data"] objectForKey:@"noncestr"];
            request.package = [[responseDic objectForKey:@"data"] objectForKey:@"package"];
            request.sign = [[responseDic objectForKey:@"data"] objectForKey:@"sign"];
            request.prepayId = [[responseDic objectForKey:@"data"] objectForKey:@"prepayid"];
            request.timeStamp = [[[responseDic objectForKey:@"data"] objectForKey:@"timestamp"] intValue];
            
            [WXApi sendReq:request];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"error == %@",error);
    }];
}

-(void)NavLeftAction{
    if (self.orderFromType == 2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);  
    
    return address;  
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
