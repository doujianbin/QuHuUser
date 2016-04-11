//
//  CompleteOrderDetailViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/24.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "CompleteOrderDetailViewController.h"
#import "CommonOrderEntity.h"
#import "Toast+UIView.h"
#import "GCPlaceholderTextView.h"

@interface CompleteOrderDetailViewController ()<UIAlertViewDelegate>

@property (nonatomic ,strong)AFNManager *manager;
@property (nonatomic ,strong)CommonOrderEntity *commonOrderEntity;
@property (nonatomic ,strong)UIView *v_total;

@property (nonatomic ,strong)UIView *v_detail;
@property (nonatomic ,strong)UIScrollView *scl_back;
@property (nonatomic ,strong)UIView *v_pingjia;
@property (nonatomic ,strong)NSMutableArray *btn_all;
@property (nonatomic ,strong)GCPlaceholderTextView *evaluteView;
@property (nonatomic ,strong)UILabel *lab_pingjia;


@end

@implementation CompleteOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#e8e8e8"]];
    self.title = @"订单";
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnR = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 85, 21.5, 67, 17)];
    [btnR setTitle:@"客服咨询" forState:UIControlStateNormal];
    [btnR setTitleColor:[UIColor colorWithHexString:@"#FA6262"] forState:UIControlStateNormal];
    [btnR sizeToFit];
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc]initWithCustomView:btnR];
    self.navigationItem.rightBarButtonItem = btnRight;
    [btnR addTarget:self action:@selector(NavRightAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    
    self.scl_back = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 54 )];
    [self.view addSubview:self.scl_back];
    [self.scl_back setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    
    [self loadData];
}

-(void)loadData{
    BeginActivity;
    NSString *strUrl = [NSString stringWithFormat:@"%@/quhu/accompany/user/queryOrderDetails?id=%@",Development,self.orderId];
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:nil result:^(id responseDic) {
        NSLog(@"订单详情:%@",responseDic);
        EndActivity;
        if ([Status isEqualToString:SUCCESS]) {
            self.commonOrderEntity = [CommonOrderEntity parseCommonOrderListEntityWithJson:[responseDic objectForKey:@"data"]];
            [self onCreate];
        }else{
            FailMessage;
        }
    } fail:^(NSError *error) {
        NSLog(@"error == %@",error);
        EndActivity;
        NetError;
    }];
}

-(void)onCreate{
    self.v_total = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    [self.scl_back addSubview:self.v_total];
    [self.v_total setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *img_head = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
    [self.v_total addSubview:img_head];
    img_head.layer.cornerRadius = 30.0f;
    img_head.layer.masksToBounds = YES;
    [img_head sd_setImageWithURL:[NSURL URLWithString:[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"]] placeholderImage:[UIImage imageNamed:@"ic_个人中心"]];
    UILabel *lab_nurseName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_head.frame) + 15, 35, 200, 16)];
    [self.v_total addSubview:lab_nurseName];
    [lab_nurseName setText:[self.commonOrderEntity.nurse objectForKey:@"nurseName"]];
    
    lab_nurseName.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    lab_nurseName.font = [UIFont systemFontOfSize:17];
    
    self.v_detail = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.v_total.frame) + 10, SCREEN_WIDTH, 202)];
    [self.scl_back addSubview:self.v_detail];
    [self.v_detail setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lab_zhifu = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 15)];
    [self.v_detail addSubview:lab_zhifu];
    [lab_zhifu setText:@"已支付"];
    [lab_zhifu setTextColor:[UIColor colorWithHexString:@"#929292"]];
    [lab_zhifu setTextAlignment:NSTextAlignmentCenter];
    [lab_zhifu setFont:[UIFont systemFontOfSize:13]];
    
    UILabel *lab_totlePrice = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab_zhifu.frame) + 5, SCREEN_WIDTH, 25)];
    [self.v_detail addSubview:lab_totlePrice];
    [lab_totlePrice setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
    [lab_totlePrice setTextAlignment:NSTextAlignmentCenter];
    [lab_totlePrice setFont:[UIFont systemFontOfSize:25]];
    [lab_totlePrice setText:[NSString stringWithFormat:@"%@ 元",self.commonOrderEntity.payAmount]];
    
    UILabel *lab_feiyong = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, CGRectGetMaxY(lab_totlePrice.frame) + 10, 60, 13)];
    [self.v_detail addSubview:lab_feiyong];
    [lab_feiyong setText:@"费用详情"];
    [lab_feiyong setTextColor:[UIColor colorWithHexString:@"#929292"]];
    [lab_feiyong setTextAlignment:NSTextAlignmentCenter];
    [lab_feiyong setFont:[UIFont systemFontOfSize:13]];
    
    UIImageView *img_line1 = [[UIImageView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(lab_totlePrice.frame) + 16.5, SCREEN_WIDTH / 2 - 80, 0.5)];
    [self.v_detail addSubview:img_line1];
    [img_line1 setBackgroundColor:[UIColor colorWithHexString:@"#dbdcdd"]];
    
    UIImageView *img_line2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 40, CGRectGetMaxY(lab_totlePrice.frame) + 16.5, SCREEN_WIDTH / 2 - 80, 0.5)];
    [self.v_detail addSubview:img_line2];
    [img_line2 setBackgroundColor:[UIColor colorWithHexString:@"#dbdcdd"]];
    
    UILabel *lab_xiangqing1 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lab_feiyong.frame) + 10, 200, 13)];
    [self.v_detail addSubview:lab_xiangqing1];
    [lab_xiangqing1 setText:@"套餐费 (含 4 个小时)"];
    [lab_xiangqing1 setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    [lab_xiangqing1 setFont:[UIFont systemFontOfSize:13]];
    
    UILabel *lab_xiangqing11 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 115, CGRectGetMaxY(lab_feiyong.frame) + 10, 100, 13)];
    [self.v_detail addSubview:lab_xiangqing11];
    [lab_xiangqing11 setText:[NSString stringWithFormat:@"%@ 元",self.commonOrderEntity.setAmount]];
    [lab_xiangqing11 setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    [lab_xiangqing11 setFont:[UIFont systemFontOfSize:13]];
    [lab_xiangqing11 setTextAlignment:NSTextAlignmentRight];
    
    UILabel *lab_xiangqing2 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lab_xiangqing1.frame) + 10, 200, 13)];
    [self.v_detail addSubview:lab_xiangqing2];
    [lab_xiangqing2 setText:@"超时费 (25 元 / 半小时)"];
    [lab_xiangqing2 setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    [lab_xiangqing2 setFont:[UIFont systemFontOfSize:13]];
    
    UILabel *lab_xiangqing22 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 115, CGRectGetMaxY(lab_xiangqing1.frame) + 10, 100, 13)];
    [self.v_detail addSubview:lab_xiangqing22];
    [lab_xiangqing22 setText:[NSString stringWithFormat:@"%@ 元",self.commonOrderEntity.overtimeAmount]];
    [lab_xiangqing22 setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    [lab_xiangqing22 setFont:[UIFont systemFontOfSize:13]];
    [lab_xiangqing22 setTextAlignment:NSTextAlignmentRight];
    
    UILabel *lab_xiangqing3 = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lab_xiangqing2.frame) + 10, 200, 13)];
    [self.v_detail addSubview:lab_xiangqing3];
    [lab_xiangqing3 setText:@"优惠金额 (优惠券减免)"];
    [lab_xiangqing3 setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    [lab_xiangqing3 setFont:[UIFont systemFontOfSize:13]];
    
    UILabel *lab_xiangqing33 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 115, CGRectGetMaxY(lab_xiangqing2.frame) + 10, 100, 13)];
    [self.v_detail addSubview:lab_xiangqing33];
    [lab_xiangqing33 setText:[NSString stringWithFormat:@"-%@ 元",self.commonOrderEntity.discountAmount]];
    [lab_xiangqing33 setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    [lab_xiangqing33 setFont:[UIFont systemFontOfSize:13]];
    [lab_xiangqing33 setTextAlignment:NSTextAlignmentRight];
    
    UIImageView *img4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab_xiangqing3.frame) + 10, SCREEN_WIDTH, 0.5)];
    [self.v_detail addSubview:img4];
    [img4 setImage:[UIImage imageNamed:@"02-04取消原因@2x_02"]];
    
    UILabel *lab_zongPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img4.frame) + 10, SCREEN_WIDTH - 15, 17)];
    [self.v_detail addSubview:lab_zongPrice];
    lab_zongPrice.font = [UIFont systemFontOfSize:17];
    [lab_zongPrice setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
    [lab_zongPrice setTextAlignment:NSTextAlignmentRight];
    [lab_zongPrice setText:[NSString stringWithFormat:@"总计： %@ 元",self.commonOrderEntity.payAmount]];
    
    UILabel *lab_dafen = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.v_detail.frame) + 20, SCREEN_WIDTH, 13)];
    [self.scl_back addSubview:lab_dafen];
    lab_dafen.font = [UIFont systemFontOfSize:13];
    [lab_dafen setTextColor:[UIColor colorWithHexString:@"#4a4a4a"]];
    [lab_dafen setTextAlignment:NSTextAlignmentCenter];
    [lab_dafen setText:@"已评价"];
    
    self.btn_all = [NSMutableArray array];
    for (int i = 1; i < 6; i++) {
        UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 27 * 5 - 22.5 * 4) / 2 + (i - 1) * 27 + (i - 1) * 22.5,CGRectGetMaxY(lab_dafen.frame) + 25, 27, 26)];
        [btn setBackgroundImage:[UIImage imageNamed:@"star_disSelect"] forState:UIControlStateNormal];
        [self.scl_back addSubview:btn];
        [btn setHighlighted:NO];
        [self.btn_all addObject:btn];
    }
    self.lab_pingjia = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab_dafen.frame) + 75, SCREEN_WIDTH, 17)];
    [self.scl_back addSubview:self.lab_pingjia];
    self.lab_pingjia.font = [UIFont systemFontOfSize:17];
    [self.lab_pingjia setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
    [self.lab_pingjia setTextAlignment:NSTextAlignmentCenter];
    
    self.v_pingjia = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.lab_pingjia.frame) + 20, SCREEN_WIDTH - 30, 88)];
    [self.scl_back addSubview:self.v_pingjia];
//    self.v_pingjia.layer.borderWidth = 0.5;
//    self.v_pingjia.layer.borderColor = [[UIColor colorWithHexString:@"#dbdbdb"] CGColor];
    
    
    self.evaluteView = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(5, 5, self.v_pingjia.frame.size.width - 10, self.v_pingjia.frame.size.height - 10)];
    [self.v_pingjia addSubview:self.evaluteView];
    self.evaluteView.tag = 1001;
    self.evaluteView.editable = NO;
    [self.evaluteView setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    [self.evaluteView setFont:[UIFont systemFontOfSize:17]];
    [self.evaluteView setTextColor:[UIColor colorWithHexString:@"#929292"]];
    
    int i = self.commonOrderEntity.remarkStars;
    
    for (int j = 0; j < i; j++) {
        UIButton *btn = [self.btn_all objectAtIndex:j];
        [btn setBackgroundImage:[UIImage imageNamed:@"star_select"] forState:UIControlStateNormal];
    }
    switch (i) {
        case 1:
            [self.lab_pingjia setText:@"不满意"];
            break;
        case 2:
            [self.lab_pingjia setText:@"不太满意"];
            break;
        case 3:
            [self.lab_pingjia setText:@"一般"];
            break;
        case 4:
            [self.lab_pingjia setText:@"比较满意"];
            break;
        case 5:
            [self.lab_pingjia setText:@"非常满意"];
            break;
        default:
            break;
    }
    if (self.commonOrderEntity.remarkDetail.length > 0) {
        [self.v_pingjia setHidden:NO];
        [self.evaluteView setText:[NSString stringWithFormat:@"您的评价：%@",self.commonOrderEntity.remarkDetail]];
        [self.scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.v_pingjia.frame) + 40)];
        
    }else{
        [self.v_pingjia setHidden:YES];
        [self.scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.lab_pingjia.frame) + 40)];
    }

}

-(void)NavLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)NavRightAction{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"联系客服" message:[LoginStorage phonenum] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认拨打", nil];
    alert.tag = 11;
    alert.delegate = self;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 11) {
        if (buttonIndex == 1) {
            NSString *str1 = @"tel://";
            NSString *str2 = [LoginStorage phonenum];
            NSString *stt = [NSString stringWithFormat:@"%@%@",str1,str2];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stt]];
        }
    }
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
