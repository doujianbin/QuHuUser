//
//  TXOrderViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/1/13.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "TXOrderViewController.h"
#import "TXOrderTableViewCell.h"
#import "DoctorDetailTableViewCell.h"
#import "HospitalAddressTableViewCell.h"
#import "SelectFamilyViewController.h"
#import "CouponsTableViewController.h"
#import "PTSureOrderViewController.h"

@interface TXOrderViewController ()<UITableViewDataSource,UITableViewDelegate,SelectFamilyViewControllerDelegate,CouponsTableViewControllerDegelate>{
    NSMutableArray *arr_all;
    UITableView *tableViewTXOrder;
}

@property (nonatomic ,retain)UIImageView *lab_cellImgPic;
@property (nonatomic ,retain)UILabel *lab_cellName;
@property (nonatomic ,retain)UILabel *lab_cellzhicheng;
@property (nonatomic ,retain)UILabel *lab_cellyiyuankeshi;
@property (nonatomic ,strong)MemberEntity *memberEntity;
@property (nonatomic ,strong)NSDictionary *dicCoupon;
@property (nonatomic ,strong)AFNManager *manager;
@property (nonatomic ,strong)NSDictionary *partnerDic;

@end

@implementation TXOrderViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableArray *arr1 = [[NSMutableArray alloc]initWithObjects:@"",@"时间",@"地址", nil];
        NSMutableArray *arr2 = [[NSMutableArray alloc]initWithObjects:@"成员", nil];
        NSMutableArray *arr3 = [[NSMutableArray alloc]initWithObjects:@"服务",@"价格",@"优惠券",@"合计金额:", nil];
        arr_all = [[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3 ,nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    self.title = self.doctorEntity.name;
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [self createTableView];
}

- (void)createTableView{
    tableViewTXOrder = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 497.5 + 64)];
    [self.view addSubview:tableViewTXOrder];
    tableViewTXOrder.dataSource = self;
    tableViewTXOrder.delegate = self;
    tableViewTXOrder.scrollEnabled = NO;
    tableViewTXOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableViewTXOrder setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
//    [tableViewTXOrder registerClass:[TXOrderTableViewCell class]forCellReuseIdentifier:@"DoctorDetailtableView"];
//    [tableViewTXOrder registerClass:[TXOrderTableViewCell class]forCellReuseIdentifier:@"TableView"];
//    [tableViewTXOrder registerClass:[TXOrderTableViewCell class]forCellReuseIdentifier:@"HospitaltTableView"];
    
    UILabel *lab_remark = [[UILabel alloc]initWithFrame:CGRectMake(15, 572.5, 300, 12.5)];
    [self.view addSubview:lab_remark];
    [lab_remark setText:@"备注：陪诊超时按照小时收费（￥60/小时）"];
    [lab_remark setTextColor:[UIColor colorWithHexString:@"#9B9B9B"]];
    lab_remark.font = [UIFont systemFontOfSize:12];
    
    UIButton *btn_xiadan = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    [self.view addSubview:btn_xiadan];
    [btn_xiadan setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    [btn_xiadan setTitle:@"确认下单" forState:UIControlStateNormal];
    btn_xiadan.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn_xiadan addTarget:self action:@selector(btnTXxiadanAction) forControlEvents:UIControlEventTouchUpInside];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 7.5)];
    [sectionView setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    return sectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arr_all.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *arr = [arr_all objectAtIndex:section];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && indexPath.row == 0) ||(indexPath.section == 0 && indexPath.row == 2)) {
        return 70;
    }else{
        return 57;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 7.5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *CellIdentifier = @"DoctorCell";
        DoctorDetailTableViewCell *cell = (DoctorDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell){
            cell = [[DoctorDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell contentDoctorDetailWithDoctorEntity:self.doctorEntity];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        static NSString *CellIdentifier = @"HospitalCell";
        HospitalAddressTableViewCell *cell = (HospitalAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell){
            cell = [[HospitalAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.lab_left setText:[[arr_all objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        [cell.lab_hospital setText:self.hospitalEntity.hospitalName];
        [cell.lab_addressDetail setText:self.hospitalEntity.hospitalAddress];
        return cell;
    }else{
        static NSString *CellIdentifier = @"OrderCell";
        TXOrderTableViewCell *cell = (TXOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell){
            cell = [[TXOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.lab_left setText:[[arr_all objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        if (indexPath.section == 0 && indexPath.row == 1) {
            NSString *yue = [[self.dayEntity.dayTime substringFromIndex:self.dayEntity.dayTime.length - 5] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            NSString *week = [NSString stringWithFormat:@"(周%@)",self.dayEntity.week];
            NSString *time = self.appointEntity.startTime;
            NSString *str = [NSString stringWithFormat:@"%@  %@  %@",yue,week,time];
            [cell.lab_right setText:str];
        }
        if (indexPath.section == 1 && indexPath.row == 0) {
            if (self.memberEntity.name.length > 0) {
                [cell.lab_right setText:self.memberEntity.name];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
                cell.lab_right.alpha = 1.0;
            }else{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.lab_right setFrame:CGRectMake(SCREEN_WIDTH - 295, 0, 265, 57)];
                [cell.lab_right setText:@"选择就诊成员"];
                cell.lab_right.alpha = 0.6;
            }
        }
        if (indexPath.section == 2 && indexPath.row == 0) {
            [cell.lab_right setText:@"特需陪诊"];
            [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A90E2"]];
        }
        if (indexPath.section == 2 && indexPath.row == 1) {
            [cell.lab_right setText:[NSString stringWithFormat:@"¥%@/4小时",[[LoginStorage GetSpecialrderDic] objectForKey:@"info"]]];
        }
        if (indexPath.section == 2 && indexPath.row == 2) {
            if ([[[self.dicCoupon objectForKey:@"id"] stringValue] length] > 0) {
                if ([[self.dicCoupon objectForKey:@"type"] intValue] == 1) {
                    CGFloat discount = [[self.dicCoupon objectForKey:@"value"] floatValue];
                    [cell.lab_right setText:[NSString stringWithFormat:@"%.f折",discount]];
                    [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                    cell.lab_right.alpha = 1.0;
                }
                if ([[self.dicCoupon objectForKey:@"type"] intValue] == 2) {
                    [cell.lab_right setText:[NSString stringWithFormat:@"-¥%@",[self.dicCoupon objectForKey:@"value"]]];
                    [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                    cell.lab_right.alpha = 1.0;
                }
            }else{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.lab_right setText:@"选择使用优惠券"];
                [cell.lab_right setFrame:CGRectMake(SCREEN_WIDTH - 295, 0, 265, 57)];
                cell.lab_right.alpha = 0.6;
                
            }
        }
        if (indexPath.section == 2 && indexPath.row == 3) {
            cell.lab_left.alpha = 0.8;
            cell.lab_right.alpha = 1.0;
            if ([[self.dicCoupon objectForKey:@"type"] intValue] == 1) {
                CGFloat totalPrice = [[[LoginStorage GetSpecialrderDic] objectForKey:@"info"] floatValue];
                CGFloat discount = [[self.dicCoupon objectForKey:@"value"] floatValue];
                CGFloat price = totalPrice * discount / 10;
                [cell.lab_right setText:[NSString stringWithFormat:@"%.2f",price]];
            }else if ([[self.dicCoupon objectForKey:@"type"] intValue] == 2){
                CGFloat totalPrice = [[[LoginStorage GetSpecialrderDic] objectForKey:@"info"] floatValue];
                CGFloat discount = [[self.dicCoupon objectForKey:@"value"] floatValue];
                CGFloat price = totalPrice - discount;
                [cell.lab_right setText:[NSString stringWithFormat:@"%.2f",price]];
            }else{
                [cell.lab_right setText:[[LoginStorage GetSpecialrderDic] objectForKey:@"info"]];
            }
            [cell.lab_left setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
            [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];

        }
        
        return cell;
    }
    return nil; 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
        SelectFamilyViewController *vc = [[SelectFamilyViewController alloc]init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        CouponsTableViewController *vc_coupon = [[CouponsTableViewController alloc]init];
        vc_coupon.delegate = self;
        vc_coupon.isFromOrder = YES;
        [self.navigationController pushViewController:vc_coupon animated:YES];
    }
    
}

- (void)didSelectedMemberWithEntity:(MemberEntity *)memberEntity{
    self.memberEntity = memberEntity;
    [tableViewTXOrder reloadData];
}

- (void)didSelectedCouponsWithDic:(NSDictionary *)couponsDic{
    self.dicCoupon = couponsDic;
    [tableViewTXOrder reloadData];
}

-(void)btnTXxiadanAction{
    if (self.memberEntity.name == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择就诊人"];
    }else{
        [self uploadSpecialOrderData];
    }
}

-(void)uploadSpecialOrderData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,CreateSpecialOrder];
    NSString *strSetId = [[LoginStorage GetSpecialrderDic] objectForKey:@"id"];
    NSString *time = [NSString stringWithFormat:@"%@ %@",self.dayEntity.dayTime,self.appointEntity.startTime];
    
    if ([[[self.dicCoupon objectForKey:@"id"] stringValue] length] > 0) {
        NSString *couponId = [NSString stringWithFormat:@"%@",[self.dicCoupon objectForKey:@"id"]];
        self.partnerDic = @{@"setId":strSetId,@"hospitalId":self.hospitalEntity.hospitalId,@"patientId":self.memberEntity.userId,@"scheduleTime":time,@"couponId":couponId,@"appointId":self.appointEntity._id};
    }else{

        self.partnerDic = @{@"setId":strSetId,@"hospitalId":self.hospitalEntity.hospitalId,@"patientId":self.memberEntity.userId,@"scheduleTime":time,@"appointId":self.appointEntity._id};
    }
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:self.partnerDic result:^(id responseDic) {
        NSLog(@"下单(特需)返回:%@",responseDic);
        if ([Status isEqualToString:SUCCESS]) {
            
            PTSureOrderViewController *orderView = [[PTSureOrderViewController alloc]init];
            orderView.str_OrderId = [[responseDic objectForKey:@"data"] objectForKey:@"orderId"];
            [self.navigationController pushViewController:orderView animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:Message];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}

-(void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
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
