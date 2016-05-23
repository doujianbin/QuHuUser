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
#import "PayViewController.h"
#import "Toast+UIView.h"
#import "OrderStateTableViewCell.h"
#import "CancelViewController.h"
@interface PTSureOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView *tableView1;
    UITableView *tableView2;
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    UIScrollView *scl_back;
}

@property (nonatomic ,strong)AFNManager *manager;
@property (nonatomic ,strong)CommonOrderEntity *commonOrderEntity;
@property (nonatomic ,strong)NSString *out_trade_no;
@property (nonatomic ,strong)UILabel *lab_remark;
@property (nonatomic ,strong)UIView *upView;
@property (nonatomic ,strong)NSString *cancelMsg;
@property (nonatomic ,strong)UIView *backV;
@property (nonatomic ,strong)UILabel *labjishi;
@property (nonatomic        )NSInteger timeRemaining; //计时开始时间
@property (nonatomic ,strong)UIButton *btn_fuwu;
@property (nonatomic ,strong)UILabel *lab_totalPrice;
@property (nonatomic ,strong)UIButton *btn_quxiao;
@property (nonatomic ,strong)UIButton *btn_commonOrderzhifu;

@end

@implementation PTSureOrderViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        arr1 = [[NSMutableArray alloc]initWithObjects:@"",@"订单号",@"地址",@"时间",@"就诊人", nil];
        arr2 = [[NSMutableArray alloc]initWithObjects:@"优惠券", nil];
        
    }
    return self;
}

//-(void)viewWillAppear:(BOOL)animated{
//    [self.tabBarController.tabBar setHidden:YES];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [self.tabBarController.tabBar setHidden:NO];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
//    self.title = @"确认订单";
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    scl_back = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 54 )];
    [self.view addSubview:scl_back];
    // Do any additional setup after loading the view.
    [self addtableView];
    [self loadData];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinjieguotongzhi) name:@"weixinjieguo" object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinshibaitongzhi) name:@"weixinshibai" object:nil];
}

-(void)loadData{
    BeginActivity;
    NSString *strUrl = [NSString stringWithFormat:@"%@/quhu/accompany/user/queryOrderDetails?id=%@",Development,self.str_OrderId];
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:nil result:^(id responseDic) {
        NSLog(@"订单详情:%@",responseDic);
        EndActivity;
        if ([Status isEqualToString:SUCCESS]) {
            [self.lab_remark removeFromSuperview];
            [self.upView removeFromSuperview];
            self.commonOrderEntity = [CommonOrderEntity parseCommonOrderListEntityWithJson:[responseDic objectForKey:@"data"]];
            [self refershData];
            if (self.commonOrderEntity.orderStatus == 0) {
                self.title = @"待接单";
            }
            if (self.commonOrderEntity.orderStatus == 1) {
                self.title = @"待陪诊";
            }
            if (self.commonOrderEntity.orderStatus == 2) {
                self.title = @"陪诊中";
            }
            if (self.commonOrderEntity.orderStatus == 3) {
                self.title = @"待支付";
            }
            
        }else{
            FailMessage;
        }
    } fail:^(NSError *error) {
        NSLog(@"error == %@",error);
        EndActivity;
        NetError;
        
    }];
    
}

-(void)refershData{
    
    if (self.commonOrderEntity.orderStatus == 4) {
        //        [SVProgressHUD showSuccessWithStatus:@"您的订单已结束,可在历史订单列表查看"];
    }else{
        
        if (self.commonOrderEntity.orderType == 0 || self.commonOrderEntity.orderType == 2) {
            
            [self addCommonOrderDownView];
        }else{
            [self addSpecialOrderDownView];
            
        }
        
        [tableView1 reloadData];
        [tableView2 reloadData];
        //        [SVProgressHUD dismiss];
    }
    
    
}

-(void)addtableView{
    //    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10.5, SCREEN_WIDTH, 0.5)];
    //    [scl_back addSubview:img1];
    //    [img1 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 303 + 64) style:UITableViewStylePlain];
    [scl_back addSubview:tableView1];
    [tableView1 setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.scrollEnabled = NO;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 303 + 11 + 10.5 - 57, SCREEN_WIDTH, 0.5)];
    //    [scl_back addSubview:img2];
    //    [img2 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 317, SCREEN_WIDTH, 57) style:UITableViewStylePlain];
    [scl_back addSubview:tableView2];
    [tableView2 setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.scrollEnabled = NO;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *v_orderMsg = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tableView2.frame) + 10, SCREEN_WIDTH, 84)];
    [scl_back addSubview:v_orderMsg];
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
    
    self.btn_fuwu = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, CGRectGetMaxY(v_orderMsg.frame) + 10, 55, 20)];
    [scl_back addSubview:self.btn_fuwu];
    [self.btn_fuwu setTitle:@"服务详情" forState:UIControlStateNormal];
    [self.btn_fuwu setTitleColor:[UIColor colorWithHexString:@"4a90e2"] forState:UIControlStateNormal];
    self.btn_fuwu.titleLabel.font = [UIFont systemFontOfSize:13];
    self.btn_fuwu.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.btn_fuwu addTarget:self action:@selector(btnxiangqingAction) forControlEvents:UIControlEventTouchUpInside];
    
    
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

-(void)removeView{
    [self.backV removeFromSuperview];
}

-(void)addCommonOrderDownView{
//    UIView *view11 = [UIView new];
//    [self.view addSubview:view11];
    if (self.orderFromType == 2) {
        
        self.upView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 54 - 64, SCREEN_WIDTH, 54)];
    }else{
       self.upView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 54 - 64, SCREEN_WIDTH, 54)];
    }
    [self.view addSubview:self.upView];
    [self.upView setBackgroundColor:[UIColor whiteColor]];
    
    if (self.commonOrderEntity.orderStatus == 0 || self.commonOrderEntity.orderStatus == 3) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(14.5, 17, 20, 20)];
        [self.upView addSubview:img];
        [img setImage:[UIImage imageNamed:@"Oval 91 + Path 52"]];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(42, 16.5, 120, 21)];
        [self.upView addSubview:lab];
        if (self.commonOrderEntity.orderStatus == 0) {
            [lab setText:@"等待护士接单"];
        }
        if (self.commonOrderEntity.orderStatus == 3) {
            [lab setText:@"等待支付"];
        }
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [UIColor colorWithHexString:@"#FA6262"];
        
        self.btn_commonOrderzhifu = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 54)];
        [self.upView addSubview:self.btn_commonOrderzhifu];
        [self.btn_commonOrderzhifu setBackgroundColor:[UIColor colorWithHexString:@"#fa6262"]];
        [self.btn_commonOrderzhifu setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        if (self.commonOrderEntity.orderStatus == 0) {
            
            [self.btn_commonOrderzhifu setTitle:@"取消订单" forState:UIControlStateNormal];
        }
        if (self.commonOrderEntity.orderStatus == 3) {
            [self.btn_commonOrderzhifu setTitle:@"完成支付" forState:UIControlStateNormal];
        }
        self.btn_commonOrderzhifu.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btn_commonOrderzhifu addTarget:self action:@selector(btnCommonOrderZhiFu:) forControlEvents:UIControlEventTouchUpInside];
        if (self.commonOrderEntity.orderStatus == 3) {
            // 加上下面的合计金额
            self.lab_totalPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.btn_fuwu.frame) + 20, SCREEN_WIDTH, 20)];
            [scl_back addSubview:self.lab_totalPrice];
            self.lab_totalPrice.font = [UIFont systemFontOfSize:17];
            NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计金额：%@ 元",self.commonOrderEntity.payAmount]];
            
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#929292"] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fa6262"] range:NSMakeRange(5, myStr.length - 5)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(5, myStr.length - 5)];
            [self.lab_totalPrice setAttributedText:myStr];
            self.lab_totalPrice.textAlignment = NSTextAlignmentCenter;
        }
    }
    if (self.commonOrderEntity.orderStatus == 1) {
        // 护士已经接单
        UIImageView *img_NurseHeadPic = [[UIImageView alloc]initWithFrame:CGRectMake(15.5, 7, 40, 40)];
        img_NurseHeadPic.layer.cornerRadius = 20;
        img_NurseHeadPic.layer.masksToBounds = YES;
        [self.upView addSubview:img_NurseHeadPic];
        if ([[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"] isKindOfClass:[NSNull class]]) {
            [img_NurseHeadPic setImage:[UIImage imageNamed:@"ic_个人中心"]];
        }else{
            NSURL *url_NurseHeadPic = [NSURL URLWithString:[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"]];
            [img_NurseHeadPic sd_setImageWithURL:url_NurseHeadPic placeholderImage:[UIImage imageNamed:@"ic_个人中心"]];
        }
        UILabel *lab_nurseName = [[UILabel alloc]initWithFrame:CGRectMake(70.5, 8.5, 70, 21)];
        [self.upView addSubview:lab_nurseName];
        lab_nurseName.font = [UIFont systemFontOfSize:15];
        [lab_nurseName setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [lab_nurseName setText:[self.commonOrderEntity.nurse objectForKey:@"nurseName"]];
        UILabel *lab_orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(70.5, 31, 80, 14)];
        [self.upView addSubview:lab_orderStatus];
        lab_orderStatus.font = [UIFont systemFontOfSize:10];
        lab_orderStatus.textColor = [UIColor colorWithHexString:@"#FA6262"];
        
        UIButton *btn_commonOrderCallNurse = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 0, 90, 54)];
        [self.upView addSubview:btn_commonOrderCallNurse];
        [btn_commonOrderCallNurse setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
        btn_commonOrderCallNurse.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn_commonOrderCallNurse setTitle:@"联系护士" forState:UIControlStateNormal];
        [btn_commonOrderCallNurse addTarget:self action:@selector(btn_commonOrderCallNurseAction) forControlEvents:UIControlEventTouchUpInside];
        
        [lab_orderStatus setText:@"护士已接单"];
        self.btn_quxiao = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 180, 0, 90, 54)];
        [self.upView addSubview:self.btn_quxiao];
        [self.btn_quxiao setBackgroundColor:[UIColor colorWithHexString:@"#f7f7f7"]];
        self.btn_quxiao.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btn_quxiao setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.btn_quxiao setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
        [self.btn_quxiao addTarget:self action:@selector(btnCommonOrderZhiFu:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    if (self.commonOrderEntity.orderStatus == 2) {
        // 陪诊中
        UIImageView *img_NurseHeadPic = [[UIImageView alloc]initWithFrame:CGRectMake(15.5, 7, 40, 40)];
        img_NurseHeadPic.layer.cornerRadius = 20;
        img_NurseHeadPic.layer.masksToBounds = YES;
        [self.upView addSubview:img_NurseHeadPic];
        if ([[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"] isKindOfClass:[NSNull class]]) {
            [img_NurseHeadPic setImage:[UIImage imageNamed:@"ic_个人中心"]];
        }else{
            NSURL *url_NurseHeadPic = [NSURL URLWithString:[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"]];
            [img_NurseHeadPic sd_setImageWithURL:url_NurseHeadPic placeholderImage:[UIImage imageNamed:@"ic_个人中心"]];
        }
        
        UIButton *btn_commonOrderCallNurse = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 54)];
        [self.upView addSubview:btn_commonOrderCallNurse];
        [btn_commonOrderCallNurse setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
        btn_commonOrderCallNurse.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn_commonOrderCallNurse setTitle:@"联系护士" forState:UIControlStateNormal];
        [btn_commonOrderCallNurse addTarget:self action:@selector(btn_commonOrderCallNurseAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.labjishi = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_NurseHeadPic.frame) + 12, (self.upView.frame.size.height - 30) / 2, SCREEN_WIDTH - CGRectGetMaxX(img_NurseHeadPic.frame) - 15 - 110, 30)];
        [self.upView addSubview:self.labjishi];
        [self.labjishi setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
        if (iPhone5) {
            [self.labjishi setFont:[UIFont systemFontOfSize:14]];
        }else{
            
            [self.labjishi setFont:[UIFont systemFontOfSize:17]];
        }
        NSString *creettime = self.commonOrderEntity.startTime;
        NSDateFormatter *formmatter = [[NSDateFormatter alloc] init];
        [formmatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *fromdate = [formmatter dateFromString:creettime];
        self.timeRemaining = [self compareCurrentTime:fromdate];
        [self startCountDownForReauth];
    }
    if (self.commonOrderEntity.orderStatus == 3) {
        if (iPhone5) {
            [scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.lab_totalPrice.frame) + 80)];
        }else{
            
            [scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.lab_totalPrice.frame) + 20)];
        }
    }else{
        if (iPhone5) {
            [scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.btn_fuwu.frame) + 80)];
        }else{
            
            [scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.btn_fuwu.frame) + 20)];
        }
    }
}

- (void)startCountDownForReauth
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(countingDownForReauthAction:)
                                                    userInfo:nil
                                                     repeats:YES];
    
    [timer fire];
}

//定时改变按钮名称方法（注：该方法每隔间隔时间都会调用一次）
- (void)countingDownForReauthAction:(NSTimer *)timer
{
    self.timeRemaining++;
    NSString *shouldtext = [NSString stringWithFormat:@"陪诊计时：%02ld:%02ld:%02ld", self.timeRemaining / 3600, (self.timeRemaining  / 60) % 60, self.timeRemaining  % 60];
    [self.labjishi setText:shouldtext];
}

-(NSInteger )compareCurrentTime:(NSDate*) compareDate
//
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    
    return timeInterval;
}

-(void)addSpecialOrderDownView{
    UIView *view11 = [UIView new];
    [self.view addSubview:view11];
    self.upView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 54, SCREEN_WIDTH, 54)];
    [self.view addSubview:self.upView];
    [self.upView setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    
    UIButton *btn_right = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 54)];
    [self.upView addSubview:btn_right];
    [btn_right setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    btn_right.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_right addTarget:self action:@selector(btn_rightAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn_left = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 0, 100, 54)];
    [self.upView addSubview:btn_left];
    [btn_left setBackgroundColor:[UIColor colorWithHexString:@"#E3E3E6"]];
    btn_left.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_left setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
    [btn_left addTarget:self action:@selector(btn_leftAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.commonOrderEntity.orderStatus == 0) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(14.5, 17, 20, 20)];
        [self.upView addSubview:img];
        [img setImage:[UIImage imageNamed:@"Oval 91 + Path 52"]];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(42, 16.5, 120, 21)];
        [self.upView addSubview:lab];
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [UIColor colorWithHexString:@"#FA6262"];
        
        if (self.commonOrderEntity.payStatus == 0) {
            [lab setText:@"等待支付"];
            [btn_left setTitle:@"取消订单" forState:UIControlStateNormal];
            [btn_right setTitle:@"完成支付" forState:UIControlStateNormal];
        }
        if (self.commonOrderEntity.payStatus == 1) {
            [lab setText:@"等待护士接单"];
            [btn_left setHidden:YES];
            [btn_right setTitle:@"取消订单" forState:UIControlStateNormal];
        }
    }
    if (self.commonOrderEntity.orderStatus == 1) {
        
        UIImageView *img_NurseHeadPic = [[UIImageView alloc]initWithFrame:CGRectMake(15.5, 7, 40, 40)];
        [self.upView addSubview:img_NurseHeadPic];
        if ([[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"] isKindOfClass:[NSNull class]]) {
            [img_NurseHeadPic setImage:[UIImage imageNamed:@"ic_个人中心"]];
        }else{
            NSURL *url_NurseHeadPic = [NSURL URLWithString:[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"]];
            [img_NurseHeadPic sd_setImageWithURL:url_NurseHeadPic placeholderImage:[UIImage imageNamed:@"ic_个人中心"]];
        }
        UILabel *lab_nurseName = [[UILabel alloc]initWithFrame:CGRectMake(70.5, 8.5, 70, 21)];
        [self.upView addSubview:lab_nurseName];
        lab_nurseName.font = [UIFont systemFontOfSize:15];
        [lab_nurseName setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [lab_nurseName setText:[self.commonOrderEntity.nurse objectForKey:@"nurseName"]];
        UILabel *lab_orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(70.5, 31, 80, 14)];
        [self.upView addSubview:lab_orderStatus];
        lab_orderStatus.font = [UIFont systemFontOfSize:10];
        lab_orderStatus.textColor = [UIColor colorWithHexString:@"#FA6262"];
        [lab_orderStatus setText:@"护士已接单"];
        [btn_left setTitle:@"取消订单" forState:UIControlStateNormal];
        [btn_right setTitle:@"联系护士" forState:UIControlStateNormal];
    }
    if (self.commonOrderEntity.orderStatus == 2) {
        UIImageView *img_NurseHeadPic = [[UIImageView alloc]initWithFrame:CGRectMake(15.5, 7, 40, 40)];
        [self.upView addSubview:img_NurseHeadPic];
        if ([[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"] isKindOfClass:[NSNull class]]) {
            [img_NurseHeadPic setImage:[UIImage imageNamed:@"ic_个人中心"]];
        }else{
            NSURL *url_NurseHeadPic = [NSURL URLWithString:[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"]];
            [img_NurseHeadPic sd_setImageWithURL:url_NurseHeadPic placeholderImage:[UIImage imageNamed:@"ic_个人中心"]];
        }
        UILabel *lab_nurseName = [[UILabel alloc]initWithFrame:CGRectMake(70.5, 8.5, 70, 21)];
        [self.upView addSubview:lab_nurseName];
        lab_nurseName.font = [UIFont systemFontOfSize:15];
        [lab_nurseName setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
        [lab_nurseName setText:[self.commonOrderEntity.nurse objectForKey:@"nurseName"]];
        UILabel *lab_orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(70.5, 31, 80, 14)];
        [self.upView addSubview:lab_orderStatus];
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
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == tableView1) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"OrderStatusCell";
            OrderStateTableViewCell *cell = (OrderStateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell){
                cell = [[OrderStateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if (self.commonOrderEntity.orderStatus == 0) {
                [cell.lab_1 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
                [cell.lab_2 setTextColor:[UIColor colorWithHexString:@"#a4a4a4"]];
                [cell.lab_3 setTextColor:[UIColor colorWithHexString:@"#a4a4a4"]];
                [cell.lab_4 setTextColor:[UIColor colorWithHexString:@"#a4a4a4"]];
                [cell.img_orderState setImage:[UIImage imageNamed:@"02-00等待护士接单－进度条@2x_03"]];
            }
            if (self.commonOrderEntity.orderStatus == 1) {
                [cell.lab_1 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
                [cell.lab_2 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
                [cell.lab_3 setTextColor:[UIColor colorWithHexString:@"#a4a4a4"]];
                [cell.lab_4 setTextColor:[UIColor colorWithHexString:@"#a4a4a4"]];
                [cell.img_orderState setImage:[UIImage imageNamed:@"02-01待陪诊@2x_03"]];
            }
            if (self.commonOrderEntity.orderStatus == 2) {
                [cell.lab_1 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
                [cell.lab_2 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
                [cell.lab_3 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
                [cell.lab_4 setTextColor:[UIColor colorWithHexString:@"#a4a4a4"]];
                [cell.img_orderState setImage:[UIImage imageNamed:@"02-02陪诊中@2x_03"]];
            }
            if (self.commonOrderEntity.orderStatus == 3) {
                [cell.lab_1 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
                [cell.lab_2 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
                [cell.lab_3 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
                [cell.lab_4 setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
                [cell.img_orderState setImage:[UIImage imageNamed:@"2-03等待支付－进度条@2x_03"]];
            }
            
            return cell;
        }
        else if (indexPath.row == 2) {
            static NSString *CellIdentifier = @"AddressCell";
            HospitalAddressTableViewCell *cell = (HospitalAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            NSString *time = [self.commonOrderEntity.scheduleTime substringFromIndex:5];
            NSString *scheduleT = [time substringToIndex:time.length - 3];
            switch (indexPath.row) {
                case 1:
                    [cell.lab_right setText:self.commonOrderEntity.orderNo];
                    break;
                case 3:
                    
                    [cell.lab_right setText:scheduleT];
//                    [cell.lab_right setText:self.commonOrderEntity.scheduleTime];
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
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.img_jiantou setHidden:YES];
        [cell.lab_left setText:[arr2 objectAtIndex:indexPath.row]];
        switch (indexPath.row) {
                //            case 0:
                //                if (self.commonOrderEntity.orderType == 0) {
                //                    [cell.lab_right setText:@"普通陪诊"];
                //                }else{
                //                    [cell.lab_right setText:@"特需陪诊"];
                //                }
                //                [cell.lab_left setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
                //                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A90E2"]];
                //                break;
                //            case 1:
                //                [cell.lab_left setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
                //                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
                //                [cell.lab_right setText:[NSString stringWithFormat:@"￥%@/4小时",self.commonOrderEntity.setAmount]];
                //                break;
            case 0:
                if (self.commonOrderEntity.couponType == 1) {
                    CGFloat couponValue = self.commonOrderEntity.couponValue * 10;
                    [cell.lab_right setText:[NSString stringWithFormat:@"%.f折",couponValue]];
                }else if (self.commonOrderEntity.couponType == 2){
                    [cell.lab_right setText:[NSString stringWithFormat:@"-%d元",(int)self.commonOrderEntity.couponValue]];
                }else if (self.commonOrderEntity.couponType == 3){
                    [cell.lab_right setText:@"免套餐券"];
                }
                else{
                    [cell.lab_right setText:@"暂未使用优惠券"];
                }
                [cell.lab_left setTextColor:[UIColor colorWithHexString:@"#4A4A4A"]];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                break;
            case 3:
                [cell.lab_left setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                [cell.lab_right setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
                [cell.lab_right setText:[NSString stringWithFormat:@"%@",self.commonOrderEntity.totalAmount]];
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
//        self.btn_commonOrderzhifu.enabled = NO;
//        self.btn_quxiao.enabled = NO;
        [self cancalOrder];
    }
    if ([sender.titleLabel.text isEqualToString:@"完成支付"]) {
        //        [self weixinPay];
        PayViewController *vc = [[PayViewController alloc]init];
        vc.entity = self.commonOrderEntity;
        vc.str_OrderId = self.str_OrderId;
        vc.orderNo = self.commonOrderEntity.orderNo;
        vc.totalAmount = self.commonOrderEntity.payAmount;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)btn_commonOrderCallNurseAction{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"联系护士" message:[self.commonOrderEntity.nurse objectForKey:@"nursePhone"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    alert.tag = 222;
    [alert show];
}


-(void)btn_leftAction{
    [self cancalOrder];
}

-(void)btn_rightAction:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        [self cancalOrder];
    }
    if ([sender.titleLabel.text isEqualToString:@"完成支付"]) {
        // 支付
        //        [self weixinPay];
        PayViewController *vc = [[PayViewController alloc]init];
        vc.entity = self.commonOrderEntity;
        vc.str_OrderId = self.str_OrderId;
        vc.orderNo = self.commonOrderEntity.orderNo;
        vc.totalAmount = self.commonOrderEntity.totalAmount;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([sender.titleLabel.text isEqualToString:@"联系护士"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"联系护士" message:[self.commonOrderEntity.nurse objectForKey:@"nursePhone"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        alert.tag = 222;
        [alert show];
    }
}

-(void)cancalOrder{
    
    if (self.commonOrderEntity.payStatus == 0) {
        // 未支付
        self.cancelMsg = @"多次取消，您将无法继续预订，确认取消订单?";
    }else{
        self.cancelMsg = @"现在取消，已支付金额将原路退回，确认取消订单？";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:self.cancelMsg delegate:self cancelButtonTitle:@"确认取消" otherButtonTitles:@"再想想", nil];
    alert.tag = 111;
    alert.delegate = self;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111) {
        
        if (buttonIndex == 0) {
            self.btn_commonOrderzhifu.enabled = NO;
            self.btn_quxiao.enabled = NO;
            NSString *strUrl = [NSString stringWithFormat:@"%@/quhu/accompany/user/order/cancelOrder?orderId=%@",Development,self.str_OrderId];
            self.manager = [[AFNManager alloc]init];
            [self.manager RequestJsonWithUrl:strUrl method:@"GET" parameter:nil result:^(id responseDic) {
                NSLog(@"取消订单结果 :%@",responseDic);
                if ([Status isEqualToString:SUCCESS]) {
                    [self.view makeToast:@"取消成功" duration:1.0 position:@"center"];
                    [NSTimer scheduledTimerWithTimeInterval:1.5
                                                     target:self
                                                   selector:@selector(cancelSuccess)
                                                   userInfo:nil
                                                    repeats:NO];
                }else{
                    self.btn_commonOrderzhifu.enabled = YES;
                    self.btn_quxiao.enabled = YES;
                    FailMessage;
                }
                
            } fail:^(NSError *error) {
                self.btn_commonOrderzhifu.enabled = YES;
                self.btn_quxiao.enabled = YES;
                NetError;
            }];
        }
    }
    if (alertView.tag == 222) {
        if (buttonIndex == 1) {
            
            NSString *str1 = @"tel://";
            NSString *str2 = [self.commonOrderEntity.nurse objectForKey:@"nursePhone"];
            NSString *stt = [NSString stringWithFormat:@"%@%@",str1,str2];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stt]];
        }
    }
}

-(void)NavLeftAction{
    if (self.orderFromType == 2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)cancelSuccess{
    CancelViewController *vc = [[CancelViewController alloc]init];
    vc.str_OrderId = self.str_OrderId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
