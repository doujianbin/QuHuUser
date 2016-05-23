//
//  CancelOrderDetailViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/24.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "CancelOrderDetailViewController.h"
#import "CommonOrderEntity.h"
#import "Toast+UIView.h"

@interface CancelOrderDetailViewController ()<UIAlertViewDelegate>
@property (nonatomic ,strong)AFNManager *manager;
@property (nonatomic ,strong)CommonOrderEntity *commonOrderEntity;
@property (nonatomic ,strong)UIView *v_total;
@end

@implementation CancelOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#e8e8e8"]];
    self.title = @"订单";
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
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
    NSString *nurseName = [self.commonOrderEntity.nurse objectForKey:@"nurseName"];
    if (nurseName.length > 0) {
        // 有护士接过单
        self.v_total = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        [self.view addSubview:self.v_total];
        [self.v_total setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *img_head = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        img_head.layer.cornerRadius = 30;
        img_head.layer.masksToBounds = YES;
        [self.v_total addSubview:img_head];
        if ([[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"] isKindOfClass:[NSNull class]]) {
            [img_head setImage:[UIImage imageNamed:@"ic_个人中心"]];
        }else{
            
            [img_head sd_setImageWithURL:[NSURL URLWithString:[self.commonOrderEntity.nurse objectForKey:@"nursePortrait"]] placeholderImage:[UIImage imageNamed:@"ic_个人中心"]];
        }
        UILabel *lab_nurseName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_head.frame) + 15, 35, 200, 16)];
        [self.v_total addSubview:lab_nurseName];
        [lab_nurseName setText:[self.commonOrderEntity.nurse objectForKey:@"nurseName"]];
        
        lab_nurseName.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        lab_nurseName.font = [UIFont systemFontOfSize:17];
        
        UIImageView *imgline1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img_head.frame) + 15, SCREEN_WIDTH, 0.5)];
        [self.v_total addSubview:imgline1];
        [imgline1 setBackgroundColor:[UIColor colorWithHexString:@"#dbdcdd"]];
        
        UIImageView *imgline2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgline1.frame) + 28, SCREEN_WIDTH, 0.5)];
        [self.v_total addSubview:imgline2];
        [imgline2 setBackgroundColor:[UIColor colorWithHexString:@"#dbdcdd"]];
        
        UILabel *lab_wenzi = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgline1.frame), SCREEN_WIDTH, CGRectGetMaxY(imgline2.frame) - CGRectGetMaxY(imgline1.frame))];
        [self.v_total addSubview:lab_wenzi];
        [lab_wenzi setText:@"已关闭"];
        [lab_wenzi setTextColor:[UIColor colorWithHexString:@"#929292"]];
        lab_wenzi.font = [UIFont systemFontOfSize:17];
        lab_wenzi.textAlignment = NSTextAlignmentCenter;
        
        UILabel *lab_cancelReason = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imgline2.frame) + 15, SCREEN_WIDTH - 30, 17)];
        [self.v_total addSubview:lab_cancelReason];
        [lab_cancelReason setFont:[UIFont systemFontOfSize:17]];
        if (self.commonOrderEntity.cancelReason.length > 0) {
            
            NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"取消原因：%@",self.commonOrderEntity.cancelReason]];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#929292"] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a4a4a"] range:NSMakeRange(5, self.commonOrderEntity.cancelReason.length)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(5, self.commonOrderEntity.cancelReason.length)];
            [lab_cancelReason setAttributedText:myStr];
            
        }else{
            NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc]initWithString:@"取消原因：无"];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#929292"] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a4a4a"] range:NSMakeRange(5, 1)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(5, 1)];
            [lab_cancelReason setAttributedText:myStr];
        }
        
        
    }else{
        // 没护士接过单
        
        self.v_total = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [self.view addSubview:self.v_total];
        [self.v_total setBackgroundColor:[UIColor whiteColor]];
        
        
        UILabel *lab_wenzi = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 28)];
        [self.v_total addSubview:lab_wenzi];
        [lab_wenzi setText:@"已关闭"];
        [lab_wenzi setTextColor:[UIColor colorWithHexString:@"#929292"]];
        lab_wenzi.font = [UIFont systemFontOfSize:17];
        lab_wenzi.textAlignment = NSTextAlignmentCenter;
        
        UIImageView *imgline2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab_wenzi.frame), SCREEN_WIDTH, 0.5)];
        [self.v_total addSubview:imgline2];
        [imgline2 setBackgroundColor:[UIColor colorWithHexString:@"#dbdcdd"]];
        
        UILabel *lab_cancelReason = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imgline2.frame) + 15, SCREEN_WIDTH - 30, 17)];
        [self.v_total addSubview:lab_cancelReason];
        [lab_cancelReason setFont:[UIFont systemFontOfSize:17]];
        if (self.commonOrderEntity.cancelReason.length > 0) {
            
            NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"取消原因：%@",self.commonOrderEntity.cancelReason]];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#929292"] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a4a4a"] range:NSMakeRange(5, self.commonOrderEntity.cancelReason.length)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(5, self.commonOrderEntity.cancelReason.length)];
            [lab_cancelReason setAttributedText:myStr];
            
        }else{
            NSMutableAttributedString *myStr = [[NSMutableAttributedString alloc]initWithString:@"取消原因：无"];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#929292"] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, 5)];
            [myStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4a4a4a"] range:NSMakeRange(5, 1)];
            [myStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(5, 1)];
            [lab_cancelReason setAttributedText:myStr];
        }

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
