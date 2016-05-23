//
//  PayViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/2/20.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "PayViewController.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "WXApi.h"
#import "Toast+UIView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "EvaluateViewController.h"

@interface PayViewController ()
@property (nonatomic ,strong)UIButton *btn_weixin;
@property (nonatomic ,strong)UIButton *btn_zhifubao;
@property (nonatomic)int btnSelect;  //1为选择微信   2为选择支付宝
@property (nonatomic ,strong)AFNManager *manager;
@property (nonatomic ,strong)NSString *out_trade_no;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付订单";
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F6F7"]];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor colorWithHexString:@"#4A4A4A"],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:17]};
    UIButton *btnl = [[UIButton alloc]initWithFrame:CGRectMake(15, 21.5, 20, 20)];
    [btnl setBackgroundImage:[UIImage imageNamed:@"Rectangle 91 + Line + Line Copy"] forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc]initWithCustomView:btnl];
    self.navigationItem.leftBarButtonItem = btnleft;
    [btnl addTarget:self action:@selector(NavLeftAction) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinjieguotongzhi) name:@"weixinjieguo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinshibaitongzhi) name:@"weixinshibai" object:nil];
    // Do any additional setup after loading the view.
    [self onCreate];
}

-(void)onCreate{
    UIView *v_back = [[UIView alloc]initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 158)];
    [self.view addSubview:v_back];
    [v_back setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [v_back addSubview:img1];
    [img1 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
    [v_back addSubview:img2];
    [img2 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    UIImageView *img3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100.5, SCREEN_WIDTH, 0.5)];
    [v_back addSubview:img3];
    [img3 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    UIImageView *img4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 157.5, SCREEN_WIDTH, 0.5)];
    [v_back addSubview:img4];
    [img4 setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E8"]];
    
    UILabel *lab_price = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 70, 16.5)];
    [v_back addSubview:lab_price];
    [lab_price setTextColor:[UIColor colorWithHexString:@"#969696"]];
    [lab_price setFont:[UIFont systemFontOfSize:14]];
    [lab_price setText:@"还需支付："];
    
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(85, 15, 100, 16.5)];
    [v_back addSubview:price];
    [price setText:[NSString stringWithFormat:@"%@元",self.totalAmount]];
    [price setTextColor:[UIColor colorWithHexString:@"#FA6262"]];
    [price setFont:[UIFont systemFontOfSize:16]];
    
    UIImageView *img_weixin = [[UIImageView alloc]initWithFrame:CGRectMake(16, 52.5, 40, 40)];
    [v_back addSubview:img_weixin];
    [img_weixin setImage:[UIImage imageNamed:@"wechat"]];
    
    UILabel *lab_weixin = [[UILabel alloc]initWithFrame:CGRectMake(70, 54, 100, 18)];
    [v_back addSubview:lab_weixin];
    [lab_weixin setText:@"微信支付"];
    [lab_weixin setTextColor:[UIColor colorWithHexString:@"#333333"]];
    lab_weixin.font = [UIFont systemFontOfSize:16];
    
    UILabel *lab_weixinDetail = [[UILabel alloc]initWithFrame:CGRectMake(70, 76, 220, 16.5)];
    [v_back addSubview:lab_weixinDetail];
    [lab_weixinDetail setText:@"推荐安装微信5.0及以上版本的使用"];
    lab_weixinDetail.textColor = [UIColor colorWithHexString:@"#969696"];
    lab_weixinDetail.font = [UIFont systemFontOfSize:13];
    
    UIImageView *img_zhifubao = [[UIImageView alloc]initWithFrame:CGRectMake(16, 109.5, 40, 40)];
    [v_back addSubview:img_zhifubao];
    [img_zhifubao setImage:[UIImage imageNamed:@"zhifubao"]];
    
    UILabel *lab_zhifubao = [[UILabel alloc]initWithFrame:CGRectMake(70, 111, 100, 18)];
    [v_back addSubview:lab_zhifubao];
    [lab_zhifubao setText:@"支付宝支付"];
    [lab_zhifubao setTextColor:[UIColor colorWithHexString:@"#333333"]];
    lab_zhifubao.font = [UIFont systemFontOfSize:16];
    
    UILabel *lab_zhifubaoDetail = [[UILabel alloc]initWithFrame:CGRectMake(70, 133, 220, 16.5)];
    [v_back addSubview:lab_zhifubaoDetail];
    [lab_zhifubaoDetail setText:@"推荐有支付宝账户的用户使用"];
    lab_zhifubaoDetail.textColor = [UIColor colorWithHexString:@"#969696"];
    lab_zhifubaoDetail.font = [UIFont systemFontOfSize:13];
    
    UIButton *btnWeixin = [[UIButton alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 57)];
    [v_back addSubview:btnWeixin];
    [btnWeixin setBackgroundColor:[UIColor clearColor]];
    [btnWeixin addTarget:self action:@selector(SelectweixinPay) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnzhifubao= [[UIButton alloc]initWithFrame:CGRectMake(0, 44 + 57, SCREEN_WIDTH, 57)];
    [v_back addSubview:btnzhifubao];
    [btnzhifubao setBackgroundColor:[UIColor clearColor]];
    [btnzhifubao addTarget:self action:@selector(SelectzhifubaoPay) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btn_weixin = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 61.5, 22, 22)];
    [v_back addSubview:self.btn_weixin];
    [self.btn_weixin setBackgroundImage:[UIImage imageNamed:@"icon_select_active"] forState:UIControlStateNormal];
    [self.btn_weixin addTarget:self action:@selector(SelectweixinPay) forControlEvents:UIControlEventTouchUpInside];
    self.btnSelect = 1;
    
    self.btn_zhifubao = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 118.5, 22, 22)];
    [v_back addSubview:self.btn_zhifubao];
    [self.btn_zhifubao setBackgroundImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
    [self.btn_zhifubao addTarget:self action:@selector(SelectzhifubaoPay) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnPay = [[UIButton alloc]initWithFrame:CGRectMake(15, 208.5, SCREEN_WIDTH - 30, 44)];
    [self.view addSubview:btnPay];
    [btnPay setBackgroundColor:[UIColor colorWithHexString:@"#FA6262"]];
    [btnPay setTitle:@"确认支付" forState:UIControlStateNormal];
    btnPay.titleLabel.font = [UIFont systemFontOfSize:18];
    btnPay.layer.cornerRadius = 3;
    btnPay.layer.masksToBounds = YES;
    [btnPay addTarget:self action:@selector(btnPayAction) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)btnPayAction{
    if (self.btnSelect == 1) {
        //微信支付
        if ([WXApi isWXAppInstalled] == YES) {
            
            [self weixinPay];
            [self.view makeToastActivity];
        }else{
            [self.view makeToast:@"抱歉，您尚未安装微信。" duration:1.0 position:@"center"];
        }
    }else{
        //支付宝支付
        [self zhifubaoPay];
        [self.view makeToastActivity];
    }
    
}

-(void)SelectweixinPay{
    [self.btn_weixin setBackgroundImage:[UIImage imageNamed:@"icon_select_active"] forState:UIControlStateNormal];
    [self.btn_zhifubao setBackgroundImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
    self.btnSelect = 1;
}

-(void)weixinPay{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,CreateWeiXinPay];
    NSString *DeviceIp = [self deviceIPAdress];
    NSDictionary *dic = @{@"appid":@"wxca05a9ac9c6686df",@"mch_id":@"1308372701",@"body":@"商品描述",@"out_trade_no":self.orderNo,@"spbill_create_ip":DeviceIp,@"trade_type":@"APP",@"pay_type":@"0",@"notify_url":@"http://sr.haohushi.me/quhu/accompany/public/pay/APP/wxPayNotify"};
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        NSLog(@"微信预付订单生成结果:%@",responseDic);

        [self.view hideToastActivity];
        if ([Status isEqualToString:SUCCESS]) {
            
            self.out_trade_no = [[responseDic objectForKey:@"data"] objectForKey:@"out_trade_no"];
            
            PayReq *request = [[PayReq alloc] init];
            
            request.partnerId = [[responseDic objectForKey:@"data"] objectForKey:@"partnerid"];
            request.nonceStr = [[responseDic objectForKey:@"data"] objectForKey:@"noncestr"];
            request.package = [[responseDic objectForKey:@"data"] objectForKey:@"package"];
            request.sign = [[responseDic objectForKey:@"data"] objectForKey:@"sign"];
            request.prepayId = [[responseDic objectForKey:@"data"] objectForKey:@"prepayid"];
            request.timeStamp = [[[responseDic objectForKey:@"data"] objectForKey:@"timestamp"] intValue];
            
            [WXApi sendReq:request];
        }else{
            FailMessage;
        }
        
    } fail:^(NSError *error) {
        NSLog(@"error == %@",error);
        [self.view hideToastActivity];
        NetError;
    }];

}

-(void)weixinjieguotongzhi{
    self.manager = [[AFNManager alloc]init];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,SelectWXPay];
    NSDictionary *dic = @{@"appid":@"wxca05a9ac9c6686df",@"mch_id":@"1308372701",@"out_trade_no":self.out_trade_no,@"trade_type":@"APP"};
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        NSLog(@"微信支付回调结果:%@",responseDic);
        [self.view hideToastActivity];
        if ([Status isEqualToString:SUCCESS]) {

            [self.view makeToast:@"支付成功" duration:1.0 position:@"center"];
            [NSTimer scheduledTimerWithTimeInterval:1.5
                                             target:self
                                           selector:@selector(PaySuccessComplete)
                                           userInfo:nil
                                            repeats:NO];

        }else{
            FailMessage;
        }
    } fail:^(NSError *error) {
        NetError;
    }];
}

-(void)weixinshibaitongzhi{
    [self.view makeToast:@"支付未完成,请稍后再试" duration:1.0 position:@"center"];
}

-(void)PaySuccessComplete{
    //    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    EvaluateViewController *vc = [[EvaluateViewController alloc]init];
    vc.orderId = self.str_OrderId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)SelectzhifubaoPay{
    [self.btn_zhifubao setBackgroundImage:[UIImage imageNamed:@"icon_select_active"] forState:UIControlStateNormal];
    [self.btn_weixin setBackgroundImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
    self.btnSelect = 2;
    
}

-(void)zhifubaoPay{
    NSString *strUrl = [NSString stringWithFormat:@"%@/quhu/accompany/user/pay/alipay/APP/generatePayParams",Development];
    NSDictionary *dic = @{@"orderNo":self.orderNo};
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        [self.view hideToastActivity];
        if ([Status isEqualToString:SUCCESS]) {
            [self.view hideToastActivity];
            NSString *appScheme = @"haohushi";
            NSString *orderStr = [[responseDic objectForKey:@"data"] objectForKey:@"paramStr"];
            
            [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
               
               
                if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
                    
                    [self.view makeToast:@"支付成功" duration:1.0 position:@"center"];
                    [NSTimer scheduledTimerWithTimeInterval:1.5
                                                     target:self
                                                   selector:@selector(PaySuccessComplete)
                                                   userInfo:nil
                                                    repeats:NO];
                        
                }else {
                        
                    [self.view makeToast:@"支付未完成,请稍后再试" duration:1.0 position:@"center"];
 
                    }
            }];
        }
    } fail:^(NSError *error) {
        [self.view hideToastActivity];
        NetError;
    }];

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

-(void)NavLeftAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
