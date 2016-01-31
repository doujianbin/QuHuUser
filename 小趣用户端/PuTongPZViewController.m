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
#import "MemberEntity.h"
#import "CouponsTableViewController.h"

@interface PuTongPZViewController ()<UITableViewDataSource,UITableViewDelegate,SelectFamilyViewControllerDelegate,TwoLevelViewControllerDegelate,CouponsTableViewControllerDegelate>{
    UITableView *tableView1;
    UITableView *tableView2;
}

@property (nonatomic,strong)MemberEntity *entity;
@property (nonatomic,strong)NSDictionary *hospitalDic;

@property (nonatomic ,retain)UIView *backView;
@property (nonatomic ,retain)UIView *btnView;
@property (nonatomic ,retain)UIDatePicker *dapicker;
@property (nonatomic ,retain)UIButton *btn_cancel;
@property (nonatomic ,retain)UIButton *btn_sure;
@property (nonatomic ,retain)NSString *str_startTime;// 显示给用户看的lab
@property (nonatomic ,retain)NSString *str_time;     // 传给服务端用的
@property (nonatomic ,retain)AFNManager *manager;
@property (nonatomic ,strong)NSDictionary *dic_coupon;
@property (nonatomic ,strong)NSDictionary *partnerDic;

@end

@implementation PuTongPZViewController

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
    
    // Do any additional setup after loading the view.
    [self addTableView];
    
}


-(void)addTableView{
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10.5 + 64, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:img1];
    [img1 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 11 + 64, SCREEN_WIDTH, 57 * 3 + 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView1];
    [tableView1 setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    tableView1.delegate = self;
    tableView1.dataSource = self;
//    tableView1.rowHeight = 57;
    tableView1.scrollEnabled = NO;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView1 registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"tableView1"];
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 21.5 + 57 * 3 + 64 + 11, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:img2];
    [img2 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 22 + 57 * 3 + 64, SCREEN_WIDTH, 57 * 4 + 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView2];
    [tableView2 setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    tableView2.delegate = self;
    tableView2.dataSource = self;
//    tableView2.rowHeight = 57;
    tableView2.scrollEnabled = NO;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView2 registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"tableView2"];
    
    UILabel *lab_remark = [[UILabel alloc]initWithFrame:CGRectMake(15, 486, SCREEN_WIDTH - 30, 60)];
    [self.view addSubview:lab_remark];
    [lab_remark setText:@"备注：超时费用为￥25/半小时。"];
    [lab_remark setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
    lab_remark.font = [UIFont systemFontOfSize:12];
    lab_remark.numberOfLines = 0;
    
    UIButton *btn_xiadan = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    [self.view addSubview:btn_xiadan];
    [btn_xiadan setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    [btn_xiadan setTitle:@"确认下单" forState:UIControlStateNormal];
    btn_xiadan.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn_xiadan addTarget:self action:@selector(btnxiadanAction) forControlEvents:UIControlEventTouchUpInside];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tableView1) {
        return 3;
    }
    if (tableView == tableView2) {
        return 4;
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
            [cell.lab_left setText:@"地址"];
            if (self.str_hospitalName.length > 0) {
                [cell.lab_hospitalName setText:self.str_hospitalName];
                [cell.lab_hospitalAddress setText:self.str_hospitalAddress];
                [cell.lab_right setText:@""];
            }else{
                [cell.lab_right setFrame:CGRectMake(SCREEN_WIDTH - 280, 0, 250, 57)];
                [cell.lab_right setText:@"选择咨询地址"];
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
                [cell.lab_right setText:@"选择陪诊时间"];
                [cell.lab_right setAlpha:0.6];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
            }
        }
        if (indexPath.row == 2) {
            [cell.lab_left setText:@"成员"];
            if (self.entity.name.length == 0) {
                [cell.lab_right setFrame:CGRectMake(SCREEN_WIDTH - 280, 0, 250, 57)];
                [cell.lab_right setText:@"选择成员"];
                [cell.lab_right setAlpha:0.6];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
            }else{
                [cell.lab_right setText:self.entity.name];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
                cell.lab_right.alpha = 1;
            }
        }
        return cell;
    }
    if (tableView == tableView2) {
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView2"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell.lab_left setText:@"服务"];
            [cell.lab_right setText:@"普通陪诊"];
            [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A90E2"]];
            [cell.img_jiantou setHidden:YES];
            cell.lab_right.alpha = 1.0;
        }
        if (indexPath.row == 1) {
            [cell.lab_left setText:@"价格"];
            NSString *price = [[LoginStorage GetCommonOrderDic] objectForKey:@"info"];
            [cell.lab_right setText:[NSString stringWithFormat:@"¥%@/4小时",price]];
            [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
            [cell.img_jiantou setHidden:YES];
            cell.lab_right.alpha = 1.0;
        }
        if (indexPath.row == 2) {
            [cell.lab_left setText:@"优惠券"];
            if ([[[self.dic_coupon objectForKey:@"id"] stringValue] length] > 0) {
                if ([[self.dic_coupon objectForKey:@"type"] intValue] == 1) {
                    CGFloat discount = [[self.dic_coupon objectForKey:@"value"] floatValue];
                    [cell.lab_right setText:[NSString stringWithFormat:@"%.f折",discount]];
                    [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                    cell.lab_right.alpha = 1.0;
                }
                if ([[self.dic_coupon objectForKey:@"type"] intValue] == 2) {
                    [cell.lab_right setText:[NSString stringWithFormat:@"-¥%@",[self.dic_coupon objectForKey:@"value"]]];
                    [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                    cell.lab_right.alpha = 1.0;
                }
            }else{
                [cell.lab_right setText:@"选择使用优惠券"];
                [cell.lab_right setAlpha:0.6];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
                [cell.lab_right setFrame:CGRectMake(SCREEN_WIDTH - 280, 0, 250, 57)];
                
            }
        }
        if (indexPath.row == 3) {
            
            [cell.lab_left setText:@"合计金额:"];
            cell.lab_left.alpha = 0.8;
            cell.lab_right.alpha = 1.0;
            if ([[self.dic_coupon objectForKey:@"type"] intValue] == 1) {
                CGFloat totalPrice = [[[LoginStorage GetCommonOrderDic] objectForKey:@"info"] floatValue];
                CGFloat discount = [[self.dic_coupon objectForKey:@"value"] floatValue];
                CGFloat price = totalPrice * discount / 10;
                [cell.lab_right setText:[NSString stringWithFormat:@"%.2f",price]];
            }else if ([[self.dic_coupon objectForKey:@"type"] intValue] == 2){
                CGFloat totalPrice = [[[LoginStorage GetCommonOrderDic] objectForKey:@"info"] floatValue];
                CGFloat discount = [[self.dic_coupon objectForKey:@"value"] floatValue];
                CGFloat price = totalPrice - discount;
                [cell.lab_right setText:[NSString stringWithFormat:@"%.2f",price]];
            }else{
                [cell.lab_right setText:[[LoginStorage GetCommonOrderDic] objectForKey:@"info"]];
            }
            [cell.lab_left setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
            [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
            [cell.img_jiantou setHidden:YES];
        }
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
            self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [self.view.window addSubview:self.backView];
            [self.backView setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.5]];
            
            self.btnView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 258.5, SCREEN_WIDTH, 44)];
            [self.backView addSubview:self.btnView];
            [self.btnView setBackgroundColor:[UIColor whiteColor]];
            
            
            UIImageView *img_xian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
            [self.btnView addSubview:img_xian];
            [img_xian setBackgroundColor:[UIColor colorWithHexString:@"#cdcdcd"]];
            
            self.dapicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 214.5, SCREEN_WIDTH, 214.5)];
            [self.backView addSubview:self.dapicker];
            self.dapicker.datePickerMode = UIDatePickerModeDateAndTime;
            [self.dapicker setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
            NSLocale *locae = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
            self.dapicker.locale = locae;
            NSDate *localeDate = [NSDate date];
            NSCalendar *gergorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *offsetComponents = [[NSDateComponents alloc]init];
            [offsetComponents setYear:0];
            [offsetComponents setMonth:0];
            [offsetComponents setDay:7];
            [offsetComponents setHour:20];
            [offsetComponents setMinute:0];
            [offsetComponents setSecond:0];
            NSDate *maxDate = [gergorian dateByAddingComponents:offsetComponents toDate:localeDate options:0];
            [self.dapicker setMaximumDate:maxDate];
            [self.dapicker setMinimumDate:localeDate];
            
            self.btn_cancel = [[UIButton alloc]initWithFrame:CGRectMake(20, 14.5, 30, 15.5)];
            [self.btnView addSubview:self.btn_cancel];
            [self.btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
            [self.btn_cancel setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
            self.btn_cancel.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.btn_cancel addTarget:self action:@selector(btn_cancelAction:) forControlEvents:UIControlEventTouchUpInside];
            
            self.btn_sure = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 14.5, 30, 15.5)];
            [self.btnView addSubview:self.btn_sure];
            [self.btn_sure setTitle:@"确定" forState:UIControlStateNormal];
            [self.btn_sure setTitleColor:[UIColor colorWithHexString:@"#FA6262"] forState:UIControlStateNormal];
            self.btn_sure.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.btn_sure addTarget:self action:@selector(btn_sureAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row == 2) {
            SelectFamilyViewController *seletView = [[SelectFamilyViewController alloc]init];
            seletView.delegate = self;
            [self.navigationController pushViewController:seletView animated:YES];
        }
    }
    if (tableView == tableView2) {
        if (indexPath.row == 2) {
            CouponsTableViewController *vc_cou = [[CouponsTableViewController alloc]init];
            vc_cou.isFromOrder = YES;
            vc_cou.delegate =self;
            [self.navigationController pushViewController:vc_cou animated:YES];
        }
    }
}

-(void)btn_cancelAction:(UIButton *)sender{
    [self.backView removeFromSuperview];
    [self.btnView removeFromSuperview];
}

-(void)btn_sureAction:(UIButton *)sender{
        
    NSDate *pickerDate = [self.dapicker date];
    // 需要月，日，小时， 来判断陪诊时间
//    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
//    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc]init];
//    NSDateFormatter *hourFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSDateFormatter *Hdata = [[NSDateFormatter alloc]init];
    [Hdata setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.str_time = [Hdata stringFromDate:pickerDate];
//    [monthFormatter setDateFormat:@"MM"];
//    [dayFormatter setDateFormat:@"dd"];
//    [hourFormatter setDateFormat:@"HH"];
//    NSString *strMonth = [monthFormatter stringFromDate:pickerDate];
//    NSString *strDay = [dayFormatter stringFromDate:pickerDate];
//    NSString *strHour = [hourFormatter stringFromDate:pickerDate];
    self.str_startTime = [pickerFormatter stringFromDate:pickerDate];
//    if ([strHour intValue] >= 0 && [strHour intValue] <= 12) {
//        self.str_startTime = [NSString stringWithFormat:@"%@/%@  08:00-12:00",strMonth,strDay];
//    }else{
//        self.str_startTime = [NSString stringWithFormat:@"%@/%@  13:30-17:30",strMonth,strDay];
//    }
    NSLog(@"dateStr = %@",self.str_startTime);
    
    
//    self.str_startTime = dateStr;
    [self.backView removeFromSuperview];
    [self.btnView removeFromSuperview];
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
}

-(void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnxiadanAction{
    if (self.str_hospitalId == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择就诊医院"];
    }else if (self.entity.userId == nil){
        [SVProgressHUD showErrorWithStatus:@"请选择就诊人"];
    }else if (self.str_time == nil || [self.str_time isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请选择就诊时间"];
    }else{
        [self UploadCommonOrder];
    }
//    PTSureOrderViewController *vc = [[PTSureOrderViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];

}

-(void)UploadCommonOrder{
    self.manager = [[AFNManager alloc]init];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,CreateCommonOrder];
    NSString *strSetId = [[LoginStorage GetCommonOrderDic] objectForKey:@"id"];
    //    NSDictionary *dic = @{@"setId":strSetId,@"hospitalId":strHospitalId,@"patientId":self.entity.userId,@"appointId":@"<null>",@"scheduleTime":self.str_time,@"couponId":@"<null>"};
    if ([[[self.dic_coupon objectForKey:@"id"] stringValue] length] > 0) {
        NSString *couponId = [NSString stringWithFormat:@"%@",[self.dic_coupon objectForKey:@"id"]];
        self.partnerDic = @{@"setId":strSetId,@"hospitalId":self.str_hospitalId,@"patientId":self.entity.userId,@"scheduleTime":self.str_time,@"couponId":couponId};
    }else{
        
        self.partnerDic = @{@"setId":strSetId,@"hospitalId":self.str_hospitalId,@"patientId":self.entity.userId,@"scheduleTime":self.str_time};
    }
    
    
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:self.partnerDic result:^(id responseDic) {
        NSLog(@"下单(普通)返回:%@",responseDic);
        if ([Status isEqualToString:SUCCESS]) {
            
            PTSureOrderViewController *orderView = [[PTSureOrderViewController alloc]init];
            orderView.str_OrderId = [[responseDic objectForKey:@"data"] objectForKey:@"orderId"];
            [self.navigationController pushViewController:orderView animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:Message];
        }
    } fail:^(NSError *error) {
        
    }];
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
