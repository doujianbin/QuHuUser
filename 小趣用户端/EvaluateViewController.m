//
//  EvaluateViewController.m
//  小趣用户端
//
//  Created by 窦建斌 on 16/3/22.
//  Copyright © 2016年 窦建斌. All rights reserved.
//

#import "EvaluateViewController.h"
#import "CommonOrderEntity.h"
#import "Toast+UIView.h"
#import "GCPlaceholderTextView.h"
#import "UITextView+ResignKeyboard.h"

@interface EvaluateViewController ()<UIAlertViewDelegate,UITextViewDelegate>
@property (nonatomic ,strong)AFNManager *manager;
@property (nonatomic ,strong)CommonOrderEntity *commonOrderEntity;
@property (nonatomic ,strong)UIView *v_total;
@property (nonatomic ,strong)UIView *v_detail;
@property (nonatomic ,strong)UIScrollView *scl_back;
@property (nonatomic ,strong)UIView *v_pingjia;
@property (nonatomic ,strong)NSMutableArray *btn_all;
@property (nonatomic ,strong)UILabel *lab_pingjia;
@property (nonatomic ,strong)GCPlaceholderTextView *evaluteView;
@property (nonatomic ,strong)NSString *starValue;
@property (nonatomic ,strong)UIView *evlauteBack;

@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
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

//        if (self.commonOrderEntity.couponType == 1)
//        {
//            CGFloat couponValue = self.commonOrderEntity.couponValue * 10;
//            [lab_xiangqing33 setText:[NSString stringWithFormat:@"%.f折",couponValue]];
//        }
//        if(self.commonOrderEntity.couponType == 2)
//        {
//            [lab_xiangqing33 setText:[NSString stringWithFormat:@"-%d元",(int)self.commonOrderEntity.couponValue]];
//        }
//        if (self.commonOrderEntity.couponType == 3) {
//            [lab_xiangqing33 setText:[NSString stringWithFormat:@"-%@元",self.commonOrderEntity.discountAmount]];
//        }
    
    [lab_xiangqing33 setText:[NSString stringWithFormat:@"-%@元",self.commonOrderEntity.discountAmount]];
    
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
    [lab_dafen setText:@"请为服务您的护士打分哦"];
    
    self.btn_all = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 27 * 5 - 22.5 * 4) / 2 + i * 27 + i * 22.5,CGRectGetMaxY(lab_dafen.frame) + 25, 27, 26)];
        [btn setBackgroundImage:[UIImage imageNamed:@"star_disSelect"] forState:UIControlStateNormal];
        [self.scl_back addSubview:btn];
        [btn setHighlighted:NO];
        [btn setTag:i];
        [btn addTarget:self action:@selector(btn_pingjiaAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_all addObject:btn];
    }
    
    self.lab_pingjia = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab_dafen.frame) + 75, SCREEN_WIDTH, 17)];
    [self.scl_back addSubview:self.lab_pingjia];
    self.lab_pingjia.font = [UIFont systemFontOfSize:17];
    [self.lab_pingjia setTextColor:[UIColor colorWithHexString:@"#fa6262"]];
    [self.lab_pingjia setTextAlignment:NSTextAlignmentCenter];
    //    [self.lab_pingjia setText:@"啊实打实的"];
    
    self.v_pingjia = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.lab_pingjia.frame) + 20, SCREEN_WIDTH - 30, 88)];
    [self.scl_back addSubview:self.v_pingjia];
    self.v_pingjia.layer.borderWidth = 0.5;
    self.v_pingjia.layer.borderColor = [[UIColor colorWithHexString:@"#dbdbdb"] CGColor];
    [self.v_pingjia setHidden:YES];
    
    
    self.evaluteView = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(5, 5, self.v_pingjia.frame.size.width - 10, self.v_pingjia.frame.size.height - 10)];
    [self.v_pingjia addSubview:self.evaluteView];
    self.evaluteView.delegate = self;
    self.evaluteView.tag = 1001;
    [self.evaluteView setNormalInputAccessory];
    [self.evaluteView setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F9"]];
    [self.evaluteView setFont:[UIFont systemFontOfSize:17]];
    [self.evaluteView setTextColor:[UIColor colorWithHexString:@"#929292"]];
    [self.evaluteView setPlaceholder:@"请写下您的建议或意见"];
    
    UIButton *btn_pingjia = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 64, SCREEN_WIDTH, 44)];
    [self.view addSubview:btn_pingjia];
    [btn_pingjia setBackgroundColor:[UIColor colorWithHexString:@"#fa6262"]];
    [btn_pingjia setTitle:@"评价" forState:UIControlStateNormal];
    [btn_pingjia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_pingjia.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn_pingjia addTarget:self action:@selector(evluateTijiao) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scl_back setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.v_pingjia.frame) + 10 + 64)];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tgrAction)];
    [self.view addGestureRecognizer:tgr];
    
}

-(void)btn_pingjiaAction:(UIButton *)sender{
    for (UIButton  *btn in self.btn_all) {
        [btn setBackgroundImage:[UIImage imageNamed:@"star_disSelect"] forState:UIControlStateNormal];
    }
    for (int i = 0; i < sender.tag + 1; i++) {
        UIButton *btn = [self.btn_all objectAtIndex:i];
        [btn setBackgroundImage:[UIImage imageNamed:@"star_select"] forState:UIControlStateNormal];
    }
    if (sender.tag > 1) {
        [self.v_pingjia setHidden:YES];
    }else{
        [self.v_pingjia setHidden:NO];
    }
    switch (sender.tag) {
        case 0:
            [self.lab_pingjia setText:@"不满意"];
            self.starValue = @"1";
            break;
        case 1:
            [self.lab_pingjia setText:@"不太满意"];
            self.starValue = @"2";
            break;
        case 2:
            [self.lab_pingjia setText:@"一般"];
            self.starValue = @"3";
            break;
        case 3:
            [self.lab_pingjia setText:@"比较满意"];
            self.starValue = @"4";
            break;
        case 4:
            [self.lab_pingjia setText:@"非常满意"];
            self.starValue = @"5";
            break;
        default:
            break;
    }
}

-(void)evluateTijiao{
    if (self.starValue == nil) {
        [self.view makeToast:@"请选择星级" duration:1.0 position:@"center"];
        return;
    }
    if ([self.starValue isEqualToString:@"1"] || [self.starValue isEqualToString:@"2"]) {
        if (self.evaluteView.text.length > 0) {
            
        }else{
            [self.view makeToast:@"请写下您的建议或意见" duration:1.0 position:@"center"];
            return;
        }
    }else{
        self.evaluteView.text = @"";
    }
    
    NSDictionary *dic = @{@"orderId":self.orderId,@"stars":self.starValue,@"detail":self.evaluteView.text};
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Development,RemarkOrder];
    self.manager = [[AFNManager alloc]init];
    [self.manager RequestJsonWithUrl:strUrl method:@"POST" parameter:dic result:^(id responseDic) {
        if ([Status isEqualToString:SUCCESS]) {
            
            [self addEvaluteViewSuccess];
        }else{
            FailMessage;
        }
    } fail:^(NSError *error) {
        NetError;
    }];
}

-(void)addEvaluteViewSuccess{
    self.evlauteBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view.window addSubview:self.evlauteBack];
    [self.evlauteBack setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.5]];
    UIImageView *img_evlaute = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.133, SCREEN_HEIGHT * 0.39, SCREEN_WIDTH * 0.734, SCREEN_HEIGHT * 0.262)];
    [self.evlauteBack addSubview:img_evlaute];
    [img_evlaute setImage:[UIImage imageNamed:@"evlatueSuccess"]];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(NavLeftAction)
                                   userInfo:nil
                                    repeats:NO];
}


-(void)NavLeftAction{
    [self.evlauteBack removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
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

-(void)textViewDidBeginEditing:(UITextView *)textView{
    UIView *view = self.view;
    float textY = 0;
    if (textView.tag == 1001) {
        textY = CGRectGetMaxY(self.v_pingjia.frame) - self.scl_back.contentOffset.y + 64;
    }
    float bottomY = SCREEN_HEIGHT -textY;
    //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度
    if(bottomY < 216 + 40)
    {
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:0.5];
        if (bottomY <= 0) {
            bottomY = 0;
        }
        view.frame = CGRectMake(0,- (216 + 40 - bottomY), 320, view.frame.size.height);
        [UIView commitAnimations];//设置调整界面的动画效果
    }
}

//
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.evaluteView.text.length > 60) {
        self.evaluteView.text = [self.evaluteView.text substringToIndex:60];
    }
    UIView *view = (UIView *)self.view;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:0.5];
    view.frame = CGRectMake(0,64, SCREEN_WIDTH, view.frame.size.height);
    [UIView commitAnimations];//设置调整界面的动画效果
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView == self.evaluteView) {
        if (text.length == 0)
            return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > 60) {
            return NO;
        }
        if (text.length < 60) {
            
        }
        if (existedLength - selectedLength + replaceLength == 60) {
            
        }
    }
    return YES;
}

-(void)tgrAction{
    [self.evaluteView resignFirstResponder];
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
